// In-Class Activity 06 - Drawing with Flutter
// Student: Darsh Rathi
// Date: September 30, 2026

import 'dart:math' show Random, pi;

import 'package:flutter/material.dart';

void main() => runApp(const SmileyApp());

enum FaceType { classic, sleepy, surprised }

class FaceConfig {
  const FaceConfig({
    required this.mood,
    required this.faceType,
    required this.faceColor,
    required this.showHat,
    required this.showGlasses,
    required this.showMustache,
  });

  final double mood;
  final FaceType faceType;
  final Color faceColor;
  final bool showHat;
  final bool showGlasses;
  final bool showMustache;
}

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
  Color faceColor = Colors.orange.shade400;
  final Random random = Random();
  bool showHat = false;
  bool showGlasses = false;
  bool showMustache = false;
  final List<FaceConfig> history = [];

  String _faceName(FaceType faceType) {
    if (faceType == FaceType.sleepy) return 'Sleepy';
    if (faceType == FaceType.surprised) return 'Surprised';
    return 'Classic';
  }

  Color _colorForMood(double value) {
    if (value < 0.35) return Colors.lightBlue.shade300;
    if (value <= 0.7) return Colors.yellow.shade600;
    return Colors.orange.shade400;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _saveCurrentConfig() {
    history.add(
      FaceConfig(
        mood: mood,
        faceType: selectedFace,
        faceColor: faceColor,
        showHat: showHat,
        showGlasses: showGlasses,
        showMustache: showMustache,
      ),
    );
  }

  void _cycleFace() {
    final currentIndex = FaceType.values.indexOf(selectedFace);
    final nextIndex = (currentIndex + 1) % FaceType.values.length;

    _saveCurrentConfig();
    setState(() {
      selectedFace = FaceType.values[nextIndex];
    });

    _showMessage('Face changed to ${_faceName(selectedFace)}.');
  }

  void _randomizeMoodAndColor() {
    final colors = [
      Colors.purple.shade300,
      Colors.teal.shade300,
      Colors.pink.shade300,
      Colors.amber.shade400,
    ];

    _saveCurrentConfig();
    setState(() {
      mood = random.nextDouble();
      faceColor = colors[random.nextInt(colors.length)];
    });

    _showMessage(
      'Randomized mood to ${mood.toStringAsFixed(2)} and changed the color.',
    );
  }

  void _toggleHat() {
    _saveCurrentConfig();
    setState(() {
      showHat = !showHat;
    });
  }

  void _toggleGlasses() {
    _saveCurrentConfig();
    setState(() {
      showGlasses = !showGlasses;
    });
  }

  void _toggleMustache() {
    _saveCurrentConfig();
    setState(() {
      showMustache = !showMustache;
    });
  }

  void _undo() {
    if (history.isEmpty) {
      _showMessage('There is no earlier face to restore.');
      return;
    }

    final previous = history.removeLast();
    setState(() {
      mood = previous.mood;
      selectedFace = previous.faceType;
      faceColor = previous.faceColor;
      showHat = previous.showHat;
      showGlasses = previous.showGlasses;
      showMustache = previous.showMustache;
    });

    _showMessage('Restored the previous face.');
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
                child: GestureDetector(
                  key: const Key('faceCanvas'),
                  onTap: _cycleFace,
                  onLongPress: _randomizeMoodAndColor,
                  child: CustomPaint(
                    size: const Size(300, 300),
                    painter: SmileyPainter(
                      mood: mood,
                      faceType: selectedFace,
                      faceColor: faceColor,
                      showHat: showHat,
                      showGlasses: showGlasses,
                      showMustache: showMustache,
                    ),
                  ),
                ),
              ),
            ),
            Text('Mood: ${mood.toStringAsFixed(2)}'),
            Slider(
              value: mood,
              onChangeStart: (double value) {
                _saveCurrentConfig();
              },
              onChanged: (double value) {
                setState(() {
                  mood = value;
                  faceColor = _colorForMood(value);
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
                    if (newFace == null || newFace == selectedFace) return;
                    _saveCurrentConfig();
                    setState(() {
                      selectedFace = newFace;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Accessories'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  key: const Key('hatButton'),
                  tooltip: 'Hat',
                  onPressed: _toggleHat,
                  color: showHat ? Colors.indigo : null,
                  icon: const Icon(Icons.checkroom),
                ),
                IconButton(
                  key: const Key('glassesButton'),
                  tooltip: 'Glasses',
                  onPressed: _toggleGlasses,
                  color: showGlasses ? Colors.indigo : null,
                  icon: const Icon(Icons.visibility),
                ),
                IconButton(
                  key: const Key('mustacheButton'),
                  tooltip: 'Mustache',
                  onPressed: _toggleMustache,
                  color: showMustache ? Colors.indigo : null,
                  icon: const Icon(Icons.face),
                ),
                OutlinedButton.icon(
                  key: const Key('undoButton'),
                  onPressed: _undo,
                  icon: const Icon(Icons.undo),
                  label: const Text('Undo'),
                ),
              ],
            ),
            Text('Undo steps: ${history.length}'),
          ],
        ),
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  SmileyPainter({
    required this.mood,
    required this.faceColor,
    this.faceType = FaceType.classic,
    this.showHat = false,
    this.showGlasses = false,
    this.showMustache = false,
  });

  final double mood;
  final Color faceColor;
  final FaceType faceType;
  final bool showHat;
  final bool showGlasses;
  final bool showMustache;

  @override
  void paint(Canvas canvas, Size size) {
    // Base every position and size on the canvas size.
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.4;

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

    // Accessories are painted last so they stay on top of the face.
    if (showHat) {
      final hatPaint = Paint()..color = Colors.indigo.shade700;
      final hatCrown = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy - radius * 0.92),
          width: radius * 0.9,
          height: radius * 0.45,
        ),
        const Radius.circular(12),
      );
      canvas.drawRRect(hatCrown, hatPaint);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy - radius * 0.72),
          width: radius * 1.35,
          height: radius * 0.12,
        ),
        hatPaint,
      );
    }

    if (showGlasses) {
      final glassesPaint = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      final glassesRadius = radius * 0.22;
      canvas.drawCircle(leftEye, glassesRadius, glassesPaint);
      canvas.drawCircle(rightEye, glassesRadius, glassesPaint);
      canvas.drawLine(
        Offset(leftEye.dx + glassesRadius, eyeY),
        Offset(rightEye.dx - glassesRadius, eyeY),
        glassesPaint,
      );
    }

    if (showMustache) {
      final mustachePaint = Paint()
        ..color = Colors.brown.shade800
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round;
      final mustache = Path()
        ..moveTo(center.dx, center.dy + radius * 0.22)
        ..quadraticBezierTo(
          center.dx - radius * 0.16,
          center.dy + radius * 0.1,
          center.dx - radius * 0.38,
          center.dy + radius * 0.24,
        )
        ..moveTo(center.dx, center.dy + radius * 0.22)
        ..quadraticBezierTo(
          center.dx + radius * 0.16,
          center.dy + radius * 0.1,
          center.dx + radius * 0.38,
          center.dy + radius * 0.24,
        );
      canvas.drawPath(mustache, mustachePaint);
    }
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.faceType != faceType ||
        oldDelegate.faceColor != faceColor ||
        oldDelegate.showHat != showHat ||
        oldDelegate.showGlasses != showGlasses ||
        oldDelegate.showMustache != showMustache;
  }
}
