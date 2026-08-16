import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('tap target accessibility guideline', () {
    testWidgets('WarcraftButton (sm size) meets the 48x48 minimum', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftButton(
              size: WarcraftButtonSize.sm,
              onPressed: () {},
              child: const Text('OK'),
            ),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('WarcraftRadio meets the 48x48 minimum', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftRadio<String>(
              value: 'a',
              groupValue: 'a',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('WarcraftPagination page buttons meet the 48x48 minimum', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftPagination(
              currentPage: 1,
              pageCount: 5,
              onPageChanged: (_) {},
            ),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('WarcraftCheckbox meets the 48x48 minimum', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftCheckbox(value: false, onChanged: (_) {}),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('WarcraftTabs triggers meet the 48x48 minimum', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftTabs(
              labels: const ['Overview', 'Equipment'],
              contents: const [Text('Overview'), Text('Equipment')],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      handle.dispose();
    });
  });

  group('large text accessibility', () {
    testWidgets('interactive controls remain layout-safe at 200% text', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: Scaffold(
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                WarcraftRadio<String>(
                  value: 'healer',
                  groupValue: 'tank',
                  onChanged: (_) {},
                  label: const Text('Restoration specialist'),
                ),
                WarcraftTabs(
                  labels: const ['Character overview', 'Equipment loadout'],
                  contents: const [Text('Overview'), Text('Equipment')],
                  onChanged: (_) {},
                ),
                const SizedBox(height: 16),
                const WarcraftInput(
                  semanticLabel: 'Character name',
                  helperText: 'Visible to other players',
                ),
                const SizedBox(height: 16),
                const WarcraftTextarea(
                  semanticLabel: 'Character biography',
                  errorText: 'A biography is required',
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
