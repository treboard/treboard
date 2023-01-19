import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/board_provider.dart';

import 'resizable.dart';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextExtractor extends ConsumerStatefulWidget {
  @override
  _TextExtractorState createState() => _TextExtractorState();
}

class _TextExtractorState extends ConsumerState<TextExtractor> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: ref.watch(boardProvider).isFraming,
      child: ResizebleWidget(
        child: Container(
          width: ref.watch(boardProvider).frameRect.width,
          height: ref.watch(boardProvider).frameRect.height,
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
              ref.watch(boardProvider).toggleFrame();
              ref.watch(boardProvider).extractText();
            },
            child: const Text('Extract'),
          ),
        ),
      ),
    );
  }
}
