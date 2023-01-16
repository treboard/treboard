import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:gehenna/core/tool.dart';
import 'package:gehenna/widgets/whiteboard.dart';

class BoardProvider extends ChangeNotifier {
  Tool tool = Tool(ToolType.pen);
  Color penColor;
  double penWidth;
  List<Stroke> strokes = <Stroke>[];
  List<Stroke> cache = <Stroke>[];

  BoardProvider({
    this.penColor = Colors.black,
    this.penWidth = 2.0,
  });

  void addStroke(Stroke stroke) {
    strokes.add(stroke);

    // add to cache
    if (cache.length > 10) {
      cache.removeAt(0);
    }
    cache.add(stroke);

    notifyListeners();
  }

  // clear cache
  void setTool(Tool tool) {
    this.tool = tool;
    notifyListeners();
  }

  void setPenColor(Color color) {
    penColor = color;
    notifyListeners();
  }

  void setPenWidth(double width) {
    penWidth = width;
    notifyListeners();
  }

  void undo() {
    if (strokes.isNotEmpty) {
      strokes.removeLast();
      notifyListeners();
    }
  }

  void redo() {
    if (cache.isNotEmpty) {
      strokes.add(cache.last);
      cache.removeLast();
      notifyListeners();
    }
  }
}

final boardProvider = ChangeNotifierProvider((ref) => BoardProvider());
