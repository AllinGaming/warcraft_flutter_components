import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftTabs', () {
    testWidgets('shows the first tab content and switches on tap', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftTabs(
              labels: const ['Alpha', 'Beta'],
              contents: const [Text('Alpha content'), Text('Beta content')],
            ),
          ),
        ),
      );

      expect(find.text('Alpha content'), findsOneWidget);
      expect(find.text('Beta content'), findsNothing);

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();

      expect(find.text('Beta content'), findsOneWidget);
      expect(find.text('Alpha content'), findsNothing);
    });

    testWidgets('calls onChanged with the new index', (tester) async {
      int? changed;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftTabs(
              labels: const ['Alpha', 'Beta'],
              contents: const [Text('Alpha content'), Text('Beta content')],
              onChanged: (i) => changed = i,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();

      expect(changed, 1);
    });

    testWidgets('renders in vertical orientation without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftTabs(
              orientation: Axis.vertical,
              labels: const ['Alpha', 'Beta'],
              contents: const [Text('Alpha content'), Text('Beta content')],
            ),
          ),
        ),
      );

      expect(find.text('Alpha content'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders for every faction without throwing', (tester) async {
      for (final faction in WarcraftFaction.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WarcraftTabs(
                faction: faction,
                labels: const ['Alpha'],
                contents: const [Text('Alpha content')],
              ),
            ),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('supports externally controlled selection', (tester) async {
      var changed = -1;

      Widget host(int index) => MaterialApp(
        home: Scaffold(
          body: WarcraftTabs(
            labels: const ['Alpha', 'Beta'],
            contents: const [Text('Alpha content'), Text('Beta content')],
            selectedIndex: index,
            onChanged: (value) => changed = value,
          ),
        ),
      );

      await tester.pumpWidget(host(0));
      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();

      expect(changed, 1);
      expect(find.text('Alpha content'), findsOneWidget);

      await tester.pumpWidget(host(1));
      await tester.pumpAndSettle();
      expect(find.text('Beta content'), findsOneWidget);
    });

    testWidgets('supports arrow, Home, and End keyboard navigation', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftTabs(
              autofocus: true,
              labels: const ['Alpha', 'Beta', 'Gamma'],
              contents: const [
                Text('Alpha content'),
                Text('Beta content'),
                Text('Gamma content'),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('Beta content'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();
      expect(find.text('Gamma content'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pumpAndSettle();
      expect(find.text('Alpha content'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(find.text('Gamma content'), findsOneWidget);
    });

    testWidgets('uses vertical arrow keys in vertical orientation', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftTabs(
              autofocus: true,
              orientation: Axis.vertical,
              labels: const ['Alpha', 'Beta'],
              contents: const [Text('Alpha content'), Text('Beta content')],
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(find.text('Beta content'), findsOneWidget);
    });

    test('rejects empty or mismatched tab data', () {
      expect(
        () => WarcraftTabs(labels: const [], contents: const []),
        throwsAssertionError,
      );
      expect(
        () => WarcraftTabs(labels: const ['Alpha'], contents: const []),
        throwsAssertionError,
      );
    });
  });
}
