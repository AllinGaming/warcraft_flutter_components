import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftPagination', () {
    testWidgets('renders page numbers and an ellipsis for hidden pages',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftPagination(
              currentPage: 5,
              pageCount: 10,
              onPageChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
      expect(find.textContaining('♦'), findsWidgets);
    });

    testWidgets('tapping a page number invokes onPageChanged', (tester) async {
      int? tapped;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftPagination(
              currentPage: 1,
              pageCount: 5,
              onPageChanged: (page) => tapped = page,
            ),
          ),
        ),
      );

      await tester.tap(find.text('2'));
      await tester.pump();

      expect(tapped, 2);
    });

    testWidgets('Previous is disabled on the first page', (tester) async {
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

      final button = tester.widget<WarcraftButton>(
        find.ancestor(
          of: find.text('Previous'),
          matching: find.byType(WarcraftButton),
        ),
      );
      expect(button.enabled, isFalse);
    });

    testWidgets('tapping Previous invokes onPageChanged with the prior page',
        (tester) async {
      int? tapped;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftPagination(
              currentPage: 3,
              pageCount: 5,
              onPageChanged: (page) => tapped = page,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Previous'));
      await tester.pump();

      expect(tapped, 2);
    });

    testWidgets('tapping Next invokes onPageChanged with the following page',
        (tester) async {
      int? tapped;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftPagination(
              currentPage: 3,
              pageCount: 5,
              onPageChanged: (page) => tapped = page,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Next'));
      await tester.pump();

      expect(tapped, 4);
    });

    testWidgets('the visible page window shifts left near the last page',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftPagination(
              currentPage: 10,
              pageCount: 10,
              onPageChanged: (_) {},
            ),
          ),
        ),
      );

      // The window should clamp to the last 3 pages (8, 9, 10) rather than
      // overflow past pageCount.
      expect(find.text('8'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('11'), findsNothing);
    });
  });
}
