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

    testWidgets('exposes a combined title+body accessible tooltip string', (
      tester,
    ) async {
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

    testWidgets('renders for every rarity variant without throwing', (
      tester,
    ) async {
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

    testWidgets('forwards timing, placement, and sizing configuration', (
      tester,
    ) async {
      const constraints = BoxConstraints(maxWidth: 240);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftTooltip(
              title: 'Item',
              waitDuration: Duration(milliseconds: 400),
              showDuration: Duration(seconds: 3),
              exitDuration: Duration(milliseconds: 250),
              verticalOffset: 16,
              preferBelow: false,
              constraints: constraints,
              enableTapToDismiss: false,
              child: Text('Hover me'),
            ),
          ),
        ),
      );

      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.waitDuration, const Duration(milliseconds: 400));
      expect(tooltip.showDuration, const Duration(seconds: 3));
      expect(tooltip.exitDuration, const Duration(milliseconds: 250));
      expect(tooltip.verticalOffset, 16);
      expect(tooltip.preferBelow, isFalse);
      expect(tooltip.constraints, constraints);
      expect(tooltip.enableTapToDismiss, isFalse);
    });
  });
}
