import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftInput', () {
    testWidgets('renders its hint text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftInput(hintText: 'Enter name'),
          ),
        ),
      );

      expect(find.text('Enter name'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('entering text calls onChanged and updates the field',
        (tester) async {
      String? lastValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftInput(
              hintText: 'Enter name',
              onChanged: (value) => lastValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Thrall');
      await tester.pump();

      expect(lastValue, 'Thrall');
      expect(find.text('Thrall'), findsOneWidget);
    });

    testWidgets('a controller reflects entered text', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftInput(controller: controller),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Jaina');
      await tester.pump();

      expect(controller.text, 'Jaina');
    });

    testWidgets('disabled input does not accept focus for editing',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftInput(hintText: 'Enter name', enabled: false),
          ),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isFalse);
    });

    testWidgets('maxWidth constrains the rendered width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: WarcraftInput(hintText: 'Enter name', maxWidth: 200),
            ),
          ),
        ),
      );

      final width = tester.getSize(find.byType(WarcraftInput)).width;
      expect(width, lessThanOrEqualTo(200));
    });
  });
}
