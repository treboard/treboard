import 'package:flutter/material.dart';
import 'package:gehenna/core/tool.dart';
import 'package:gehenna/providers/board_provider.dart';
import 'package:gehenna/providers/node_provider.dart';
import 'package:gehenna/widgets/color_bar.dart';
import 'package:gehenna/widgets/node.dart';
import 'package:gehenna/widgets/toolbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gehenna/widgets/nodes/note.dart';

class Stroke {
  Stroke(this.points, this.color, this.width);
  final List<Offset> points;
  final Color color;
  final double width;

  bool isWithinDistance(Offset point) {
    return points.last.distance < 10;
  }
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
  // CustomNodes include Text, Expression, Image, etc.
  // Only Text is implemented for now
  // Text is a widget that can be dragged around the board

  @override
  Widget build(BuildContext context) {
    WidgetRef strokeRef = ref;
    ref.watch(nodeProvider).nodes;
    Tool tool = ref.watch(boardProvider).tool;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(),
          child: InteractiveViewer(
            boundaryMargin: EdgeInsets.all(200),
            minScale: 0.1,
            maxScale: 30,
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
              },
              child: GridPaper(
                color: const Color.fromARGB(255, 219, 219, 219),
                interval: 200,
                subdivisions: 5,
                child: RepaintBoundary(
                  child: Container(
                    color: Colors.transparent,
                    child: CustomPaint(
                      painter: Painter(strokeRef.watch(boardProvider).strokes),
                      child: Container(),
                    ),
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
      ],
    );
  }
}

class Painter extends CustomPainter {
  Painter(this.points);
  final List<Stroke> points;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    for (var stroke in points) {
      paint.color = stroke.color;
      paint.strokeWidth = stroke.width;
      for (var i = 0; i < stroke.points.length - 1; i++) {
        if (stroke.points[i] != Offset.zero &&
            stroke.points[i + 1] != Offset.zero) {
          canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => true;
}
