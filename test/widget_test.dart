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
}
