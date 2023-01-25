import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treboard/models/draw_mode.dart';
import 'package:treboard/providers/board_provider.dart';

import '../models/stroke.dart';

class BoardCanvas extends ConsumerStatefulWidget {
  const BoardCanvas({
    Key? key,
  });

  @override
  _BoardCanvasState createState() => _BoardCanvasState();
}

class _BoardCanvasState extends ConsumerState<BoardCanvas> {
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.precise,
      child: Stack(
        children: [
          buildAllSketches(context),
          buildCurrentPath(context),
        ],
      ),
    );
  }

  void onPointerMove(PointerMoveEvent details, BuildContext context) {
    ref.read(boardProvider).currentStroke = Stroke.fromDrawMode(
        Stroke(
          points: [details.position],
          width: ref.read(boardProvider).penWidth,
        ),
        ref.read(boardProvider).drawingMode);
  }

  void onPointerDown(PointerDownEvent details, BuildContext context) {
    ref.read(boardProvider).currentStroke = Stroke.fromDrawMode(
        Stroke(
          points: [details.position],
          width: ref.read(boardProvider).penWidth,
        ),
        ref.read(boardProvider).drawingMode);
  }

  void onPointerUp(PointerUpEvent details) {
    ref.read(boardProvider).setAllStrokes(
        List<Stroke>.from(ref.read(boardProvider).allStrokes)
          ..add(ref.read(boardProvider).currentStroke!));
    ref.read(boardProvider).currentStroke = null;
  }

  Widget buildAllSketches(BuildContext context) {
    return SizedBox(
      height: ref.read(boardProvider).height,
      width: ref.read(boardProvider).width,
      child: RepaintBoundary(
        key: ref.read(boardProvider).canvasGlobalKey,
        child: Container(
          color: Colors.transparent,
          child: GridPaper(
            color: Colors.grey,
            child: CustomPaint(
              painter: Painter(ref.read(boardProvider).allStrokes),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCurrentPath(BuildContext context) {
    return Listener(
      onPointerDown: (details) => onPointerDown(details, context),
      onPointerMove: (details) => onPointerMove(details, context),
      onPointerUp: onPointerUp,
      child: RepaintBoundary(
        child: SizedBox(
          height: ref.read(boardProvider).height,
          width: ref.read(boardProvider).width,
          child: CustomPaint(
            painter: Painter(
              ref.read(boardProvider).currentStroke == null
                  ? []
                  : [ref.read(boardProvider).currentStroke!],
            ),
          ),
        ),
      ),
    );
  }
}

class Painter extends CustomPainter {
  Painter(this.strokes);
  final List<Stroke> strokes;
  Rect? rect;
  @override
  void paint(Canvas canvas, Size size) async {
    void drawStrokes(Paint paint) {
      for (Stroke stroke in strokes) {
        paint.color = stroke.color;
        paint.strokeWidth = stroke.width;
        for (int i = 0; i < stroke.points.length - 1; i++) {
          canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
        }
      }
    }

    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    drawStrokes(paint);
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => true;
}
