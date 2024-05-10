import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maze_ai/models/brain.dart';
import 'package:maze_ai/utilities/contants.dart';
import 'package:maze_ai/utilities/extensions.dart';
import 'package:vector_math/vector_math.dart' as vector;

class Dot {
  Dot({
    required this.startingPosition,
    required this.goal,
  }) {
    brain = Brain()..initialize();
    velocity = vector.Vector2.zero();
    acceleration = vector.Vector2.zero();
    position = startingPosition.clone();
  }

  final vector.Vector2 goal;
  final vector.Vector2 startingPosition;

  late Brain brain;
  late vector.Vector2 velocity;
  late vector.Vector2 acceleration;
  late vector.Vector2 position;

  bool isDead = false;
  bool didReachGoal = false;
  bool isBest = false;
  Color color = Colors.black;

  double fitness = 0;

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
    if (position.x >= 150 && position.x <= 450 && position.y >= 250 && position.y <= 350) {
      isDead = true;
      color = Colors.red;
      return;
    }

    if (brain.contents.length - 1 >= brain.step) {
      acceleration = brain.contents[brain.step];
      brain.step++;

      velocity = velocity..add(acceleration);
      velocity = velocity.limit(10);
      position = position..add(velocity);

      return;
    }

    isDead = true;
    color = Colors.brown;
  }

  void calculateFitness() {
    if (didReachGoal) {
      fitness = (1.0 / 16.0) + (10000.0 / (pow(steps, 2)));
    } else {
      fitness = 1 / position.distanceToSquared(goal);
    }
  }

  Dot clone() {
    Dot clone = Dot(
      goal: goal,
      startingPosition: startingPosition,
    );
    clone.brain = Brain.fromBrain(brain);

    return clone;
  }

  int get steps => brain.step;
}
