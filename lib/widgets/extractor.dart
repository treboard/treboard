import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gehenna/providers/node_provider.dart';
import 'package:gehenna/widgets/node.dart';
import 'dart:ui' as ui;
import '../providers/board_provider.dart';
import 'package:http/http.dart';

import 'resizable.dart';

import 'package:gehenna/lumen_engine/lib.dart';

class TextExtractor extends ConsumerStatefulWidget {
  TextExtractor({Key? key});

  @override
  _TextExtractorState createState() => _TextExtractorState();
}

class _TextExtractorState extends ConsumerState<TextExtractor> {
  @override
  void initState() {
    super.initState();
    visible = ref.read(boardProvider).isFraming;
  }

  GlobalKey _repaintBoundaryKey = GlobalKey();
  TextEditingController _extractionController = TextEditingController();
  bool visible = false;

  void requestOCR() {
    processImage();
  }

  void processImage() async {
    // convert repaintBoundary to Image
    RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;

    // convert RenderRepaintBoundary to Image
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    // convert Image to ByteData
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    requestOCR();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: ref.watch(boardProvider).isFraming,
      child: ResizebleWidget(
        child: RepaintBoundary(
          key: _repaintBoundaryKey,
          child: Container(
            width: ref.watch(boardProvider).frameRect?.width,
            height: ref.watch(boardProvider).frameRect?.height,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.redAccent, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
                alignment: Alignment.bottomCenter,
              ),
              onPressed: () {
                processImage();
              },
              child: const Text(''),
            ),
          ),
        ),
      ),
    );
  }
}
