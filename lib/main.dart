// In-Class Activity 06 - Drawing with Flutter
// Student: Darsh Rathi
// Date: September 30, 2026

import 'dart:math' show pi;

import 'package:flutter/material.dart';

void main() => runApp(const SmileyApp());

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smiley Painter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
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
  // Drawing state - changing this with setState triggers shouldRepaint.
  double mood = 0.8;

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
                  onChanged: (double value) {
                    setState(() {
                      mood = value;
                    });
                  },
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
    // Base every position and size on the canvas size.
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.4;

    Color faceColor;
    if (mood < 0.35) {
      faceColor = Colors.lightBlue.shade300;
    } else if (mood <= 0.7) {
      faceColor = Colors.yellow.shade600;
    } else {
      faceColor = Colors.orange.shade400;
    }

    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, facePaint);

    final border = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, radius, border);

    // Draw two eyes using matching offsets from the center.
    final eyePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;
    final eyeRadius = radius * 0.09;
    final eyeY = center.dy - radius * 0.25;
    final eyeDistance = radius * 0.35;

    canvas.drawCircle(
      Offset(center.dx - eyeDistance, eyeY),
      eyeRadius,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + eyeDistance, eyeY),
      eyeRadius,
      eyePaint,
    );

    // The mood changes the mouth size and direction.
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    if (mood < 0.35) {
      final frownRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.38),
        width: radius * 0.9,
        height: radius * 0.55,
      );
      canvas.drawArc(frownRect, 1.15 * pi, 0.70 * pi, false, mouthPaint);
    } else if (mood <= 0.7) {
      final softSmileRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.16),
        width: radius * 0.85,
        height: radius * 0.45,
      );
      canvas.drawArc(softSmileRect, 0.18 * pi, 0.64 * pi, false, mouthPaint);
    } else {
      final bigSmileRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.1),
        width: radius * 1.05,
        height: radius * (0.55 + mood * 0.25),
      );
      canvas.drawArc(bigSmileRect, 0.15 * pi, 0.70 * pi, false, mouthPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood;
  }
}
