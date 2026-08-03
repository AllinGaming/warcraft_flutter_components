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
