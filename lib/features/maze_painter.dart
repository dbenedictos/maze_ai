import 'package:flutter/material.dart';
import 'package:maze_ai/models/area.dart';
import 'package:maze_ai/models/dot.dart';
import 'package:maze_ai/utilities/contants.dart';
import 'package:vector_math/vector_math.dart' as vector;

const _gridInterval = 50;

class MazePainter extends CustomPainter {
  MazePainter({
    required this.dots,
    required this.goal,
    required this.areas,
    this.selectedPoint,
    this.isGridShown = false,
    super.repaint,
  });

  final List<Dot> dots;
  final List<Area> areas;
  final vector.Vector2 goal;
  final bool isGridShown;
  final Offset? selectedPoint;

  @override
  void paint(Canvas canvas, Size size) {
    final selectedPaint = Paint()
      ..color = Colors.greenAccent.withOpacity(.5)
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = Colors.black
      ..style;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    canvas.drawCircle(Offset(goal.x, goal.y), goalRadius, dotPaint..color = Colors.red);

    if (selectedPoint != null) {
      canvas.drawCircle(selectedPoint!, 7, selectedPaint);
    }

    for (var area in areas) {
      final isObstacle = area.type == Type.OBSTACLE;
      canvas.drawRect(Rect.fromLTRB(area.left, area.top, area.right, area.bottom),
          dotPaint..color = isObstacle ? Colors.blueGrey : Colors.amberAccent);
      if (!isObstacle) {
        textPainter.text = TextSpan(
          text: '${area.checkPointNumber}',
          style: const TextStyle(fontSize: 10),
        );
        textPainter.layout(maxWidth: 40);
        textPainter.paint(canvas, Offset(area.center.x, area.center.y));
      }
    }

    for (Dot dot in dots) {
      final position = dot.position;
      canvas.drawCircle(Offset(position.x, position.y), dotRadius * (dot.isBest ? 2 : 1),
          dotPaint..color = dot.isBest ? Colors.green : dot.color);
      // textPainter.text = TextSpan(
      //   text: '${dot.brain.step}',
      //   style: const TextStyle(fontSize: 10),
      // );
      // textPainter.layout(maxWidth: 40);
      // textPainter.paint(canvas, Offset(position.x + 10, position.y));
    }

    if (isGridShown) {
      final gridPaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      for (double y = 0; y <= size.width; y += _gridInterval) {
        for (double x = 0; x <= size.height; x += _gridInterval) {
          canvas.drawCircle(Offset(x, y), 3, gridPaint);
          textPainter.text = TextSpan(
            text: '$x\n$y',
            style: const TextStyle(fontSize: 10),
          );
          textPainter.layout(maxWidth: 40);
          textPainter.paint(canvas, Offset(x, y));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
