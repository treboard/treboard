import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:treboard/models/draw_mode.dart';

import 'element.dart';

class Stroke extends CanvasElement {
  final List<Offset> points;
  final Color color;
  final double width;
  final DrawType type;
  Stroke({
    required this.points,
    this.color = Colors.black,
    required this.width,
    this.type = DrawType.sketch,
  }) : super(Offset.zero, 1.0);

  factory Stroke.fromDrawMode(Stroke stroke, DrawMode mode) {
    return Stroke(
      points: stroke.points,
      color: stroke.color,
      width: stroke.width,
      type: () {
        switch (mode) {
          case DrawMode.sketch:
            return DrawType.sketch;
          case DrawMode.erase:
            return DrawType.erase;
          case DrawMode.select:
            return DrawType.select;
          case DrawMode.line:
            return DrawType.line;
          case DrawMode.circle:
            return DrawType.circle;
          case DrawMode.square:
            return DrawType.square;
        }
      }(),
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((e) => [e.dx, e.dy]).toList(),
      'color': color.value,
      'width': width,
      'type': type.index,
    };
  }

  factory Stroke.fromJson(Map<String, dynamic> json) {
    return Stroke(
      points: (json['points'] as List).map((e) => Offset(e[0], e[1])).toList(),
      color: Color(json['color']),
      width: json['width'],
      type: DrawType.values[json['type']],
    );
  }
}

enum DrawType {
  sketch,
  erase,
  select,
  line,
  circle,
  square,
}
