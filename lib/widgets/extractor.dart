import 'package:flutter/material.dart';

class TextExtractor extends StatefulWidget {
  @override
  _TextExtractorState createState() => _TextExtractorState();
}

class _TextExtractorState extends State<TextExtractor> {
  Offset _startPoint = Offset.zero;
  Offset _endPoint = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        setState(() {
          _startPoint = details.localPosition;
        });
      },
      onLongPressMoveUpdate: (details) {
        setState(() {
          _endPoint = details.localPosition;
        });
      },
      onLongPressEnd: (details) {
        setState(() {
          _startPoint = details.localPosition;
          _endPoint = details.localPosition;
        });
      },
      child: CustomPaint(
        painter: TextExtractionPainter(_startPoint, _endPoint),
        child: Container(),
      ),
    );
  }
}

class TextExtractionPainter extends CustomPainter {
  TextExtractionPainter(this.startPoint, this.endPoint);

  final Offset startPoint;
  final Offset endPoint;

  @override
  void paint(Canvas canvas, Size size) {
    if (startPoint != null && endPoint != null) {
      var paint = Paint()
        ..color = Colors.red
        ..strokeWidth = 3;

      var rect = Rect.fromPoints(startPoint, endPoint);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(TextExtractionPainter oldDelegate) {
    return startPoint != oldDelegate.startPoint ||
        endPoint != oldDelegate.endPoint;
  }
}
