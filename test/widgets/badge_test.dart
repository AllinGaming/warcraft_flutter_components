import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftBadge', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftBadge(child: Text('New')),
          ),
        ),
      );

      expect(find.text('New'), findsOneWidget);
    });

    testWidgets('renders across variants, sizes, factions and shapes',
        (tester) async {
      for (final variant in WarcraftBadgeVariant.values) {
        for (final size in WarcraftBadgeSize.values) {
          for (final faction in WarcraftBadgeFaction.values) {
            for (final shape in WarcraftBadgeShape.values) {
              await tester.pumpWidget(
                MaterialApp(
                  home: Scaffold(
                    body: WarcraftBadge(
                      variant: variant,
                      size: size,
                      faction: faction,
                      shape: shape,
                      child: const Text('Badge'),
                    ),
                  ),
                ),
              );
              expect(find.text('Badge'), findsOneWidget);
            }
          }
        }
      }
    });

    testWidgets(
        'regression: destructive gets its own background wash, distinct from defaultVariant',
        (tester) async {
      Future<DecoratedBox?> pumpAndFindWash(
          WarcraftBadgeVariant variant) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WarcraftBadge(variant: variant, child: const Text('Badge')),
            ),
          ),
        );
        final boxes = find
            .descendant(
              of: find.byType(WarcraftBadge),
              matching: find.byType(DecoratedBox),
            )
            .evaluate()
            .map((e) => e.widget as DecoratedBox);
        for (final box in boxes) {
          final decoration = box.decoration;
          if (decoration is BoxDecoration && decoration.color != null) {
            return box;
          }
        }
        return null;
      }

      final destructiveWash =
          await pumpAndFindWash(WarcraftBadgeVariant.destructive);
      final defaultWash =
          await pumpAndFindWash(WarcraftBadgeVariant.defaultVariant);

      expect(destructiveWash, isNotNull);
      expect(defaultWash, isNull);
    });

    testWidgets('constrains width to maxWidth', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftBadge(maxWidth: 100, child: Text('Badge')),
          ),
        ),
      );

      final size = tester.getSize(find.byType(WarcraftBadge));
      expect(size.width, lessThanOrEqualTo(100));
    });
  });
}
