import 'dart:math';
import 'dart:ui';

import 'package:dartx/dartx.dart';
import 'package:maze_ai/models/dot.dart';

import '../features/classes/environment.dart';

class Population {
  Population({required this.environment}) {
    minStepCount = environment.geneCount;
    _dots = List.generate(
      environment.populationCount,
      (index) => Dot(environment: environment),
    );
  }

  final Environment environment;

  late int minStepCount;
  late List<Dot> _dots;
  late Dot bestDot;

  int generationCount = 1;
  double fitnessSum = 0;
  double successRate = 0.0;
  int generationSuccess = 0;

  List<Dot> get dots => List.from(_dots, growable: false);

  int get aliveDots => _dots.count((dot) => !dot.isDead);

  int get deadDots => _dots.count((dot) => dot.isDead);

  int get finishedDots => _dots.count((dot) => dot.didReachGoal);

  bool get areAllDotsFinished => _dots.all((dot) => dot.isDead || dot.didReachGoal);

  void calculateSuccessRate() => successRate = _dots.count((dot) => dot.didReachGoal) / environment.populationCount;

  void setGenerationSuccess() {
    if (generationSuccess < 1) {
      generationSuccess = finishedDots > 0 ? generationCount : 0;
    }
  }

  void move() {
    for (Dot dot in _dots) {
      if (dot.steps == minStepCount) {
        dot.isDead = true;
      } else {
        dot.move();
      }
    }
  }

  void calculateFitness() {
    fitnessSum = 0; // reset for next gen
    for (Dot dot in _dots) {
      dot.calculateFitness();
      fitnessSum += dot.fitness;
    }
  }

  Dot selectParent() {
    final fit = lerpDouble(0, fitnessSum * .8, Random().nextDouble())?.toDouble() ?? 0.0;

    double runningSum = 0;
    for (Dot dot in _dots) {
      runningSum += dot.fitness;
      if (runningSum > fit) return dot;
    }

    // dummy return. In theory it should not go pass this point
    return Dot(environment: environment);
  }

  void naturalSelection() {
    List<Dot> nextGenDots = List.empty(growable: true);

    setBestDot();

    nextGenDots.addAll(List.generate(environment.populationCount, (index) {
      final parent = selectParent();
      return parent.clone();
    }));

    nextGenDots.add(bestDot.clone()..isBest = true);
    _dots = nextGenDots;
    generationCount++;
  }

  void setBestDot() {
    double max = 0;
    int maxIndex = 0;
    for (int i = 0; i < dots.length; i++) {
      if (dots[i].fitness > max) {
        max = dots[i].fitness;
        maxIndex = i;
      }
    }

    bestDot = _dots[maxIndex];

    if (bestDot.didReachGoal) {
      minStepCount = bestDot.steps;
    }
  }

  void mutatePopulation() {
    for (Dot dot in _dots) {
      dot.brain.mutate();
    }
  }
}
