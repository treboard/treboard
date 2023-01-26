import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:treboard/models/draw_mode.dart';
import 'package:treboard/models/stroke.dart';

class BoardProvider extends ChangeNotifier {
  Color penColor = Colors.black;
  double penWidth = 2.0;

  bool isFraming = false;
  Uint8List? canvasImage;
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  List<Stroke> allStrokes;
  Stroke? currentStroke;
  DrawMode drawingMode;

  List<List<Stroke>> undoCache = [];
  List<List<Stroke>> redoCache = [];

  bool _canRedo = false;
  bool _canUndo = false;

  int maxUndo = 10;
  int strokeCount = 0;

  GlobalKey canvasGlobalKey;

  bool get canRedo => _canRedo;
  bool get canUndo => _canUndo;

// default to center
  Rect? frameRect;

  BoardProvider(
    this.allStrokes,
    this.currentStroke,
    this.drawingMode,
    this.canvasGlobalKey, {
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

  void setAllStrokes(List<Stroke> strokes) {
    allStrokes = strokes;

    if (undoCache.length >= maxUndo) {
      undoCache.removeAt(0);
    }

    strokeCount = strokes.length;

    notifyListeners();
  }

  void setCurrentStroke(Stroke? stroke) {
    currentStroke = stroke;
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

  // clear undoCache
  void setMode(DrawMode mode) {
    drawingMode = mode;
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
    if (undoCache.isNotEmpty) {
      _canRedo = true;
      redoCache.add(undoCache.removeLast());
      allStrokes = undoCache.isNotEmpty ? undoCache.last : [];

      if (undoCache.isEmpty) {
        _canUndo = false;
      }
    }
    notifyListeners();
  }

  void redo() {
    if (redoCache.isNotEmpty) {
      _canUndo = true;
      undoCache.add(redoCache.removeLast());
      allStrokes = redoCache.isNotEmpty ? redoCache.last : [];

      if (redoCache.isEmpty) {
        _canRedo = false;
      }
    }
    notifyListeners();
  }

  void clearBoard() {
    allStrokes = [];
    undoCache.add(allStrokes);
    redoCache.clear();
    _canUndo = true;
    _canRedo = false;

    notifyListeners();
  }
}

final boardProvider = ChangeNotifierProvider((ref) => BoardProvider(
    <Stroke>[],
    null,
    DrawMode.sketch,
    GlobalKey(
      debugLabel: 'canvas',
    )));
