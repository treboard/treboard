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
// default to center
  Rect? frameRect = null;

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
    undoCache.add(batch);

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
      undoCache.add(StrokeBatch([strokes.removeLast()]));
    }

    if (undoCache.length > 10) {
      undoCache.removeAt(0);
    }

    notifyListeners();
  }

  void redo() {
    if (undoCache.isNotEmpty) {
      strokes.addAll(undoCache.removeLast().strokes);
    }
    notifyListeners();
  }

  void clear() {
    undoCache.add(StrokeBatch(strokes));
    strokes.clear();

    notifyListeners();
  }
}

final boardProvider = ChangeNotifierProvider((ref) => BoardProvider());
