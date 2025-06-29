import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tractian_task/core/utils/assets_manager.dart';
import 'package:tractian_task/core/utils/colors_manager.dart';
import 'package:tractian_task/features/assets_features/data/models/tree_node_model.dart';

class TreeNodeWidget extends StatelessWidget {
  final TreeNode node;
  final Function(String) onToggle;
  final int depth;

  const TreeNodeWidget({
    super.key,
    required this.node,
    required this.onToggle,
    this.depth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onToggle(node.id),
          child: Container(
            padding: EdgeInsets.only(
              left: 16.0 + (depth * 20.0),
              right: 16.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: Row(
              children: [
                if (node.children.isNotEmpty)
                  Icon(
                    node.isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: 20,
                    color: Colors.grey[600],
                  )
                else
                  SizedBox(width: 20),
                SizedBox(width: 8),

                _getNodeIcon(node.type),

                SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        node.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Roboto',
                          color: Colors.black87,
                        ),
                      ),
                      if (node.sensorType == 'energy')
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.bolt,
                            size: 16,
                            color: ColorsManager.operatingGreen,
                          ),
                        ),
                      if (node.status == 'alert')
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: ColorsManager.criticalRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (node.isExpanded)
          ...node.children.map(
            (child) => TreeNodeWidget(
              node: child,
              onToggle: onToggle,
              depth: depth + 1,
            ),
          ),
      ],
    );
  }

  _getNodeIcon(TreeNodeType type) {
    switch (type) {
      case TreeNodeType.location:
        return SvgPicture.asset(AssetsManager.location);
      case TreeNodeType.asset:
        return SvgPicture.asset(AssetsManager.converter);
      case TreeNodeType.component:
        return SvgPicture.asset(AssetsManager.fan);
    }
  }
}
