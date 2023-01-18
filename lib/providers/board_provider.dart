import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:gehenna/core/tool.dart';
import 'package:gehenna/widgets/whiteboard.dart';

class BoardProvider extends ChangeNotifier {
  Tool tool = PenTool();
  Color penColor = Colors.black;
  double penWidth;
  List<Stroke> strokes = <Stroke>[];
  List<Stroke> undoCache = <Stroke>[];
  bool isFraming = false;

// default to center
  Rect frameRect = Rect.fromCenter(
    center: Offset(0, 0),
    width: 100,
    height: 100,
  );

  BoardProvider({
    this.penWidth = 2.0,
  });

  void addStroke(Stroke stroke) {
    strokes.add(stroke);
    undoCache.clear();
    notifyListeners();
  }

  void setFrameRect(Rect rect) {
    frameRect = rect;
    notifyListeners();
  }

  void removeStroke(Offset point) {
    strokes.removeWhere((stroke) {
      return stroke.points.any((p) {
        return (p - point).distance < 10;
      });
    });
    notifyListeners();
  }

  void addPoint(Offset point) {
    strokes.last.points.add(point);
    notifyListeners();
  }

  // clear undoCache
  void setTool(Tool tool) {
    this.tool = tool;
    notifyListeners();
  }

  void setPenColor(Color color) {
    penColor = color;
    notifyListeners();
  }

  void extractText() {
    isFraming = true;
    notifyListeners();
  }

  void setPenWidth(double width) {
    penWidth = width;
    notifyListeners();
  }

  void undo() {
    if (undoCache.length > 10) {
      undoCache.removeAt(0);
    }
    if (strokes.isNotEmpty) {
      undoCache.add(strokes.removeLast());
    }

    notifyListeners();
  }

  void redo() {
    if (undoCache.isNotEmpty) {
      strokes.add(undoCache.removeLast());
    }
    notifyListeners();
  }

  void clear() {
    strokes.clear();

    notifyListeners();
  }
}

final boardProvider = ChangeNotifierProvider((ref) => BoardProvider());
