import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treboard/providers/board_provider.dart';
import 'package:treboard/widgets/whiteboard.dart';
import 'package:treboard/widgets/extractor.dart';

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
    // when the user drags, iterate through all strokes and remove any that intersect with the drag within a bounds.
    // keep in mind that there is an undo batch cache
    StrokeBatch batches = StrokeBatch([]);

    if (details is DragStartDetails) {
      for (Stroke stroke in provider.strokes) {
        if (stroke.points.contains(details.localPosition)) {
          batches.strokes.add(stroke);
        }
      }
      provider.removeStroke(details.localPosition);
    } else if (details is DragUpdateDetails) {
      for (Stroke stroke in provider.strokes) {
        if (stroke.points.contains(details.localPosition)) {
          batches.strokes.add(stroke);
        }
      }
      provider.removeStroke(details.localPosition);
    } else if (details is DragEndDetails) {
      provider.addUndoBatch(
        StrokeBatch(batches.strokes),
      );
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
