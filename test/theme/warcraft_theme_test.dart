import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftThemeData', () {
    test('provides distinct faction accents', () {
      final orc = WarcraftThemeData.forFaction(WarcraftFaction.orc);
      final human = WarcraftThemeData.forFaction(WarcraftFaction.human);

      expect(orc.primary, isNot(human.primary));
      expect(orc.focusRing, isNot(human.focusRing));
      expect(orc.foreground, human.foreground);
    });

    test('copyWith preserves unspecified values', () {
      final customized = WarcraftThemeData.classic.copyWith(
        primary: Colors.cyan,
        radius: 14,
      );

      expect(customized.primary, Colors.cyan);
      expect(customized.radius, 14);
      expect(customized.background, WarcraftThemeData.classic.background);
    });

    testWidgets('themeData installs the requested extension', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          theme: WarcraftTheme.themeData(faction: WarcraftFaction.undead),
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final data = WarcraftTheme.of(capturedContext);
      expect(
        data.primary,
        WarcraftThemeData.forFaction(WarcraftFaction.undead).primary,
      );
      expect(
        Theme.of(capturedContext).scaffoldBackgroundColor,
        data.background,
      );
    });

    testWidgets('falls back to the classic palette', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(WarcraftTheme.of(capturedContext), WarcraftThemeData.classic);
    });

    testWidgets('motionDurationOf respects reduced-motion settings', (
      tester,
    ) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(WarcraftTheme.motionDurationOf(capturedContext), Duration.zero);
    });
  });

  group('WarcraftTheme.textTheme', () {
    testWidgets('applies the bundled font family to every text style', (
      tester,
    ) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final themed = WarcraftTheme.textTheme(capturedContext);

      expect(themed.bodyMedium?.fontFamily, WarcraftTheme.fontFamily);
      expect(themed.titleLarge?.fontFamily, WarcraftTheme.fontFamily);
      expect(themed.labelSmall?.fontFamily, WarcraftTheme.fontFamily);
    });
  });
}
