import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:math_expressions/math_expressions.dart';

class Coordinate {
  double x;
  double y;
  Coordinate(this.x, this.y);
}

class Plotter extends StatefulWidget {
  const Plotter({super.key});

  @override
  State<Plotter> createState() => _PlotterState();
}

class _PlotterState extends State<Plotter> {
  TextEditingController _expressionController = TextEditingController();

  List<Coordinate> _coordinates = [];

  // plot range

  int maxX = 10;
  int maxY = 10;

  int initialZoom = 10;

  void plot() {
    // parse expression
    // plot
    // update _coordinates

    _coordinates = [];
    for (int x = -maxX; x <= maxX; x++) {
      Parser p = Parser();
      Expression exp = p.parse(_expressionController.text);
      ContextModel cm = ContextModel();
      cm.bindVariable(Variable("x"), Number(x));
      double y = exp.evaluate(EvaluationType.REAL, cm);
      _coordinates.add(Coordinate(x.toDouble(), y));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          TextField(
            controller: _expressionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter an expression",
            ),
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
            onEditingComplete: () {
              // validate expression
              plot();
              setState(() {});
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: InteractiveViewer(
              onInteractionUpdate: (details) {
                print(details.scale);
                // zoom in
                if (details.scale > 1) {
                  maxX = initialZoom * details.scale.toInt();
                  maxY = initialZoom * details.scale.toInt();
                }
                // zoom out
                else {
                  maxX = initialZoom ~/ details.scale.toInt();
                  maxY = initialZoom ~/ details.scale.toInt();
                }
                plot();
                setState(() {});
              },
              child: LineChart(
                LineChartData(
                  minX: -maxX.toDouble(),
                  maxX: maxX.toDouble(),
                  minY: -maxY.toDouble(),
                  maxY: maxY.toDouble(),
                  baselineX: 0,
                  baselineY: 0,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _coordinates
                          .map((e) => FlSpot(e.x, e.y))
                          .toList(growable: false),
                      isCurved: true,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      curveSmoothness: 0.1,
                      preventCurveOverShooting: true,
                      belowBarData: BarAreaData(
                        show: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
