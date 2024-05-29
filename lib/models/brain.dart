import 'dart:math';
import 'dart:ui';

import 'package:maze_ai/features/classes/environment.dart';
import 'package:vector_math/vector_math.dart';

class Brain {
  Brain();

  factory Brain.fromBrain(Brain value) => Brain()..genes = List.from(value.genes);

  int step = 0;

  late List<Vector2> genes;

  void initialize(Environment environment) {
    genes = List<Vector2>.generate(environment.geneCount, (index) => generateRandomAccelerationVector());
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
    List<Vector2> mutatedGenes = List.empty(growable: true);
    for (int i = 0; i < genes.length; i++) {
      final m = Random().nextDouble();

      if (m < mutationRate) {
        //add this acceleration as a random acceleration
        mutatedGenes.add(generateRandomAccelerationVector());
      } else {
        mutatedGenes.add(genes[i]);
      }
    }

    genes = mutatedGenes;
  }
}
