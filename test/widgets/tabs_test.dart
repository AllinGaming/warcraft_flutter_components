import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftTabs', () {
    testWidgets('shows the first tab content and switches on tap',
        (tester) async {
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

    testWidgets('renders in vertical orientation without throwing',
        (tester) async {
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
  });
}
