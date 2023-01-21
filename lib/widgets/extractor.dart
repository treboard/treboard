import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gehenna/providers/node_provider.dart';
import 'package:gehenna/widgets/node.dart';
import 'package:gehenna/widgets/nodes/note.dart';
import 'dart:ui' as ui;
import '../providers/board_provider.dart';
import 'package:http/http.dart';

import 'package:path/path.dart';

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

  bool visible = false;

  void processImage() async {
    // convert repaintBoundary to Image
    RenderRepaintBoundary boundary = ref
        .watch(boardProvider)
        .repaintBoundaryKey
        .currentContext!
        .findRenderObject() as RenderRepaintBoundary;

    // convert RenderRepaintBoundary to Image
    // Rect to be cropped

    ui.Image image = await boundary.toImage(pixelRatio: 0.2);
    // save image as test
    // add node with image

    // convert Image to ByteData
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    var text = await processOCR(pngBytes);

    ref.read(nodeProvider).addNode(CustomNode(
        position: const Offset(50, 50),
        child: Text(text, style: const TextStyle(fontSize: 20))));
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: ref.watch(boardProvider).isFraming,
      child: ResizebleWidget(
        child: RepaintBoundary(
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
