import 'dart:ui';

class Stroke {
  Stroke(this.points, this.color, this.width);
  final List<Offset> points;
  final Color color;
  final double width;

  bool intersects(localPosition, double radius) {
    // intersects within a adius of 10px
    for (int i = 0; i < points.length; i++) {
      Offset point = points[i];
      if (point.dx - localPosition.dx < 10 &&
          point.dy - localPosition.dy < 10) {
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
