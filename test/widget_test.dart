import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smiley_painter/main.dart';

void main() {
  testWidgets('starter app shows the drawing screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SmileyApp());

    expect(find.text('CustomPainter Smiley Lab'), findsOneWidget);
    expect(find.text('Mood: 0.80'), findsOneWidget);
    expect(find.byType(DrawingPlayground), findsOneWidget);
  });

  test('painter repaints only when the mood changes', () {
    final oldPainter = SmileyPainter(mood: 0.5);

    expect(SmileyPainter(mood: 0.8).shouldRepaint(oldPainter), isTrue);
    expect(
      SmileyPainter(
        mood: 0.5,
        faceType: FaceType.sleepy,
      ).shouldRepaint(oldPainter),
      isTrue,
    );
    expect(SmileyPainter(mood: 0.5).shouldRepaint(oldPainter), isFalse);
  });

  testWidgets('user can select a different face', (WidgetTester tester) async {
    await tester.pumpWidget(const SmileyApp());

    await tester.tap(find.byType(DropdownButton<FaceType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sleepy').last);
    await tester.pumpAndSettle();

    final customPaint = tester.widget<CustomPaint>(
      find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.painter is SmileyPainter,
      ),
    );
    final painter = customPaint.painter! as SmileyPainter;

    expect(painter.faceType, FaceType.sleepy);
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
