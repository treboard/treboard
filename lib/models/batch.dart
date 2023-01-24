import 'package:treboard/models/stroke.dart';

class StrokeBatch {
  List<Stroke> strokes;
  StrokeBatch(this.strokes);

  // serialize
  Map<String, dynamic> toJson() {
    return {
      'strokes': strokes.map((stroke) => stroke.toJson()).toList(),
    };
  }

  // deserialize
  factory StrokeBatch.fromJson(Map<String, dynamic> json) {
    List<Stroke> strokes = [];
    for (int i = 0; i < json['strokes'].length; i++) {
      strokes.add(Stroke.fromJson(json['strokes'][i]));
    }
    return StrokeBatch(strokes);
  }
}
