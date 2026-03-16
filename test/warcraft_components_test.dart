import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  testWidgets('Pagination shows ellipsis when pages hidden', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WarcraftPagination(
            currentPage: 3,
            pageCount: 10,
            maxVisiblePages: 3,
            onPageChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('♦'), findsWidgets);
  });

  testWidgets('Accordion toggles content on tap', (tester) async {
    final items = [
      WarcraftAccordionItem(
        title: 'Quest',
        content: const Text('Bring me 5 wolf pelts.'),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WarcraftAccordion(items: items),
        ),
      ),
    );

    expect(find.text('Bring me 5 wolf pelts.'), findsNothing);
    await tester.tap(find.text('Quest'));
    await tester.pumpAndSettle();
    expect(find.text('Bring me 5 wolf pelts.'), findsOneWidget);
  });

  testWidgets('Tabs switch content on tap', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WarcraftTabs(
            labels: const ['One', 'Two'],
            contents: const [
              Text('Content One'),
              Text('Content Two'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Content One'), findsOneWidget);
    await tester.tap(find.text('Two'));
    await tester.pumpAndSettle();
    expect(find.text('Content Two'), findsOneWidget);
  });

  testWidgets('Dropdown menu opens', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WarcraftDropdownMenu(
            items: [
              const WarcraftMenuLabel('Actions'),
              WarcraftMenuAction(label: 'Inspect', onSelected: () {}),
            ],
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Inspect'), findsOneWidget);
  });
}
