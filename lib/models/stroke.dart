import 'dart:ui';
import 'element.dart';

class Stroke extends Element {
  Stroke(this.points, this.color, this.width) : super(Offset.zero, 0.0);
  final List<Offset> points;
  final Color color;
  final double width;

  Offset getPosition() {
    // get the average of all points
    double x = 0.0;
    double y = 0.0;

    for (int i = 0; i < points.length; i++) {
      x += points[i].dx;
      y += points[i].dy;
    }

    return Offset(x / points.length, y / points.length);
  }

  bool intersects(localPosition, double radius) {
    // intersects within a radius of 10px
    for (int i = 0; i < points.length - 1; i++) {
      if (localPosition.dx - radius <= points[i].dx &&
          localPosition.dx + radius >= points[i].dx &&
          localPosition.dy - radius <= points[i].dy &&
          localPosition.dy + radius >= points[i].dy) {
        return true;
      }
    }
    return false;
  }

  factory Stroke.fromJson(Map<String, dynamic> json) {
    List<Offset> points = [];
    for (int i = 0; i < json['points'].length; i++) {
      points.add(Offset(json['points'][i]['dx'], json['points'][i]['dy']));
    }
    return Stroke(
      points,
      Color(json['color']),
      json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points':
          points.map((point) => {'dx': point.dx, 'dy': point.dy}).toList(),
      'color': color.value,
      'width': width,
    };
  }
}
