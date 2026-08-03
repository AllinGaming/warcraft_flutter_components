import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftBorderBox', () {
    testWidgets('renders its child with a valid asset', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftBorderBox(
              asset: WarcraftAssets.cardBg,
              sliceInsets: const EdgeInsets.all(48),
              child: const Text('Framed content'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Framed content'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'an invalid asset path reports the failure but the widget tree keeps rendering',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftBorderBox(
              asset: 'assets/warcraft/does-not-exist.webp',
              sliceInsets: const EdgeInsets.all(8),
              child: const Text('Still visible'),
            ),
          ),
        ),
      );
      await tester.pump();

      // The child still renders even though the frame image failed to
      // resolve. The failure is surfaced via FlutterError (so a developer
      // notices a bad asset path) rather than swallowed — consume it here
      // so the test doesn't fail on the reported error itself.
      expect(find.text('Still visible'), findsOneWidget);
      expect(tester.takeException(), isFlutterError);
    });

    testWidgets('shrink-wraps its content by default (no forced alignment)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: WarcraftBorderBox(
                asset: WarcraftAssets.cardBg,
                sliceInsets: const EdgeInsets.all(48),
                child: const SizedBox(width: 40, height: 20),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final size = tester.getSize(find.byType(WarcraftBorderBox));
      expect(size.height, lessThan(100));
    });

    testWidgets('an explicit alignment positions the child within the frame',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftBorderBox(
              asset: WarcraftAssets.cardBg,
              sliceInsets: const EdgeInsets.all(48),
              alignment: Alignment.bottomRight,
              child: const SizedBox(
                width: 400,
                height: 300,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text('Corner'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Corner'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a boxShadow paints without throwing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftBorderBox(
              asset: WarcraftAssets.cardBg,
              sliceInsets: const EdgeInsets.all(48),
              boxShadow: const [
                BoxShadow(blurRadius: 8),
              ],
              child: const Text('Shadowed'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Shadowed'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tileCenter tiles the center region across a large panel',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftBorderBox(
              asset: WarcraftAssets.cardBg,
              sliceInsets: const EdgeInsets.all(48),
              tileCenter: true,
              tileCenterInsets: const EdgeInsets.all(4),
              child: const SizedBox(width: 600, height: 500),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('tileCenter on a panel too small to tile falls back gracefully',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftBorderBox(
              asset: WarcraftAssets.cardBg,
              sliceInsets: const EdgeInsets.all(48),
              tileCenter: true,
              child: const SizedBox(width: 4, height: 4),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'swapping to a different asset disposes the previous decoded image',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftBorderBox(
              asset: WarcraftAssets.cardBg,
              sliceInsets: const EdgeInsets.all(48),
              child: const Text('Content'),
            ),
          ),
        ),
      );
      // Let the first asset's image fully decode before swapping, so the
      // widget actually holds a previous decoded image to dispose (rather
      // than swapping while `_image` is still null).
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftBorderBox(
              asset: WarcraftAssets.accordionHeader,
              sliceInsets: const EdgeInsets.all(6),
              child: const Text('Content'),
            ),
          ),
        ),
      );
      // The new image resolves, the old one is scheduled for disposal via a
      // post-frame callback, and further pumps run that callback.
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
