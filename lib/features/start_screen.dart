import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:maze_ai/features/maze_painter.dart';
import 'package:maze_ai/models/population.dart';
import 'package:maze_ai/utilities/contants.dart';
import 'package:vector_math/vector_math.dart' as vector;

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late Timer timer;
  // late Stopwatch stopwatch;
  // late bool hasMutated;

  late Population population;

  vector.Vector2 goal = vector.Vector2(300, 575);

  static const oneSecond = 1000;

  @override
  void initState() {
    super.initState();

    initPopulation();

    timer = Timer.periodic((oneSecond / fps).milliseconds, periodicCallback);
  }

  void initPopulation() {
    population = Population(
      count: dotCount,
      goal: goal,
      startingPosition: vector.Vector2(size / 2, 11),
    );
  }

  void periodicCallback(Timer timer) {
    if (population.areAllDotsFinished) {
      // calculate successRate
      population.calculateSuccessRate();
      // calculate fitness
      population.calculateFitness();
      // natural selection
      population.naturalSelection();
      // mutate multiplication
      population.mutatePopulation();
    } else {
      population.move();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Generation: ${population.generationCount}'),
          Text('Success Rate: ${(population.successRate * 100).toStringAsFixed(2)}'),
          Text('Alive Dots: ${population.aliveDots}'),
          Text('Dead Dots: ${population.deadDots}'),
          Text('Finished Dots: ${population.finishedDots}'),
          Text('Minimum Steps: ${population.minStepCount}'),
          Text('Fitness Sum: ${population.fitnessSum}'),
          const SizedBox(height: 50),
          Center(
            child: SizedBox.square(
              dimension: size,
              child: CustomPaint(
                painter: MazePainter(
                  dots: population.dots,
                  goal: goal,
                ),
                child: ColoredBox(
                  color: Colors.brown.withOpacity(0.1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
