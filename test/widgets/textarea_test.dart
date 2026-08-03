import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftTextarea', () {
    testWidgets('renders its hint text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftTextarea(hintText: 'Write your quest log'),
          ),
        ),
      );

      expect(find.text('Write your quest log'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('entering text calls onChanged', (tester) async {
      String? lastValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftTextarea(
              hintText: 'Write your quest log',
              onChanged: (value) => lastValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(
        find.byType(TextField),
        'Slay the dragon.',
      );
      await tester.pump();

      expect(lastValue, 'Slay the dragon.');
    });

    testWidgets('honors the configured maxLines', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftTextarea(maxLines: 3),
          ),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.maxLines, 3);
    });

    testWidgets('maxWidth constrains the rendered width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: WarcraftTextarea(maxWidth: 200),
            ),
          ),
        ),
      );

      final width = tester.getSize(find.byType(WarcraftTextarea)).width;
      expect(width, lessThanOrEqualTo(200));
    });
  });
}
