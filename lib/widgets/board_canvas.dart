import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treboard/models/draw_mode.dart';
import 'package:treboard/providers/board_provider.dart';

import '../models/stroke.dart';

class BoardCanvas extends ConsumerStatefulWidget {
  double width;
  double height;
  BoardCanvas({
    required this.width,
    required this.height,
    Key? key,
  });

  @override
  _BoardCanvasState createState() => _BoardCanvasState();
}

class _BoardCanvasState extends ConsumerState<BoardCanvas> {
  @override
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
    if (details.buttons != kPrimaryMouseButton) return;
    final points =
        List<Offset>.from(ref.read(boardProvider).currentStroke!.points)
          ..add(details.localPosition);
    ref.read(boardProvider).setCurrentStroke(Stroke.fromDrawMode(
        Stroke(
          color: ref.read(boardProvider).penColor,
          points: points,
          width: ref.read(boardProvider).penWidth,
        ),
        ref.read(boardProvider).drawingMode));
  }

  void onPointerDown(PointerDownEvent details, BuildContext context) {
    // check if primaru button is pressed
    if (details.buttons != kPrimaryMouseButton) return;
    ref.read(boardProvider).currentStroke = Stroke.fromDrawMode(
        Stroke(
          color: ref.read(boardProvider).penColor,
          points: [details.localPosition],
          width: ref.read(boardProvider).penWidth,
        ),
        ref.read(boardProvider).drawingMode);
  }

  void onPointerUp(PointerUpEvent details) {
    ref.read(boardProvider).setAllStrokes(
        List<Stroke>.from(ref.read(boardProvider).allStrokes)
          ..add(ref.read(boardProvider).currentStroke!));
  }

  Widget buildAllSketches(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: RepaintBoundary(
        key: ref.watch(boardProvider).canvasGlobalKey,
        child: Container(
          color: Colors.transparent,
          child: CustomPaint(
            painter: Painter(ref.watch(boardProvider).allStrokes),
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
          height: widget.height,
          width: widget.width,
          child: CustomPaint(
            painter: Painter(
              ref.watch(boardProvider).currentStroke == null
                  ? []
                  : [ref.watch(boardProvider).currentStroke!],
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
    for (Stroke stroke in strokes) {
      final points = stroke.points;
      if (points.isEmpty) return;
      final path = Path();

      path.moveTo(points[0].dx, points[0].dy);

      // draw a dot if there is only one point
      if (points.length < 2) {
        path.addOval(
          Rect.fromCircle(
            center: Offset(points[0].dx, points[0].dy),
            radius: 1,
          ),
        );
      }

      for (int i = 1; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];

        path.quadraticBezierTo(
            p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      }

      Offset p1 = stroke.points.first;
      Offset p2 = stroke.points.last;

      Rect rect = Rect.fromPoints(p1, p2);

      Offset centerPoint = (p1 / 2) + (p2 / 2);
      double radius = (p1 - p2).distance / 2;

      final paint = Paint()
        ..isAntiAlias = true
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke.width;

      switch (stroke.type) {
        case DrawType.sketch:
          canvas.drawPath(path, paint);
          break;

        case DrawType.line:
          canvas.drawLine(p1, p2, paint);
          break;
        case DrawType.circle:
          canvas.drawOval(rect, paint);
          break;
        case DrawType.square:
          canvas.drawRect(rect, paint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => oldDelegate.strokes != strokes;
}
