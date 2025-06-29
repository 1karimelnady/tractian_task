class TreeNode {
  final String id;
  final String name;
  final TreeNodeType type;
  final List<TreeNode> children;
  final String? sensorType;
  final String? status;
  bool isExpanded;

  TreeNode({
    required this.id,
    required this.name,
    required this.type,
    this.children = const [],
    this.sensorType,
    this.status,
    this.isExpanded = false,
  });
}

enum TreeNodeType { location, asset, component }
