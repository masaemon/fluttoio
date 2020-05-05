import 'dart:math';
import 'package:vector_math/vector_math.dart';

class Coordinate {
  double x;
  double y;
  Coordinate({ this.x, this.y });
}

Coordinate Cycroid (int a, double deg) {
  double theta = radians(deg);
  double x = a*(theta - sin(theta));
  double y = - a*(1 - cos(theta));
  return Coordinate(x: x, y: y);
}

List<Coordinate> Cycroids (int w, int a) {
  List<Coordinate> coordinate = List();

  var x;
  var y;
  return coordinate;
}
