import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftLabel', () {
    testWidgets('renders its text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftLabel(text: 'Character name'),
          ),
        ),
      );

      expect(find.text('Character name'), findsOneWidget);
      expect(find.text('✦'), findsNothing);
    });

    testWidgets('isRequired renders the required marker', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftLabel(text: 'Character name', isRequired: true),
          ),
        ),
      );

      expect(find.text('Character name'), findsOneWidget);
      expect(find.text('✦'), findsOneWidget);
    });

    testWidgets('renders across variants', (tester) async {
      for (final variant in WarcraftLabelVariant.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WarcraftLabel(text: 'Label', variant: variant),
            ),
          ),
        );
        expect(find.text('Label'), findsOneWidget);
      }
    });
  });
}
