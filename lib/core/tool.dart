import 'package:flutter/material.dart';
import 'package:treboard/models/stroke_models.dart';
import 'package:treboard/providers/board_provider.dart';

enum ToolGroup {
  pen,
  utility,
}

enum ToolType {
  pen,
  eraser,
}

// create an enum that maps a tooltype to an icon
class Tool {
  Tool();

  final ToolType type = ToolType.pen;
  void use(BoardProvider provider, dynamic details) {}

  // get icon given a tooltype
  IconData getIcon() {
    switch (type) {
      case ToolType.pen:
        return Icons.edit;
      case ToolType.eraser:
        return Icons.cleaning_services_outlined;
    }
  }
}
