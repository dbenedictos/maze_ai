import 'package:maze_ai/models/area.dart';
import 'package:vector_math/vector_math.dart';

class Environment {
  Environment();

  static const dotRadius = 2.0;
  static const goalRadius = 20.0;
  static const int size = 600;
  static const int fps = 30;
  static const int fpsMax = 100;

  final Vector2 goal = Vector2(600, 525);
  final Vector2 start = Vector2(15, 50);

  late int populationCount;
  late int geneCount;

  late List<Area> areas;

  void initialize({int populationCount = 1000, int geneCount = 1000}) {
    this.populationCount = populationCount;
    this.geneCount = geneCount;
    areas = Area.generateDefaultAreas();
  }
}
