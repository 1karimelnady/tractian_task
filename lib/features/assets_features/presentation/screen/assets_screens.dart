import 'package:flutter/material.dart';
import 'package:tractian_task/core/utils/colors_manager.dart';
import 'package:tractian_task/features/assets_features/data/data_source/assets_remote_data_source.dart';
import 'package:tractian_task/features/assets_features/data/models/assets_model.dart';
import 'package:tractian_task/features/assets_features/data/models/location_model.dart';
import 'package:tractian_task/features/assets_features/data/models/tree_node_model.dart';
import 'package:tractian_task/features/assets_features/presentation/widgets/filter_button.dart';
import 'package:tractian_task/features/assets_features/presentation/widgets/tree_node_widget.dart';

class AssetsScreen extends StatefulWidget {
  final String companyId;
  final String companyName;

  const AssetsScreen({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  List<Location> locations = [];
  List<Asset> assets = [];
  List<TreeNode> treeNodes = [];
  List<TreeNode> filteredTreeNodes = [];

  String searchQuery = '';
  bool energySensorFilter = false;
  bool criticalStatusFilter = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final locationsData = await ApiService.getCompanyLocations(
        widget.companyId,
      );
      final assetsData = await ApiService.getCompanyAssets(widget.companyId);

      setState(() {
        locations = locationsData;
        assets = assetsData;
        treeNodes = buildTree();
        filteredTreeNodes = treeNodes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<TreeNode> buildTree() {
    Map<String, TreeNode> nodeMap = {};

    for (final location in locations) {
      nodeMap[location.id] = TreeNode(
        id: location.id,
        name: location.name,
        type: TreeNodeType.location,
        children: [],
      );
    }

    for (final asset in assets) {
      nodeMap[asset.id] = TreeNode(
        id: asset.id,
        name: asset.name,
        type: asset.isComponent ? TreeNodeType.component : TreeNodeType.asset,
        children: [],
        sensorType: asset.sensorType,
        status: asset.status,
      );
    }

    for (final location in locations) {
      if (location.parentId != null && nodeMap.containsKey(location.parentId)) {
        nodeMap[location.parentId]!.children.add(nodeMap[location.id]!);
      }
    }

    for (final asset in assets) {
      if (asset.locationId != null && nodeMap.containsKey(asset.locationId)) {
        nodeMap[asset.locationId]!.children.add(nodeMap[asset.id]!);
      } else if (asset.parentId != null &&
          nodeMap.containsKey(asset.parentId)) {
        nodeMap[asset.parentId]!.children.add(nodeMap[asset.id]!);
      }
    }

    List<TreeNode> rootNodes = [];

    for (final location in locations) {
      if (location.parentId == null) {
        rootNodes.add(nodeMap[location.id]!);
      }
    }

    for (final asset in assets) {
      if (asset.locationId == null && asset.parentId == null) {
        rootNodes.add(nodeMap[asset.id]!);
      }
    }

    return rootNodes;
  }

  void applyFilters() {
    setState(() {
      if (searchQuery.isEmpty && !energySensorFilter && !criticalStatusFilter) {
        filteredTreeNodes = treeNodes;
      } else {
        filteredTreeNodes = filterTree(treeNodes);
      }
    });
  }

  List<TreeNode> filterTree(List<TreeNode> nodes) {
    List<TreeNode> filtered = [];

    for (final node in nodes) {
      final filteredChildren = filterTree(node.children);
      bool shouldIncludeNode = false;

      if (searchQuery.isNotEmpty) {
        if (node.name.toLowerCase().contains(searchQuery.toLowerCase())) {
          shouldIncludeNode = true;
        }
      }

      if (energySensorFilter && node.sensorType == 'energy') {
        shouldIncludeNode = true;
      }

      if (criticalStatusFilter && node.status == 'alert') {
        shouldIncludeNode = true;
      }

      if (searchQuery.isEmpty && !energySensorFilter && !criticalStatusFilter) {
        shouldIncludeNode = true;
      }

      if (filteredChildren.isNotEmpty) {
        shouldIncludeNode = true;
      }

      if (shouldIncludeNode) {
        filtered.add(
          TreeNode(
            id: node.id,
            name: node.name,
            type: node.type,
            children: filteredChildren,
            sensorType: node.sensorType,
            status: node.status,
            isExpanded: node.isExpanded || filteredChildren.isNotEmpty,
          ),
        );
      }
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorsManager.appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Assets',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    searchQuery = value;
                    applyFilters();
                  },
                  decoration: InputDecoration(
                    fillColor: ColorsManager.cardColor,
                    filled: true,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                      color: ColorsManager.textGray,
                    ),
                    hintText: 'Buscar Ativo ou Local',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: ColorsManager.textGray,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    FilterButton(
                      icon: Icons.bolt,
                      label: 'Sensor de Energia',
                      isActive: energySensorFilter,
                      onTap: () {
                        setState(() {
                          energySensorFilter = !energySensorFilter;
                        });
                        applyFilters();
                      },
                    ),
                    SizedBox(width: 8),
                    FilterButton(
                      icon: Icons.error_outline,
                      label: 'Crítico',
                      isActive: criticalStatusFilter,
                      onTap: () {
                        setState(() {
                          criticalStatusFilter = !criticalStatusFilter;
                        });
                        applyFilters();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Container(
                  color: ColorsManager.dividerGray,
                  height: 1.5,
                  width: double.infinity,
                ),
              ],
            ),
          ),
          Expanded(
            child:
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView(
                      children:
                          filteredTreeNodes
                              .map(
                                (node) => TreeNodeWidget(
                                  node: node,
                                  onToggle: (nodeId) {
                                    setState(() {
                                      toggleNode(filteredTreeNodes, nodeId);
                                    });
                                  },
                                ),
                              )
                              .toList(),
                    ),
          ),
        ],
      ),
    );
  }

  void toggleNode(List<TreeNode> nodes, String nodeId) {
    for (final node in nodes) {
      if (node.id == nodeId) {
        node.isExpanded = !node.isExpanded;
        return;
      }
      toggleNode(node.children, nodeId);
    }
  }
}
