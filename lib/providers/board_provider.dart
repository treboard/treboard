import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:gehenna/core/tool.dart';
import 'package:gehenna/widgets/whiteboard.dart';

class BoardProvider extends ChangeNotifier {
  Tool tool = PenTool();
  Color penColor = Colors.black;
  double penWidth = 2.0;
  List<Stroke> strokes = <Stroke>[];
  List<Stroke> undoCache = <Stroke>[];
  bool isFraming = false;
  Uint8List? canvasImage;

// default to center
  Rect frameRect = Rect.fromCenter(
    center: Offset(50, 50),
    width: 100,
    height: 100,
  );

  BoardProvider({
    this.penWidth = 2.0,
  });

  void saveFrame(Uint8List image) {
    canvasImage = image;
    notifyListeners();
  }

  void toggleFrame() {
    isFraming = !isFraming;
    notifyListeners();
  }

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
        return (p - point).distance < 20;
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
    // check if tool is not extractor
    if (tool is! ExtractorTool) {
      isFraming = false;
    }
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
    // limit undo to 10
    if (strokes.isNotEmpty) {
      undoCache.add(strokes.removeLast());
    }

    if (undoCache.length > 10) {
      undoCache.removeAt(0);
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
