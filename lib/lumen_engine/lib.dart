import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

// pub extern "C" fn processOCR(image: *const u8, length: usize) -> *const u8

typedef ocr_func = ffi.Pointer<ffi.Uint8> Function(
    ffi.Pointer<ffi.Uint8>, ffi.Int32);

void processOCR(Uint8List image, int size) {
  var libraryPath =
      path.join(Directory.current.path, 'lib/lumen_engine', 'liblumen.so');

  final dylib = ffi.DynamicLibrary.open(libraryPath);

  final processImage = dylib.lookup<ffi.NativeFunction<ocr_func>>('processOCR');
}
