import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:maze_ai/features/maze_painter.dart';
import 'package:maze_ai/models/area.dart';
import 'package:maze_ai/models/population.dart';
import 'package:maze_ai/utilities/contants.dart';
import 'package:vector_math/vector_math.dart' as vector;

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  static const oneSecond = 1000;

  late Timer timer;
  late Population population;
  late List<Area> areas;

  vector.Vector2 goal = vector.Vector2(600, 525);
  vector.Vector2 start = vector.Vector2(15, 50);

  bool isSimulationRunning = true;
  bool isGridShown = true;

  double calculationSerSecond = fps;

  bool firstClick = false;
  bool secondClick = false;

  Offset? selectedP;

  List<Offset> off = [];
  @override
  void initState() {
    super.initState();

    for (double y = 0; y <= size; y += 50) {
      for (double x = 0; x <= size; x += 50) {
        off.add(Offset(x, y));
      }
    }
    areas = Area.generateDefaultAreas();
    initPopulation();

    timer = Timer.periodic((oneSecond / calculationSerSecond).milliseconds, periodicCallback);
  }

  void initPopulation() {
    population = Population(
      count: dotCount,
      goal: goal,
      startingPosition: start,
      areas: areas,
    );
  }

  void periodicCallback(Timer timer) {
    if (!isSimulationRunning) return;

    if (population.areAllDotsFinished) {
      population.setGenerationSuccess();
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
    const horizontalSpace = SizedBox(width: 50);
    const verticalSpace = SizedBox(height: 50);
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Generation: ${population.generationCount}'),
          Text('Success Rate: ${(population.successRate * 100).toStringAsFixed(2)}%'),
          Text('Alive Dots: ${population.aliveDots}'),
          Text('Dead Dots: ${population.deadDots}'),
          Text('Finished Dots: ${population.finishedDots}'),
          Text('Minimum Steps: ${population.minStepCount}'),
          Text('Fitness Sum: ${population.fitnessSum}'),
          Text('First goal in generation: ${population.generationSuccess}'),
          verticalSpace,
          Center(
            child: SizedBox.square(
              dimension: size,
              child: GestureDetector(
                onTapUp: (tapUpDetails) {
                  final position = tapUpDetails.localPosition;
                  final x = position.dx;
                  final y = position.dy;

                  final point =
                      off.firstOrNullWhere((e) => vector.Vector2(x, y).distanceTo(vector.Vector2(e.dx, e.dy)) < 25) ??
                          Offset(0, 0);
                  if (!firstClick) {
                    selectedP = point;
                    firstClick = true;
                  } else {
                    final isVertical = (selectedP?.dx ?? 0) == point.dx;
                    final left = isVertical ? point.dx - 6 : [(selectedP?.dx ?? 0.0), point.dx].min();
                    final right = isVertical ? point.dx + 6 : [(selectedP?.dx ?? 0.0), point.dx].max();
                    final top = isVertical ? [(selectedP?.dy ?? 0.0), point.dy].max() : point.dy + 6;
                    final bottom = isVertical ? [(selectedP?.dy ?? 0.0), point.dy].min() : point.dy - 6;
                    areas.add(Area.obstacle(
                      left: left!,
                      right: right!,
                      top: top!,
                      bottom: bottom!,
                    ));
                    firstClick = false;
                    selectedP = null;
                    setState(() {});
                  }
                },
                child: CustomPaint(
                  painter: MazePainter(
                    dots: population.dots,
                    goal: goal,
                    isGridShown: isGridShown,
                    areas: areas,
                    selectedPoint: selectedP,
                  ),
                  child: ColoredBox(
                    color: Colors.brown.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
          verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    initPopulation();
                  });
                },
                icon: const Icon(Icons.restart_alt),
              ),
              horizontalSpace,
              IconButton(
                onPressed: () {
                  setState(() {
                    isSimulationRunning = !isSimulationRunning;
                  });
                },
                icon: Icon(isSimulationRunning ? Icons.pause : Icons.play_arrow),
              ),
              horizontalSpace,
              Switch(
                  value: isGridShown,
                  onChanged: (value) {
                    setState(() {
                      isGridShown = value;
                    });
                  }),
              horizontalSpace,
              Slider(
                value: calculationSerSecond,
                onChanged: (value) {
                  calculationSerSecond = value;
                  timer.cancel();
                  timer = Timer.periodic((oneSecond / calculationSerSecond).milliseconds, periodicCallback);
                },
                min: fps,
                max: fpsMax,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
