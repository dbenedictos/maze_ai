import 'dart:math';
import 'dart:ui';

import 'package:maze_ai/features/classes/environment.dart';
import 'package:vector_math/vector_math.dart';

class Brain {
  Brain();

  factory Brain.fromBrain(Brain value) => Brain()..contents = List.from(value.contents);

  int step = 0;

  late List<Vector2> contents;

  void initialize(Environment environment) {
    contents = List<Vector2>.generate(environment.geneCount, (index) => generateRandomAccelerationVector());
  }

  Vector2 generateRandomAccelerationVector() {
    final angle = lerpDouble(0, 2 * pi, Random().nextDouble()) ?? 0.0;
    return getUnitVectorFromAngle(angle);
  }

  Vector2 getUnitVectorFromAngle(double angle) {
    final x = sin(angle);
    final y = cos(angle);

    return Vector2(x, y);
  }

  void mutate() {
    const mutationRate = 0.01; //chance that any acceleration is changed
    List<Vector2> mutatedContents = List.empty(growable: true);
    for (int i = 0; i < contents.length; i++) {
      final m = Random().nextDouble();

      if (m < mutationRate) {
        //add this acceleration as a random acceleration
        mutatedContents.add(generateRandomAccelerationVector());
      } else {
        mutatedContents.add(contents[i]);
      }
    }

    contents = mutatedContents;
  }
}
