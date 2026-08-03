import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftButton', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftButton(
              onPressed: () {},
              child: const Text('Attack'),
            ),
          ),
        ),
      );

      expect(find.text('Attack'), findsOneWidget);
      expect(find.byType(WarcraftButton), findsOneWidget);
    });

    testWidgets('invokes onPressed when tapped', (tester) async {
      var pressed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftButton(
              onPressed: () => pressed++,
              child: const Text('Attack'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(WarcraftButton));
      await tester.pump();
      expect(pressed, 1);
    });

    testWidgets('does not invoke onPressed when disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftButton(
              child: const Text('Attack'),
            ),
          ),
        ),
      );

      expect(find.byType(WarcraftButton), findsOneWidget);
      await tester.tap(find.byType(WarcraftButton));
      await tester.pump();
    });

    testWidgets('enabled getter reflects onPressed', (tester) async {
      const withCallback = WarcraftButton(onPressed: _noop, child: Text('A'));
      const withoutCallback = WarcraftButton(child: Text('A'));
      expect(withCallback.enabled, isTrue);
      expect(withoutCallback.enabled, isFalse);
    });

    testWidgets('enforces a minimum 48x48 tap target', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftButton(
              size: WarcraftButtonSize.sm,
              onPressed: () {},
              child: const Text('X'),
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(WarcraftButton));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
    });

    testWidgets('Enter key triggers onPressed when focused', (tester) async {
      var pressed = 0;
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftButton(
              focusNode: focusNode,
              onPressed: () => pressed++,
              child: const Text('Attack'),
            ),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(pressed, 1);
    });
  });
}

void _noop() {}
