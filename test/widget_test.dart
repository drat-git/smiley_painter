import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smiley_painter/main.dart';

SmileyPainter currentPainter(WidgetTester tester) {
  final customPaint = tester.widget<CustomPaint>(
    find.byWidgetPredicate(
      (widget) => widget is CustomPaint && widget.painter is SmileyPainter,
    ),
  );
  return customPaint.painter! as SmileyPainter;
}

void main() {
  testWidgets('starter app shows the drawing screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SmileyApp());

    expect(find.text('CustomPainter Smiley Lab'), findsOneWidget);
    expect(find.text('Mood: 0.80'), findsOneWidget);
    expect(find.byType(DrawingPlayground), findsOneWidget);
  });

  test('painter repaints only when an input changes', () {
    final oldPainter = SmileyPainter(mood: 0.5, faceColor: Colors.yellow);

    expect(
      SmileyPainter(
        mood: 0.8,
        faceColor: Colors.yellow,
      ).shouldRepaint(oldPainter),
      isTrue,
    );
    expect(
      SmileyPainter(
        mood: 0.5,
        faceColor: Colors.yellow,
        faceType: FaceType.sleepy,
      ).shouldRepaint(oldPainter),
      isTrue,
    );
    expect(
      SmileyPainter(
        mood: 0.5,
        faceColor: Colors.blue,
      ).shouldRepaint(oldPainter),
      isTrue,
    );
    expect(
      SmileyPainter(
        mood: 0.5,
        faceColor: Colors.yellow,
      ).shouldRepaint(oldPainter),
      isFalse,
    );
  });

  testWidgets('user can select a different face', (WidgetTester tester) async {
    await tester.pumpWidget(const SmileyApp());

    await tester.tap(find.byType(DropdownButton<FaceType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sleepy').last);
    await tester.pumpAndSettle();

    expect(currentPainter(tester).faceType, FaceType.sleepy);
  });

  testWidgets('tap cycles the face and shows feedback', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SmileyApp());

    await tester.tap(find.byKey(const Key('faceCanvas')));
    await tester.pump();

    expect(currentPainter(tester).faceType, FaceType.sleepy);
    expect(find.text('Face changed to Sleepy.'), findsOneWidget);
  });

  testWidgets('long press randomizes mood and face color', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SmileyApp());

    await tester.longPress(find.byKey(const Key('faceCanvas')));
    await tester.pump();

    expect(currentPainter(tester).faceColor, isNot(Colors.orange.shade400));
    expect(find.textContaining('Randomized mood to'), findsOneWidget);
  });

  testWidgets('screen does not overflow in a phone landscape size', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const SmileyApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
