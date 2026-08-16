import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftDropdownMenu', () {
    testWidgets('opens and shows label/action/separator entries', (
      tester,
    ) async {
      var selected = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftDropdownMenu(
              items: [
                const WarcraftMenuLabel('Section'),
                const WarcraftMenuSeparator(),
                WarcraftMenuAction(
                  label: 'Do the thing',
                  onSelected: () => selected = true,
                ),
              ],
              child: const Text('Open menu'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open menu'));
      await tester.pumpAndSettle();

      expect(find.text('SECTION'), findsOneWidget);
      expect(find.text('Do the thing'), findsOneWidget);

      await tester.tap(find.text('Do the thing'));
      await tester.pumpAndSettle();

      expect(selected, isTrue);
    });

    testWidgets('checkbox entry toggles via onChanged', (tester) async {
      bool? newValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftDropdownMenu(
              items: [
                WarcraftMenuCheckbox(
                  label: 'Enable feature',
                  value: false,
                  onChanged: (v) => newValue = v,
                ),
              ],
              child: const Text('Open menu'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Enable feature'));
      await tester.pumpAndSettle();

      expect(newValue, isTrue);
    });

    testWidgets('radio entry reports the selected value', (tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftDropdownMenu(
              items: [
                WarcraftMenuRadio<String>(
                  label: 'Alliance',
                  value: 'alliance',
                  groupValue: 'horde',
                  onChanged: (v) => selectedValue = v,
                ),
              ],
              child: const Text('Open menu'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Alliance'));
      await tester.pumpAndSettle();

      expect(selectedValue, 'alliance');
    });

    testWidgets('disabled menu does not open', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftDropdownMenu(
              enabled: false,
              items: const [WarcraftMenuLabel('Section')],
              child: const Text('Open menu'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open menu'));
      await tester.pumpAndSettle();

      expect(find.text('SECTION'), findsNothing);
    });

    testWidgets(
      'regression: submenu opens anchored near its trigger row, not at a fixed offset',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.bottomRight,
                child: WarcraftDropdownMenu(
                  items: [
                    WarcraftMenuSubmenu(
                      label: 'More options',
                      children: const [WarcraftMenuLabel('Nested')],
                    ),
                  ],
                  child: const Text('Open menu'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open menu'));
        await tester.pumpAndSettle();

        final triggerRect = tester.getRect(find.text('More options'));

        await tester.tap(find.text('More options'));
        await tester.pumpAndSettle();

        expect(find.text('NESTED'), findsOneWidget);

        final submenuRect = tester.getRect(find.text('NESTED'));
        // The old hardcoded implementation opened at a fixed (100, 100)
        // regardless of the trigger's actual location. Anchoring near the
        // tapped row means the submenu should land within a page-sized
        // distance of the trigger, not at an arbitrary unrelated point.
        expect((submenuRect.top - triggerRect.top).abs(), lessThan(400));
      },
    );

    testWidgets('selecting a nested submenu action invokes its callback', (
      tester,
    ) async {
      var selected = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftDropdownMenu(
              items: [
                WarcraftMenuSubmenu(
                  label: 'More options',
                  children: [
                    WarcraftMenuAction(
                      label: 'Nested action',
                      onSelected: () => selected++,
                    ),
                  ],
                ),
              ],
              child: const Text('Open menu'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('More options'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nested action'));
      await tester.pumpAndSettle();

      expect(selected, 1);
      expect(find.text('Nested action'), findsNothing);
    });

    testWidgets('action supports leading and trailing content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftDropdownMenu(
              tooltip: 'Open inventory actions',
              items: const [
                WarcraftMenuAction(
                  label: 'Equip',
                  leading: Icon(Icons.shield_outlined),
                  trailing: Text('E'),
                ),
              ],
              child: Text('Actions'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
      expect(find.text('E'), findsOneWidget);
    });

    testWidgets('disabled selection entries do not invoke callbacks', (
      tester,
    ) async {
      var checkboxChanges = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftDropdownMenu(
              items: [
                WarcraftMenuCheckbox(
                  label: 'Locked option',
                  value: true,
                  enabled: false,
                  onChanged: (_) => checkboxChanges++,
                ),
              ],
              child: const Text('Open menu'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Locked option'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(checkboxChanges, 0);
    });
  });
}
