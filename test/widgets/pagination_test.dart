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
  });
}
