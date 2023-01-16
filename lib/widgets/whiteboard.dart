import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gehenna/providers/board.dart';
import 'package:gehenna/widgets/toolbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final lineStreamController = StreamController<List<Stroke>>.broadcast();
  final currentLineStreamController = StreamController<Stroke>.broadcast();

  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    // listen to pen color changes
    _currentColor = ref.read(boardProvider).penColor;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InteractiveViewer(
          child: GestureDetector(
            onSecondaryTapDown: (details) {
              // display context menu
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                ),
                // button
                items: [],
              );
            },
            onPanStart: (details) {
              setState(() {
                ref.read(boardProvider).addStroke(Stroke(
                      [details.localPosition],
                      _currentColor,
                      ref.read(boardProvider).penWidth,
                    ));
              });
            },
            onPanUpdate: (details) {
              setState(() {
                ref.read(boardProvider).addStroke(Stroke(
                      [details.localPosition],
                      _currentColor,
                      ref.read(boardProvider).penWidth,
                    ));
              });
            },
            onPanEnd: (details) => setState(() {
              //ref.read(strokeProvider).last.points.add(Offset.zero);
              ref.read(boardProvider).addStroke(Stroke(
                    [Offset.zero],
                    _currentColor,
                    ref.read(boardProvider).penWidth,
                  ));
            }),
            child: GridPaper(
              color: const Color.fromARGB(255, 219, 219, 219),
              interval: 200,
              subdivisions: 5,
              child: RepaintBoundary(
                child: Container(
                  color: Colors.transparent,
                  child: CustomPaint(
                    painter: Painter(ref.watch(boardProvider).strokes),
                    child: Container(),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.5,
          left: 20,
          child: const Toolbar(),
        )
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
      print(paint.color);
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
