import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gehenna/core/tool.dart';
import 'package:gehenna/providers/board_provider.dart';
import 'package:gehenna/providers/node_provider.dart';
import 'package:gehenna/widgets/color_bar.dart';
import 'package:gehenna/widgets/extractor.dart';
import 'package:gehenna/widgets/node.dart';
import 'package:gehenna/widgets/toolbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gehenna/widgets/nodes/note.dart';

class Stroke {
  Stroke(this.points, this.color, this.width);
  final List<Offset> points;
  final Color color;
  final double width;
}

class WhiteBoard extends ConsumerStatefulWidget {
  const WhiteBoard({super.key});

  @override
  ConsumerState<WhiteBoard> createState() => _WhiteBoardState();
}

class _WhiteBoardState extends ConsumerState<WhiteBoard> {
  final initScale = 0.1;
  double offsetThreshold = 0.1;
  MouseCursor cursor = SystemMouseCursors.grab;
  PictureRecorder recorder = PictureRecorder();
  Canvas mainCanvas = Canvas(PictureRecorder());

  Offset oldFocalPoint = Offset.zero;

  // CustomNodes include Text, Expression, Image, etc.
  // Only Text is implemented for now
  // Text is a widget that can be dragged around the board
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetRef strokeRef = ref;
    ref.watch(nodeProvider).nodes;
    Tool tool = ref.watch(boardProvider).tool;

    return Stack(
      children: [
        InteractiveViewer(
          boundaryMargin: EdgeInsets.all(double.infinity),
          child: GestureDetector(
            onSecondaryTapDown: (details) {
              // display context menu

              showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                      details.globalPosition.dx + 1,
                      details.globalPosition.dy + 1),
                  items: const [
                    PopupMenuItem(
                      value: 1,
                      child: Text('Add Note'),
                    ),
                  ]).then((value) {
                if (value == 1) {
                  // add a new CustomNode
                  ref.read(nodeProvider).addNode(
                        CustomNode(
                          position: details.localPosition,
                          child: Note(),
                        ),
                      );
                }
              });
            },
            onPanStart: (details) {
              ref
                  .watch(boardProvider)
                  .tool
                  .use(ref.watch(boardProvider), details);
            },
            onPanUpdate: (details) {
              // add a new point to the current stroke

              ref
                  .watch(boardProvider)
                  .tool
                  .use(ref.watch(boardProvider), details);
            },
            onPanEnd: (details) {
              // add a new point to the current stroke
              ref
                  .watch(boardProvider)
                  .tool
                  .use(ref.watch(boardProvider), details);

              // convert picture to Image
            },
            child: GridPaper(
              color: Color.fromARGB(255, 162, 162, 162),
              interval: 200,
              subdivisions: 5,
              child: RepaintBoundary(
                child: Container(
                  color: Colors.transparent,
                  child: CustomPaint(
                    painter: Painter(
                      strokeRef.watch(boardProvider).strokes,
                      mainCanvas,
                    ),
                    child: Container(),
                  ),
                ),
              ),
            ),
          ),
        ),

        // display CustomNodes
        ...ref.read(nodeProvider).nodes,
        Positioned(
          bottom: MediaQuery.of(context).size.height / 2 - (2 * 20 + 40),
          left: 20,
          child: const Toolbar(),
        ),

        const ColorBar(),

        Positioned(child: TextExtractor())
      ],
    );
  }
}

class Painter extends CustomPainter {
  Painter(this.points, this.canvas);
  final List<Stroke> points;

  final Canvas canvas;

  @override
  void paint(canvas, Size size) {
    void drawStrokes(Paint paint) {
      for (Stroke stroke in points) {
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

    // canvas.drawPicture(picture);

    drawStrokes(paint);
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => true;
}
