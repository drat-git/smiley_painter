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
    expect(SmileyPainter(mood: 0.5).shouldRepaint(oldPainter), isFalse);
  });
}
