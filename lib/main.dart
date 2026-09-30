// In-Class Activity 06 - Drawing with Flutter
// Student: Darsh Rathi
// Date: September 30, 2026

import 'dart:math' show pi;

import 'package:flutter/material.dart';

void main() => runApp(const SmileyApp());

enum FaceType { classic, sleepy, surprised }

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
  FaceType selectedFace = FaceType.classic;

  String _faceName(FaceType faceType) {
    if (faceType == FaceType.sleepy) return 'Sleepy';
    if (faceType == FaceType.surprised) return 'Surprised';
    return 'Classic';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomPainter Smiley Lab')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 340,
              child: Center(
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: SmileyPainter(mood: mood, faceType: selectedFace),
                ),
              ),
            ),
            Text('Mood: ${mood.toStringAsFixed(2)}'),
            Slider(
              value: mood,
              onChanged: (double value) {
                setState(() {
                  mood = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Face: '),
                DropdownButton<FaceType>(
                  value: selectedFace,
                  items: FaceType.values.map((faceType) {
                    return DropdownMenuItem<FaceType>(
                      value: faceType,
                      child: Text(_faceName(faceType)),
                    );
                  }).toList(),
                  onChanged: (FaceType? newFace) {
                    if (newFace == null) return;
                    setState(() {
                      selectedFace = newFace;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  SmileyPainter({required this.mood, this.faceType = FaceType.classic});

  final double mood;
  final FaceType faceType;

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

    // Draw eyes using matching offsets from the center.
    final eyeY = center.dy - radius * 0.25;
    final eyeDistance = radius * 0.35;
    final leftEye = Offset(center.dx - eyeDistance, eyeY);
    final rightEye = Offset(center.dx + eyeDistance, eyeY);

    if (faceType == FaceType.sleepy) {
      final sleepyEyePaint = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      final eyeRectSize = radius * 0.32;

      canvas.drawArc(
        Rect.fromCenter(
          center: leftEye,
          width: eyeRectSize,
          height: eyeRectSize * 0.65,
        ),
        0,
        pi,
        false,
        sleepyEyePaint,
      );
      canvas.drawArc(
        Rect.fromCenter(
          center: rightEye,
          width: eyeRectSize,
          height: eyeRectSize * 0.65,
        ),
        0,
        pi,
        false,
        sleepyEyePaint,
      );
    } else {
      final eyePaint = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.fill;
      final eyeRadius = faceType == FaceType.surprised
          ? radius * 0.14
          : radius * 0.09;

      canvas.drawCircle(leftEye, eyeRadius, eyePaint);
      canvas.drawCircle(rightEye, eyeRadius, eyePaint);
    }

    // The mood changes the mouth size and direction.
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    if (faceType == FaceType.surprised) {
      final mouthRadius = radius * (0.1 + mood * 0.06);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + radius * 0.35),
          width: mouthRadius * 1.5,
          height: mouthRadius * 2.2,
        ),
        Paint()..color = Colors.black87,
      );
    } else if (faceType == FaceType.sleepy) {
      final sleepyMouth = Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.3),
        width: radius * 0.55,
        height: radius * (0.18 + mood * 0.12),
      );
      canvas.drawArc(sleepyMouth, 0.15 * pi, 0.70 * pi, false, mouthPaint);
    } else if (mood < 0.35) {
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
    return oldDelegate.mood != mood || oldDelegate.faceType != faceType;
  }
}
