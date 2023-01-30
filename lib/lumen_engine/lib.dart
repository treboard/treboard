import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<String> processOCR(Uint8List pngData) async {
  String baseUrl = "http://127.0.0.1:8000/process_image/";
  //async def process_image(pngData: bytes = File(...)):

  // send request to api
  var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
  request.files.add(
    http.MultipartFile.fromBytes(
      'pngData',
      pngData,
      filename: 'image.png',
    ),
  );
  var response = await request.send();
  // get response
  var text = await response.stream.bytesToString();
  print(jsonDecode(text)["text"]);
  return jsonDecode(text)["text"];
}
