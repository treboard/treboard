import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gehenna/providers/board_provider.dart';
import 'package:gehenna/widgets/whiteboard.dart';
import 'package:gehenna/widgets/extractor.dart';

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

class PenTool extends Tool {
  @override
  void use(BoardProvider provider, dynamic details) {
    if (details is DragStartDetails) {
      provider.addStroke(Stroke(
        [details.localPosition],
        provider.penColor,
        provider.penWidth,
      ));
    } else if (details is DragUpdateDetails) {
      provider.addPoint(details.localPosition);
    } else if (details is DragEndDetails) {}
  }
}

class EraserTool extends Tool {
  @override
  void use(BoardProvider provider, dynamic details) {
    // when the user drags, iterate through all strokes and remove any that intersect with the drag within a bounds
    if (details is DragStartDetails) {
      provider.removeStroke(details.localPosition);
    } else if (details is DragUpdateDetails) {
      provider.removeStroke(details.localPosition);
    }
  }
}

class ExtractorTool extends Tool {
  @override
  void use(BoardProvider provider, dynamic details) {
    // text extractor widget that shows rectangle around region based on drag.
    // when drag ends, text is extracted and displayed in a note widget

    if (details is DragStartDetails) {}
  }
}
