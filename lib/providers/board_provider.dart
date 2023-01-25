import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:treboard/core/tool.dart';
import 'package:treboard/models/batch.dart';
import 'package:treboard/models/draw_mode.dart';
import 'package:treboard/models/stroke.dart';

enum DrawState {
  idle,
  drawing,
  erasing,
}

class StackState {
  List<Stroke> strokes = <Stroke>[];

  List<StrokeBatch> undoCache = <StrokeBatch>[];
  List<StrokeBatch> redoCache = <StrokeBatch>[];
  List<Stroke> removedStrokes = <Stroke>[];

  bool get canUndo => undoCache.isNotEmpty;
  bool get canRedo => redoCache.isNotEmpty;

  void copyState(StackState state) {
    strokes = state.strokes;
    undoCache = state.undoCache;
    redoCache = state.redoCache;
    removedStrokes = state.removedStrokes;
  }
}

class BoardProvider extends ChangeNotifier {
  Color penColor = Colors.black;
  double penWidth = 2.0;
  StackState state = StackState();
  bool isFraming = false;
  Uint8List? canvasImage;
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  final double width;
  final double height;
  List<Stroke> allStrokes;
  Stroke? currentStroke;
  DrawMode drawingMode;

  GlobalKey canvasGlobalKey;

  StackState tempState = StackState();

// default to center
  Rect? frameRect;

  BoardProvider(
    this.width,
    this.height,
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
    state.strokes = strokes;
    notifyListeners();
  }

  void addStroke(Stroke stroke) {
    state.strokes.add(stroke);

    // take snapshot of strokes
    StrokeBatch batch = StrokeBatch(state.strokes);
    // add to undo cache
    addUndoBatch(batch);

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
    state.undoCache.add(batch);
    state.removedStrokes.clear();
    state.redoCache.clear();

    notifyListeners();
  }

  void removeStroke(Offset point, double radius) {
    for (int i = 0; i < state.strokes.length; i++) {
      Stroke stroke = state.strokes[i];
      if (stroke.intersects(point, radius)) {
        state.removedStrokes.add(stroke);
        state.strokes.removeAt(i);

        break;
      }
    }

    addUndoBatch(StrokeBatch(state.removedStrokes));

    notifyListeners();
  }

  void addPoint(Offset point) {
    if (state.strokes.isNotEmpty) {
      state.strokes.last.points.add(point);
    }
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
    if (state.canUndo) {
      state.redoCache.add(StrokeBatch(state.strokes));
      state.strokes = state.undoCache.removeLast().strokes;
    }
    notifyListeners();
  }

  void redo() {
    if (state.canRedo) {
      StrokeBatch redoBatch = state.redoCache.removeLast();
      state.undoCache.add(StrokeBatch(state.strokes));
      state.strokes = redoBatch.strokes;
    }

    notifyListeners();
  }

  void clearBoard() {
    // Clearing the board is a state action and as a result,
    // the current state is saved to the undo cache.
    state.undoCache.add(StrokeBatch(state.strokes));
    state.strokes.clear();
    state.redoCache.clear();

    notifyListeners();
  }
}

final boardProvider = ChangeNotifierProvider((ref) => BoardProvider(
    0.0,
    0.0,
    <Stroke>[],
    null,
    DrawMode.sketch,
    GlobalKey(
      debugLabel: 'canvas',
    )));
