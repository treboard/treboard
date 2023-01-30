import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treboard/providers/node_provider.dart';
import 'package:treboard/widgets/nodes/tex_node.dart';
import 'dart:ui' as ui;
import '../providers/board_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    crop(ByteData data, Rect bounds) {
      // crop image using bounds
      var image = img.decodeImage(data.buffer.asUint8List());

      // crop relative to context size
      // make sure crop boundaries are within image boundaries
      // crop using _selectedRegion
      bounds = Rect.fromPoints(
        Offset(
          max(0, bounds.left),
          max(0, bounds.top),
        ),
        Offset(
          min(image!.width.toDouble(), bounds.right),
          min(image.height.toDouble(), bounds.bottom),
        ),
      );
      var cropped = img.copyCrop(
        image,
        bounds.left.toInt(),
        bounds.top.toInt(),
        bounds.width.toInt(),
        bounds.height.toInt(),
      );

      // return a Uint8List
      // convert _cropped to bytes as UInt8List
      return Uint8List.fromList(img.encodeBmp(cropped));
    }

    processImage() async {
      ui.Image image = await widget.boundary!.toImage(pixelRatio: 0.1);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      var pngBytesNew = crop(byteData!, _selectedRegion);

      ref.read(mdiProvider).addWindow(Image.memory(pngBytesNew), Offset.zero);

      await processOCR(pngBytesNew).then((value) => {
            ref.read(mdiProvider).addWindow(
                  TexNode(tex: value),
                  const Offset(0, 0),
                ),
          });
    }

    return Visibility(
      visible: ref.watch(boardProvider).isFraming,
      child: Stack(
        children: [
          Positioned(
            left: _selectedRegion.left,
            top: _selectedRegion.top,
            child: SizedBox(
              width: _selectedRegion.width,
              height: _selectedRegion.height,
              child: ClipRect(
                clipBehavior: Clip.hardEdge,
                child: BackdropFilter(
                  filter: ui.ImageFilter.erode(radiusX: 0.7, radiusY: 1.0),
                  child: Container(
                    color: Colors.red.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
          Container(
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
              left: _selectedRegion.right - _selectedRegion.width / 1.8,
              top: _selectedRegion.bottom + 10,
              child: ElevatedButton(
                  onPressed: () {
                    ref.read(boardProvider).setFraming(false);
                    // show dialog with future builder
                    processImage();
                  },
                  child: const Text(
                    "Smart Math",
                    style: TextStyle(fontSize: 30),
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
