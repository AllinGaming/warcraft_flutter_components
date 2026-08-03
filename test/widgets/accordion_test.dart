import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftAccordion', () {
    testWidgets('renders headers and toggles a body open/closed',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftAccordion(
              items: [
                WarcraftAccordionItem(
                  title: 'Quest 1',
                  content: const Text('Slay the dragon'),
                ),
                WarcraftAccordionItem(
                  title: 'Quest 2',
                  content: const Text('Find the relic'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Quest 1'), findsOneWidget);
      expect(find.text('Quest 2'), findsOneWidget);
      expect(find.text('Slay the dragon'), findsNothing);

      await tester.tap(find.text('Quest 1'));
      await tester.pumpAndSettle();

      expect(find.text('Slay the dragon'), findsOneWidget);

      await tester.tap(find.text('Quest 1'));
      await tester.pumpAndSettle();

      expect(find.text('Slay the dragon'), findsNothing);
    });

    testWidgets('honors an item that starts expanded', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftAccordion(
              items: [
                WarcraftAccordionItem(
                  title: 'Quest 1',
                  content: const Text('Slay the dragon'),
                  isExpanded: true,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Slay the dragon'), findsOneWidget);
    });

    testWidgets(
        'regression: swapping in a same-length but different item list resets expand state',
        (tester) async {
      final firstItems = [
        WarcraftAccordionItem(title: 'A', content: const Text('A body')),
        WarcraftAccordionItem(title: 'B', content: const Text('B body')),
      ];

      Widget host(List<WarcraftAccordionItem> items) => MaterialApp(
            home: Scaffold(body: WarcraftAccordion(items: items)),
          );

      await tester.pumpWidget(host(firstItems));
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      expect(find.text('A body'), findsOneWidget);

      // Same length (2), but different item instances/content entirely.
      final secondItems = [
        WarcraftAccordionItem(title: 'C', content: const Text('C body')),
        WarcraftAccordionItem(title: 'D', content: const Text('D body')),
      ];
      await tester.pumpWidget(host(secondItems));
      await tester.pumpAndSettle();

      expect(find.text('C'), findsOneWidget);
      expect(find.text('C body'), findsNothing);
      expect(find.text('D body'), findsNothing);
    });

    testWidgets(
        'an unrelated rebuild with the same item instances preserves expand state',
        (tester) async {
      final items = [
        WarcraftAccordionItem(title: 'A', content: const Text('A body')),
      ];

      Widget host() => MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  WarcraftAccordion(items: items),
                  const Text('rebuild marker'),
                ],
              ),
            ),
          );

      await tester.pumpWidget(host());
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      expect(find.text('A body'), findsOneWidget);

      // Rebuild with the exact same item list instance.
      await tester.pumpWidget(host());
      await tester.pumpAndSettle();

      expect(find.text('A body'), findsOneWidget);
    });
  });
}
