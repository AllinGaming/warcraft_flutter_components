import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftRadio', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftRadio<String>(
              value: 'a',
              groupValue: 'a',
              label: Text('Option A'),
            ),
          ),
        ),
      );

      expect(find.text('Option A'), findsOneWidget);
    });

    testWidgets('tapping an unselected radio calls onChanged with its value',
        (tester) async {
      String? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftRadio<String>(
              value: 'b',
              groupValue: 'a',
              onChanged: (next) => selected = next,
              label: const Text('Option B'),
            ),
          ),
        ),
      );

      await tester.tap(_socket(find.byType(WarcraftRadio<String>)));
      await tester.pump();

      expect(selected, 'b');
    });

    testWidgets('disabled radio does not call onChanged', (tester) async {
      var callCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftRadio<String>(
              value: 'b',
              groupValue: 'a',
              enabled: false,
              onChanged: (_) => callCount++,
              label: const Text('Option B'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(WarcraftRadio<String>));
      await tester.pump();

      expect(callCount, 0);
    });

    testWidgets('has a minimum 48x48 tap target', (tester) async {
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

      final size = tester.getSize(find.byType(WarcraftRadio<String>));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
    });
  });

  group('WarcraftRadioGroup', () {
    testWidgets('lays out all children vertically by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftRadioGroup<String>(
              children: [
                WarcraftRadio<String>(
                  value: 'a',
                  groupValue: 'a',
                  onChanged: (_) {},
                  label: const Text('Option A'),
                ),
                WarcraftRadio<String>(
                  value: 'b',
                  groupValue: 'a',
                  onChanged: (_) {},
                  label: const Text('Option B'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(WarcraftRadio<String>), findsNWidgets(2));
      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);

      final columnFinder = find.descendant(
        of: find.byType(WarcraftRadioGroup<String>),
        matching: find.byType(Column),
      );
      expect(columnFinder, findsOneWidget);
    });

    testWidgets('lays out children horizontally with Axis.horizontal',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftRadioGroup<String>(
              direction: Axis.horizontal,
              children: [
                WarcraftRadio<String>(
                  value: 'a',
                  groupValue: 'a',
                  onChanged: (_) {},
                  label: const Text('Option A'),
                ),
                WarcraftRadio<String>(
                  value: 'b',
                  groupValue: 'a',
                  onChanged: (_) {},
                  label: const Text('Option B'),
                ),
              ],
            ),
          ),
        ),
      );

      final wrapFinder = find.descendant(
        of: find.byType(WarcraftRadioGroup<String>),
        matching: find.byType(Wrap),
      );
      expect(wrapFinder, findsOneWidget);
    });

    testWidgets('selecting a radio in the group updates selection',
        (tester) async {
      var groupValue = 'a';
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: WarcraftRadioGroup<String>(
                  children: [
                    WarcraftRadio<String>(
                      value: 'a',
                      groupValue: groupValue,
                      onChanged: (next) => setState(() => groupValue = next),
                      label: const Text('Option A'),
                    ),
                    WarcraftRadio<String>(
                      value: 'b',
                      groupValue: groupValue,
                      onChanged: (next) => setState(() => groupValue = next),
                      label: const Text('Option B'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      await tester.tap(_socket(find.byType(WarcraftRadio<String>).at(1)));
      await tester.pump();

      expect(groupValue, 'b');
    });
  });
}

/// Finds the tappable [GestureDetector] socket inside a [WarcraftRadio],
/// since the widget's overall bounds (socket + label) can be wider than the
/// actual tappable circle when a label is present.
Finder _socket(Finder radioFinder) {
  return find.descendant(
    of: radioFinder,
    matching: find.byType(GestureDetector),
  );
}
