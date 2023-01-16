import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gehenna/widgets/toolbar.dart';

class Stroke {
  Stroke(this.points, this.color, this.width);
  final List<Offset> points;
  final Color color;
  final double width;
}

class WhiteBoard extends StatefulWidget {
  const WhiteBoard({super.key});

  @override
  State<WhiteBoard> createState() => _CanvasState();
}

class _CanvasState extends State<WhiteBoard> {
  @override
  void initState() {
    super.initState();
  }

  final _lines = <Stroke>[]; // list of strokes
  final lineStreamController = StreamController<List<Stroke>>.broadcast();
  final currentLineStreamController = StreamController<Stroke>.broadcast();

  Color _currentColor = Colors.black;

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
                items: const [
                  PopupMenuItem(
                    child: Text("Red"),
                    value: Colors.red,
                  ),
                  PopupMenuItem(
                    child: Text("Blue"),
                    value: Colors.blue,
                  ),
                  PopupMenuItem(
                    child: Text("Green"),
                    value: Colors.green,
                  ),
                  PopupMenuItem(
                    child: Text("Black"),
                    value: Colors.black,
                  ),
                ],
              ).then((value) {
                if (value != null) {
                  setState(() {
                    _currentColor = value;
                  });
                }
              });
            },
            onPanStart: (details) {
              setState(() {
                _lines.add(Stroke([details.localPosition], _currentColor, 2.0));
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _lines.last.points.add(details.localPosition);
              });
            },
            onPanEnd: (details) => setState(() {
              _lines.last.points.add(Offset.zero);
            }),
            child: GridPaper(
              color: Color.fromARGB(255, 219, 219, 219),
              interval: 200,
              subdivisions: 5,
              child: RepaintBoundary(
                child: Container(
                  color: Colors.transparent,
                  child: StreamBuilder<Stroke>(
                      stream: currentLineStreamController.stream,
                      builder: ((context, snapshot) {
                        return CustomPaint(
                          painter: Painter(_lines),
                          child: Container(),
                        );
                      })),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.5,
          left: 20,
          child: Toolbar(),
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
