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

  List<Stroke> redoCache = [];

  int maxUndo = 10;
  int strokeCount = 0;

  GlobalKey canvasGlobalKey;

  Color canvasColor = Colors.white;
  double eraserWidth = 10.0;

  Rect? frameRect;

  bool _canRedo = false;
  get canRedo => _canRedo;
// default to center

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

  void addStroke() {
    allStrokes = List<Stroke>.from(allStrokes)..add(currentStroke!);
    currentStroke = null;
    redoCache.clear();
    _canRedo = false;
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
    final strokes = List<Stroke>.from(allStrokes);
    if (strokes.isNotEmpty) {
      redoCache.add(strokes.removeLast());
      allStrokes = strokes;
      _canRedo = true;
      currentStroke = null;
    }
    notifyListeners();
  }

  void redo() {
    if (redoCache.isNotEmpty) {
      final stroke = redoCache.removeLast();

      _canRedo = redoCache.isNotEmpty;
      allStrokes = [...allStrokes, stroke];
      notifyListeners();
    }
  }

  void clearBoard() {
    allStrokes = [];
    _canRedo = false;
    currentStroke = null;

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
