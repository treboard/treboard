import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gehenna/widgets/nodes/note.dart';
import 'package:gehenna/widgets/node.dart';

class NodeProvider extends ChangeNotifier {
  List<CustomNode> nodes = <CustomNode>[];

  void addNode(CustomNode node) {
    nodes.add(node);
    notifyListeners();
  }

  void updateNodePosition(CustomNode node, Offset position) {
    node.position = position;
    notifyListeners();
  }

  void removeNode(CustomNode node) {
    nodes.remove(node);
    notifyListeners();
  }
}

final nodeProvider = ChangeNotifierProvider((ref) => NodeProvider());
