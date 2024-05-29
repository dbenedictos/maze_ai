import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:maze_ai/features/classes/environment.dart';
import 'package:maze_ai/models/area.dart';
import 'package:maze_ai/models/brain.dart';
import 'package:maze_ai/utilities/extensions.dart';
import 'package:vector_math/vector_math.dart' as vector;

class Dot {
  Dot({required this.environment}) {
    brain = Brain()..initialize(environment);
    velocity = vector.Vector2.zero();
    acceleration = vector.Vector2.zero();
    position = environment.start.clone(); // clone environment start position to avoid assigning as reference
    obstacles = environment.areas.filter((area) => area.type == Type.OBSTACLE).toList();
    checkPoints = environment.areas.filter((area) => area.type == Type.CHECK_POINT).toList();
    nextCheckPoint = checkPoints.firstOrNullWhere((c) => c.checkPointNumber == 1);
  }

  final Environment environment;

  late Brain brain;
  late vector.Vector2 velocity;
  late vector.Vector2 acceleration;
  late vector.Vector2 position;
  late List<Area> obstacles;
  late List<Area> checkPoints;

  bool isDead = false;
  bool didReachGoal = false;
  Area? lastCheckPoint;
  Area? nextCheckPoint;
  bool isBest = false;
  Color color = Colors.black;

  double fitness = 0;

  void move() {
    if (isDead || didReachGoal) return;

    // hits goal
    if (position.distanceTo(environment.goal) < (Environment.dotRadius + Environment.goalRadius)) {
      didReachGoal = true;
      color = Colors.deepPurpleAccent;
      return;
    }

    // hits borders
    if (position.x >= Environment.size - Environment.dotRadius ||
        position.x <= Environment.dotRadius ||
        position.y >= Environment.size - Environment.dotRadius ||
        position.y <= Environment.dotRadius) {
      isDead = true;
      color = Colors.red;
      return;
    }

    // hits obstacle
    if (obstacles.any((obstacle) => didCollideWithArea(obstacle))) {
      isDead = true;
      color = Colors.red;
      return;
    }

    // hits checkPoint;
    for (Area checkPoint in checkPoints) {
      final didCollide = didCollideWithArea(checkPoint);
      if (didCollide) {
        if ((checkPoint.checkPointNumber ?? 0) > (lastCheckPoint?.checkPointNumber ?? 0)) {
          lastCheckPoint = checkPoint;
          nextCheckPoint =
              checkPoints.firstOrNullWhere((c) => c.checkPointNumber == (lastCheckPoint?.checkPointNumber ?? 0) + 1);
        }
      }
    }

    if (brain.genes.length - 1 >= brain.step) {
      acceleration = brain.genes[brain.step];
      brain.step++;

      velocity = velocity..add(acceleration);
      velocity = velocity.limit(2);
      position = position..add(velocity);

      return;
    }

    isDead = true;
    color = Colors.brown;
  }

  bool didCollideWithArea(Area obstacle) =>
      position.x >= obstacle.left &&
      position.x <= obstacle.right &&
      position.y >= obstacle.bottom &&
      position.y <= obstacle.top;

  void calculateFitness() {
    if (didReachGoal) {
      fitness = (1.0 / 16.0) + (10000.0 / (pow(steps, 2)));
    } else {
      fitness = 1 / position.distanceToSquared(environment.goal);
    }
  }

  /// Work in progress use calculateFitness instead
  void calculateFitnessV2() {
    if (didReachGoal || lastCheckPoint != null) {
      final distanceToNextCheckPoint = nextCheckPoint != null
          ? position.distanceTo(vector.Vector2(nextCheckPoint!.center.x, nextCheckPoint!.center.y))
          : 1;
      fitness = (1.0 / 16.0) +
          ((10000.0 * (lastCheckPoint?.checkPointNumber ?? 1)) / ((pow(steps, 2))) * distanceToNextCheckPoint);
    } else {
      fitness = 1 / position.distanceToSquared(environment.goal);
    }
  }

  Dot clone() {
    Dot clone = Dot(environment: environment);
    clone.brain = Brain.fromBrain(brain);

    return clone;
  }

  int get steps => brain.step;
}
