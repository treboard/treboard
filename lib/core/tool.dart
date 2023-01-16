import 'package:flutter/material.dart';

enum ToolType {
  pen,
  eraser,
}

// create an enum that maps a tooltype to an icon
class Tool {
  Tool(this.type);
  final ToolType type;

  static final Map<ToolType, Tool> tools = {
    ToolType.pen: Tool(ToolType.pen),
    ToolType.eraser: Tool(ToolType.eraser),
  };

  static final List<Tool> toolList = [
    Tool(ToolType.pen),
    Tool(ToolType.eraser),
  ];

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
