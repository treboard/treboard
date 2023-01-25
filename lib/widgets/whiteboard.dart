import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treboard/models/stroke_models.dart';
import 'package:treboard/providers/board_provider.dart';
import 'package:treboard/providers/node_provider.dart';
import 'package:treboard/widgets/color_bar.dart';
import 'package:treboard/widgets/extractor.dart';
import 'package:treboard/widgets/node.dart';
import 'package:treboard/widgets/toolbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treboard/widgets/nodes/note.dart';

class WhiteBoard extends ConsumerStatefulWidget {
  const WhiteBoard({super.key});

  @override
  ConsumerState<WhiteBoard> createState() => _WhiteBoardState();
}

class _WhiteBoardState extends ConsumerState<WhiteBoard> {
  final initScale = 0.1;
  double offsetThreshold = 0.1;
  MouseCursor cursor = SystemMouseCursors.grab;

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

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(
          LogicalKeyboardKey.keyZ,
          control: true,
        ): () => ref.read(boardProvider).undo(),
      },
      key: const ValueKey('shortcutHandler'),
      child: Focus(
        child: Stack(
          children: [
            InteractiveViewer(
              //boundaryMargin: const EdgeInsets.all(double.infinity),
              minScale: 0.1,

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
                      .use(ref.read(boardProvider), details);
                },
                onPanUpdate: (details) {
                  // add a new point to the current stroke

                  ref
                      .watch(boardProvider)
                      .tool
                      .use(ref.read(boardProvider), details);
                },
                onPanEnd: (details) {
                  // add a new point to the current stroke
                  ref
                      .watch(boardProvider)
                      .tool
                      .use(ref.read(boardProvider), details);

                  // convert picture to Image
                },
                child: RepaintBoundary(
                  key: ref.read(boardProvider).repaintBoundaryKey,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: Painter(
                      strokeRef.read(boardProvider).state.strokes,
                      ref.watch(boardProvider).frameRect ?? Rect.zero,
                    ),
                    child: GridPaper(
                      color: Color.fromARGB(255, 228, 228, 228),
                      interval: 200,
                      subdivisions: 5,
                      child: Container(),
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

            TextExtractor(),
            Positioned(
              top: 20,
              left: MediaQuery.of(context).size.width / 2 - (2 * 20 + 200) / 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Slider(
                      value: ref.watch(boardProvider).penWidth,
                      min: 2,
                      max: 20,
                      divisions: 4,
                      onChanged: (value) {
                        // change on exponential scale
                        ref.read(boardProvider.notifier).setPenWidth(value);
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    // some circular container to represent the size of the pen
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: ref.watch(boardProvider).penWidth * 2,
                      height: ref.watch(boardProvider).penWidth * 2,
                      decoration: BoxDecoration(
                        color: ref.watch(boardProvider).penColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Painter extends CustomPainter {
  Painter(this.points, this.rect);
  final List<Stroke> points;
  Rect? rect;
  @override
  void paint(Canvas canvas, Size size) async {
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

    drawStrokes(paint);
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => true;
}
