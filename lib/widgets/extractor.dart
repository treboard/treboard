import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treboard/models/draw_mode.dart';
import 'package:treboard/providers/node_provider.dart';
import 'package:treboard/widgets/mdi.dart';
import 'package:treboard/widgets/nodes/note.dart';
import 'dart:ui' as ui;
import '../providers/board_provider.dart';
import 'package:http/http.dart';

import 'package:path/path.dart';

import 'resizable.dart';

import 'package:treboard/lumen_engine/lib.dart';

class TextExtractor extends ConsumerStatefulWidget {
  RenderRepaintBoundary? boundary;
  TextExtractor({Key? key, this.boundary}) : super(key: key);

  @override
  _TextExtractorState createState() => _TextExtractorState();
}

class _TextExtractorState extends ConsumerState<TextExtractor> {
  bool visible = false;
  Rect _selectedRegion = Rect.zero;
  Offset _startPoint = Offset.zero;

  Color beforeColor = Colors.black.withOpacity(0.1);
  // color just before sending the image to the server
  late Color afterColor = ref.read(boardProvider).canvasColor;

  Uint8List crop(Uint8List image, Rect bounds) {
    // crop image using bounds
    return image;
  }

  @override
  Widget build(BuildContext context) {
    Future<String> processImage() async {
      ui.Image image = await widget.boundary!.toImage(pixelRatio: 0.5);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      return await processOCR(pngBytes);
      //ref.read(mdiProvider).addWindow(Note(content: latex), const Offset(0, 0));
    }

    return Visibility(
      visible: ref.watch(boardProvider).isFraming,
      child: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.1),
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _selectedRegion = Rect.fromPoints(
                    _startPoint,
                    details.localPosition,
                  );
                });
              },
              onPanStart: (details) {
                setState(() {
                  _startPoint = details.localPosition;
                });
              },
              child: CustomPaint(
                painter: SelectedRegionPainter(_selectedRegion),
                child: Container(),
              ),
            ),
          ),
          Positioned(
              left: _selectedRegion.right,
              top: _selectedRegion.bottom,
              child: ElevatedButton(
                  onPressed: () {
                    ref.read(boardProvider).setFraming(false);
                    // show dialog with future builder
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"))
                            ],
                            title: const Text("Processing Expression"),
                            content: FutureBuilder(
                              future: processImage(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data.toString());
                                } else if (snapshot.hasError) {
                                  // return error
                                  return Text("${snapshot.error}");
                                } else {
                                  // return indeterminate linear progress indicator
                                  return const LinearProgressIndicator();
                                }
                              },
                            ),
                          );
                        });
                  },
                  child: const Text(
                    "Smart Math",
                    style: TextStyle(fontSize: 60),
                  ))),
        ],
      ),
    );
  }
}

class SelectedRegionPainter extends CustomPainter {
  final Rect? rect;

  SelectedRegionPainter(this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawRect(rect!, paint);

    final paint2 = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(rect!.left - 10, rect!.top - 10), 10, paint2); // top left
    canvas.drawCircle(
        Offset(rect!.right + 10, rect!.top - 10), 10, paint2); // top right
    canvas.drawCircle(
        Offset(rect!.left - 10, rect!.bottom + 10), 10, paint2); // bottom left
    canvas.drawCircle(Offset(rect!.right + 10, rect!.bottom + 10), 10,
        paint2); // bottom right
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
