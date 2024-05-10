import 'dart:math';

import 'package:maze_ai/models/brain.dart';
import 'package:vector_math/vector_math.dart';

extension PositionExt on Position {
  double distanceFrom(Position value) => sqrt(pow(x - value.x, 2) + pow(y - value.y, 2));
}

extension Vector2Ext on Vector2 {
  Vector2 limit(double value) {
    final factor = value / length;
    if (factor <= 1.0) return this;
    final v = scaled(factor);
    return v;
  }
}
