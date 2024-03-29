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
  Color frameColor = Colors.black.withOpacity(0.2);

  List<Stroke> redoCache = [];

  int maxUndo = 10;
  int strokeCount = 0;

  GlobalKey canvasGlobalKey;
  TransformationController transformationController =
      TransformationController();

  Color canvasColor = Colors.white;
  double eraserWidth = 30.0;

  Rect frameRect = Rect.zero;

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
    frameRect = Rect.zero;
    notifyListeners();
  }

  void zoomIn() {
    transformationController.value = Matrix4.identity()
      ..translate(transformationController.value.getTranslation().x,
          transformationController.value.getTranslation().y)
      ..scale(1.1);
    notifyListeners();
  }

  void zoomOut() {
    transformationController.value = Matrix4.identity()
      ..translate(transformationController.value.getTranslation().x,
          transformationController.value.getTranslation().y)
      ..scale(0.9);
    notifyListeners();
  }

  void setFraming(bool isFraming) {
    this.isFraming = isFraming;
    notifyListeners();
  }

  void addStroke() {
    if (currentStroke == null) return;
    allStrokes = List<Stroke>.from(allStrokes)..add(currentStroke!);
    currentStroke = null;
    redoCache.clear();
    _canRedo = false;
    strokeCount = allStrokes.length;

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
    if (mode == DrawMode.extract) {
      extractText();
    } else {
      isFraming = false;
    }

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
      strokeCount--;
      currentStroke = null;
    }
    notifyListeners();
  }

  void redo() {
    if (redoCache.isNotEmpty) {
      final stroke = redoCache.removeLast();
      strokeCount++;

      _canRedo = redoCache.isNotEmpty;
      allStrokes = [...allStrokes, stroke];
      notifyListeners();
    }
  }

  void clearBoard() {
    allStrokes = [];
    strokeCount = 0;
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
