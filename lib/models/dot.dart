import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:maze_ai/models/area.dart';
import 'package:maze_ai/models/brain.dart';
import 'package:maze_ai/utilities/contants.dart';
import 'package:maze_ai/utilities/extensions.dart';
import 'package:vector_math/vector_math.dart' as vector;

class Dot {
  Dot({
    required this.startingPosition,
    required this.goal,
    required this.areas,
  }) {
    brain = Brain()..initialize();
    velocity = vector.Vector2.zero();
    acceleration = vector.Vector2.zero();
    position = startingPosition.clone();
    obstacles = areas.filter((area) => area.type == Type.OBSTACLE).toList();
    checkPoints = areas.filter((area) => area.type == Type.CHECK_POINT).toList();
  }

  final vector.Vector2 goal;
  final vector.Vector2 startingPosition;
  final List<Area> areas;

  late Brain brain;
  late vector.Vector2 velocity;
  late vector.Vector2 acceleration;
  late vector.Vector2 position;
  late List<Area> obstacles;
  late List<Area> checkPoints;

  bool isDead = false;
  bool didReachGoal = false;
  bool isBest = false;
  Color color = Colors.black;

  double fitness = 0;
  List<Area> checkpointsReached = [];

  void move() {
    if (isDead || didReachGoal) return;

    // hits goal
    if (position.distanceTo(goal) < (dotRadius + goalRadius)) {
      didReachGoal = true;
      color = Colors.deepPurpleAccent;
      return;
    }

    // hits borders
    if (position.x >= size - dotRadius ||
        position.x <= dotRadius ||
        position.y >= size - dotRadius ||
        position.y <= dotRadius) {
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
      if (didCollide) checkpointsReached.add(checkPoint);
    }
    // if (checkpointsReached.isNotEmpty) {
    //   color = Colors.orange;
    // }

    if (brain.contents.length - 1 >= brain.step) {
      acceleration = brain.contents[brain.step];
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
    final checkpointRDistinct = checkpointsReached.distinct();
    final lastCheckPointNumber =
        checkpointRDistinct.sortedBy((e) => e.checkPointNumber ?? 0).lastOrNull?.checkPointNumber ?? 0;

    if (didReachGoal) {
      fitness = (1.0 / 16.0) + (1000000.0 / (pow(steps, 2)));
    } else if (lastCheckPointNumber >= 0 && lastCheckPointNumber < checkPoints.length && checkPoints.isNotEmpty) {
      final nextCheckPoint = checkPoints.firstOrNullWhere((e) => e.checkPointNumber == lastCheckPointNumber + 1);
      final distanceToNextCheckPoint =
          position.distanceTo(vector.Vector2(nextCheckPoint!.center.x, nextCheckPoint.center.y));
      fitness = pow(nextCheckPoint.checkPointNumber!, checkPoints.length) / pow(distanceToNextCheckPoint, 2);
    } else {
      fitness = 1 / position.distanceToSquared(goal);
    }
  }

  Dot clone() {
    Dot clone = Dot(
      goal: goal,
      startingPosition: startingPosition,
      areas: List.from(areas),
    );
    clone.brain = Brain.fromBrain(brain);

    return clone;
  }

  int get steps => brain.step;
}
