// In-Class Activity 06 — Drawing with Flutter
// Student: A.J. Orea
// Date: September 26, 2026

import 'package:flutter/material.dart';
import 'dart:math' show pi;
import 'dart:ui';

void main() => runApp(const SmileyApp());

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smiley Painter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DrawingPlayground(),
    );
  }
}

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  // Drawing "state" — changing these + setState() triggers shouldRepaint
  double mood = 0.8; // 0.0 sad → 1.0 happy

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomPainter Smiley Lab')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: CustomPaint(
                size: const Size(300, 300),
                painter: SmileyPainter(mood: mood),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Mood: ${mood.toStringAsFixed(2)}'),
                Slider(
                  value: mood,
                  onChanged: (double v) => setState(() => mood = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  SmileyPainter({required this.mood});
  final double mood;

  @override
  void paint(Canvas canvas, Size size) {
    // Modules 2–3: add eyes and mouth here. Base every position on size, center, or radius.
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.4;

    Color faceColor;
    if (mood < 0.35) {
      faceColor = Colors.blue.shade300;     // sad/cool
    } else if (mood < 0.7) {
      faceColor = Colors.yellow.shade600;   // neutral
    } else {
      faceColor = Colors.orange.shade400;   // happy/warm
    }
    // (1)
    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, facePaint);
    //(2)
    final border = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, border);
    //(3) Eyes
    final eyePaint = Paint()..color = Colors.black87;
    final eyeRadius = radius * 0.08;
    final eyeY = center.dy -radius * 0.18;
    final eyeDx = radius * 0.35;
    canvas.drawCircle(Offset(center.dx - eyeDx, eyeY), eyeRadius, eyePaint);
    canvas.drawCircle(Offset(center.dx + eyeDx, eyeY), eyeRadius, eyePaint);
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final mouthOffset = lerpDouble(radius * .25, 0.0, mood)!;
    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + radius * 0.15 + mouthOffset),
      width: radius * 1.0,
      height: radius * (0.4 + mood * 0.5),
    );
    if (mood >= 0.5) {
      canvas.drawArc(mouthRect, 0.15 * pi, 0.70 * pi, false, mouthPaint);
    } else {
      final frownRect = mouthRect.translate(0, radius * 0.25);
      canvas.drawArc(frownRect, 1.15 * pi, 0.70 * pi, false, mouthPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood;
  }
}