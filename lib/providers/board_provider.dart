import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:treboard/core/tool.dart';
import 'package:treboard/widgets/whiteboard.dart';

class StrokeBatch {
  List<Stroke> strokes;
  StrokeBatch(this.strokes);
}

class BoardProvider extends ChangeNotifier {
  Tool tool = PenTool();
  Color penColor = Colors.black;
  double penWidth = 2.0;
  List<Stroke> strokes = <Stroke>[];
  bool isFraming = false;
  Uint8List? canvasImage;
  GlobalKey _repaintBoundaryKey = GlobalKey();

  List<StrokeBatch> undoCache = <StrokeBatch>[];
  List<StrokeBatch> redoCache = <StrokeBatch>[];
  List<Stroke> removedStrokes = <Stroke>[];
// default to center
  Rect? frameRect;

  BoardProvider({
    this.penWidth = 2.0,
  });

  get repaintBoundaryKey => _repaintBoundaryKey;

  void saveFrame(Uint8List image) {
    canvasImage = image;
    notifyListeners();
  }

  void toggleFrame() {
    if (isFraming) {
      isFraming = false;
    }
    frameRect = null;
    notifyListeners();
  }

  void addStroke(Stroke stroke) {
    strokes.add(stroke);
    undoCache.add(StrokeBatch([stroke]));
    redoCache.clear();

    notifyListeners();
  }

  void setPenSize(double size) {
    penWidth = size;
    notifyListeners();
  }

  void setFrameRect(Rect rect) {
    frameRect = rect;
    notifyListeners();
  }

  void addUndoBatch(StrokeBatch batch) {
    if (batch.strokes.isNotEmpty) {
      undoCache.add(batch);
    }

    notifyListeners();
  }

  void removeStroke(Offset point, double radius) {
    for (int i = 0; i < strokes.length; i++) {
      Stroke stroke = strokes[i];
      if (stroke.intersects(point, radius)) {
        removedStrokes.add(stroke);
        strokes.removeAt(i);
        print("Added stroke to removedStrokes");
        break;
      }
    }

    notifyListeners();
  }

  void addPoint(Offset point) {
    if (strokes.isNotEmpty) {
      strokes.last.points.add(point);
    }
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
    if (undoCache.length > 10) {
      undoCache.removeAt(0);
    }
    if (strokes.isNotEmpty) {
      redoCache.add(StrokeBatch(strokes));
      strokes.clear();
    }
    if (undoCache.isNotEmpty) {
      strokes.addAll(undoCache.removeLast().strokes);
    }
    notifyListeners();
  }

  void redo() {
    if (redoCache.isNotEmpty) {
      strokes.addAll(redoCache.removeLast().strokes);
    }

    notifyListeners();
  }

  void clear() {
    // undo logic
    if (strokes.isNotEmpty) {
      undoCache.add(StrokeBatch(strokes));
    }
    strokes.clear();

    notifyListeners();
  }
}

final boardProvider = ChangeNotifierProvider((ref) => BoardProvider());
