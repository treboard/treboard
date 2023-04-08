import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:treboard/models/draw_mode.dart';
import 'package:treboard/models/stroke.dart';

class Board {
  Color penColor = Colors.black;
  double penWidth = 2.0;

  bool isFraming = false;
  Uint8List? canvasImage;
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  List<Stroke> allStrokes = [];
  Stroke? currentStroke;
  DrawMode drawingMode = DrawMode.sketch;
  Color frameColor = Colors.black.withOpacity(0.2);

  List<Stroke> redoCache = [];

  int maxUndo = 10;
  int strokeCount = 0;

  TransformationController transformationController =
      TransformationController();

  Color canvasColor = Colors.white;
  double eraserWidth = 30.0;

  Rect frameRect = Rect.zero;

  bool _canRedo = false;
  get canRedo => _canRedo;
// default to center

  get repaintBoundaryKey => _repaintBoundaryKey;

  void saveFrame(Uint8List image) {
    canvasImage = image;
  }

  void toggleFrame() {
    if (isFraming) {
      isFraming = false;
    }
    frameRect = Rect.zero;
  }

  void zoomIn() {
    transformationController.value = Matrix4.identity()
      ..translate(transformationController.value.getTranslation().x,
          transformationController.value.getTranslation().y)
      ..scale(1.1);
  }

  void zoomOut() {
    transformationController.value = Matrix4.identity()
      ..translate(transformationController.value.getTranslation().x,
          transformationController.value.getTranslation().y)
      ..scale(0.9);
  }

  void setFraming(bool isFraming) {
    this.isFraming = isFraming;
  }

  void addStroke() {
    if (currentStroke == null) return;
    allStrokes = List<Stroke>.from(allStrokes)..add(currentStroke!);
    currentStroke = null;
    redoCache.clear();
    _canRedo = false;
    strokeCount = allStrokes.length;
  }

  void setCurrentStroke(Stroke? stroke) {
    currentStroke = stroke;
  }

  void setPenSize(double size) {
    penWidth = size;
  }

  void setFrameRect(Rect rect) {
    frameRect = rect;
  }

  // clear undoCache
  void setMode(DrawMode mode) {
    if (mode == DrawMode.extract) {
      extractText();
    } else {
      isFraming = false;
    }

    drawingMode = mode;
  }

  void setPenColor(Color color) {
    penColor = color;
  }

  void extractText() {
    isFraming = true;
  }

  void setPenWidth(double width) {
    penWidth = width;
  }

  void undo() {
    final strokes = List<Stroke>.from(allStrokes);
    if (strokes.isNotEmpty) {
      redoCache.add(strokes.removeLast());
      allStrokes = strokes;
      _canRedo = true;
      strokeCount--;
      currentStroke = null;
    }
  }

  void redo() {
    if (redoCache.isNotEmpty) {
      final stroke = redoCache.removeLast();
      strokeCount++;

      _canRedo = redoCache.isNotEmpty;
      allStrokes = [...allStrokes, stroke];
    }
  }

  void clearBoard() {
    allStrokes = [];
    strokeCount = 0;
    _canRedo = false;
    currentStroke = null;
  }
}
