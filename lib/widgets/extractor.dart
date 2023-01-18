import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/board_provider.dart';

import 'resizable.dart';

class TextExtractor extends ConsumerStatefulWidget {
  @override
  _TextExtractorState createState() => _TextExtractorState();
}

class _TextExtractorState extends ConsumerState<TextExtractor> {
  Offset _startPoint = Offset.zero;
  Offset _endPoint = Offset.zero;
  bool _isFraming = false;

  Rect get _frame {
    return Rect.fromPoints(_startPoint, _endPoint);
  }

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
        ),
      ),
    );
  }
}
