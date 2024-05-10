import 'package:vector_math/vector_math.dart';

extension Vector2Ext on Vector2 {
  Vector2 limit(double value) {
    final factor = value / length;
    // if (factor <= 1.0) return this;
    final v = scaled(factor);
    return v;
  }
}
