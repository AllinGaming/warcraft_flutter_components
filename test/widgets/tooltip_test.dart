import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftTooltip', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftTooltip(
              title: 'Frostmourne',
              child: Text('Hover me'),
            ),
          ),
        ),
      );

      expect(find.text('Hover me'), findsOneWidget);
    });

    testWidgets('exposes a combined title+body accessible tooltip string',
        (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftTooltip(
              title: 'Frostmourne',
              body: 'Hungers for souls',
              child: Text('Hover me'),
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.text('Hover me'));
      expect(semantics.tooltip, 'Frostmourne. Hungers for souls');
      handle.dispose();
    });

    testWidgets('renders for every rarity variant without throwing',
        (tester) async {
      for (final variant in WarcraftTooltipVariant.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WarcraftTooltip(
                title: 'Item',
                variant: variant,
                child: const Text('Hover me'),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
      }
    });
  });
}
