import 'package:flutter_test/flutter_test.dart';

import 'package:microstep/main.dart';
// Imports our actual app entry point so the test can instantiate it.

void main() {
  testWidgets('MicroStep app renders foundation text', (WidgetTester tester) async {
    // pumpWidget builds the widget tree once inside a simulated test environment
    // (no real device/emulator needed — this runs headlessly, fast).
    await tester.pumpWidget(const MicroStepApp());

    // find.text() searches the rendered widget tree for a Text widget
    // with this exact string. expect(..., findsOneWidget) asserts it exists.
    expect(find.text('MicroStep — Foundation Ready'), findsOneWidget);
  });
}
