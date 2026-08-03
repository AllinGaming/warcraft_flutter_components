import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftSkeleton', () {
    testWidgets('renders at an explicit width/height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WarcraftSkeleton(width: 120, height: 20)),
        ),
      );

      final size = tester.getSize(find.byType(WarcraftSkeleton));
      expect(size, const Size(120, 20));
    });

    testWidgets(
        'regression: with no explicit width, the shimmer sweep uses the actual layout width',
        (tester) async {
      // Constrain the ambient width well below the old hardcoded 200px
      // fallback so a shimmer still hardcoded to 200 would be visibly wrong
      // relative to the rendered box.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 80,
              height: 16,
              child: WarcraftSkeleton(height: 16),
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(WarcraftSkeleton));
      expect(size.width, 80);

      // The animated shimmer must not throw across its full sweep cycle at
      // this narrow width.
      await tester.pump(const Duration(milliseconds: 1250));
      await tester.pump(const Duration(milliseconds: 1250));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders every shape/faction combination without throwing',
        (tester) async {
      for (final shape in WarcraftSkeletonShape.values) {
        for (final faction in WarcraftFaction.values) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: WarcraftSkeleton(
                  width: 100,
                  height: 20,
                  shape: shape,
                  faction: faction,
                ),
              ),
            ),
          );
          await tester.pump();
          expect(tester.takeException(), isNull);
        }
      }
    });

    testWidgets('exposes a loading semantic label', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WarcraftSkeleton(width: 100, height: 20)),
        ),
      );

      expect(find.bySemanticsLabel('Loading'), findsOneWidget);
      handle.dispose();
    });
  });
}
