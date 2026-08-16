import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftPagination', () {
    testWidgets('renders page numbers and an ellipsis for hidden pages', (
      tester,
    ) async {
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

    testWidgets('tapping Previous invokes onPageChanged with the prior page', (
      tester,
    ) async {
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

    testWidgets('tapping Next invokes onPageChanged with the following page', (
      tester,
    ) async {
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

    testWidgets('the visible page window shifts left near the last page', (
      tester,
    ) async {
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

    testWidgets('supports localized navigation and page semantics', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftPagination(
              currentPage: 2,
              pageCount: 3,
              previousLabel: 'Back',
              nextLabel: 'Forward',
              semanticLabel: 'Quest pages',
              onPageChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Forward'), findsOneWidget);
      expect(find.bySemanticsLabel('Quest pages'), findsOneWidget);
      expect(find.bySemanticsLabel('Page 2, current page'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('supports fully localized page and ellipsis semantics', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftPagination(
              currentPage: 5,
              pageCount: 10,
              pageSemanticLabelBuilder: (page) => 'Idi na stranu $page',
              currentPageSemanticLabelBuilder: (page) =>
                  'Strana $page, trenutna',
              ellipsisSemanticLabel: 'Još strana',
              onPageChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Strana 5, trenutna'), findsOneWidget);
      expect(find.bySemanticsLabel('Idi na stranu 4'), findsOneWidget);
      expect(find.bySemanticsLabel('Još strana'), findsNWidgets(2));
      handle.dispose();
    });

    test('rejects invalid page ranges', () {
      expect(
        () => WarcraftPagination(
          currentPage: 0,
          pageCount: 5,
          onPageChanged: (_) {},
        ),
        throwsAssertionError,
      );
      expect(
        () => WarcraftPagination(
          currentPage: 1,
          pageCount: 0,
          onPageChanged: (_) {},
        ),
        throwsAssertionError,
      );
    });
  });
}
