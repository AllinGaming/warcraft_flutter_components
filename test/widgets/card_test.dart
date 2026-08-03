import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftCard', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftCard(child: Text('Card body')),
          ),
        ),
      );

      expect(find.text('Card body'), findsOneWidget);
    });

    testWidgets(
        'regression: no minHeight leaves the card sized to its content',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: WarcraftCard(child: Text('One line')),
            ),
          ),
        ),
      );

      final height = tester.getSize(find.byType(WarcraftCard)).height;
      expect(height, lessThan(200));
    });

    testWidgets('honors an explicit minHeight when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: WarcraftCard(minHeight: 300, child: Text('One line')),
            ),
          ),
        ),
      );

      final height = tester.getSize(find.byType(WarcraftCard)).height;
      expect(height, greaterThanOrEqualTo(300));
    });
  });

  group('WarcraftCard sections', () {
    testWidgets('WarcraftCardHeader renders inside a WarcraftCard',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftCard(
              child: WarcraftCardHeader(child: Text('Header text')),
            ),
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(WarcraftCard),
          matching: find.text('Header text'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('WarcraftCardContent renders inside a WarcraftCard',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftCard(
              child: WarcraftCardContent(child: Text('Content text')),
            ),
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(WarcraftCard),
          matching: find.text('Content text'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('WarcraftCardFooter renders inside a WarcraftCard',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftCard(
              child: WarcraftCardFooter(child: Text('Footer text')),
            ),
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(WarcraftCard),
          matching: find.text('Footer text'),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'WarcraftCardSection renders its child with the default padding',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftCard(
              child: WarcraftCardSection(child: Text('Section text')),
            ),
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(WarcraftCard),
          matching: find.text('Section text'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('WarcraftCard composes header, content and footer together',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WarcraftCardHeader(child: Text('Title')),
                  WarcraftCardContent(child: Text('Body')),
                  WarcraftCardFooter(child: Text('Footer')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);
    });
  });
}
