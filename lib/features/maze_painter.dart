import 'package:flutter/material.dart';
import 'package:maze_ai/models/dot.dart';
import 'package:maze_ai/utilities/contants.dart';
import 'package:vector_math/vector_math.dart' as vector;

const _gridInterval = 50;

class MazePainter extends CustomPainter {
  MazePainter({
    required this.dots,
    required this.goal,
    super.repaint,
  });

  final List<Dot> dots;
  final vector.Vector2 goal;

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // for (double y = 0; y <= size.width; y += _gridInterval) {
    //   for (double x = 0; x <= size.height; x += _gridInterval) {
    //     canvas.drawCircle(Offset(x, y), 3, gridPaint);
    //     textPainter.text = TextSpan(
    //       text: '$x\n$y',
    //       style: const TextStyle(fontSize: 10),
    //     );
    //     textPainter.layout(maxWidth: 40);
    //     textPainter.paint(canvas, Offset(x, y));
    //   }
    // }

    canvas.drawCircle(Offset(goal.x, goal.y), goalRadius, dotPaint..color = Colors.red);

    canvas.drawRect(const Rect.fromLTWH(150, 250, 300, 100), dotPaint..color = Colors.blueGrey);

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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
