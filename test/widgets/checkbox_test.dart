import 'dart:ui' show CheckedState;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftCheckbox', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftCheckbox(
              value: false,
              onChanged: (_) {},
              label: const Text('Accept quest'),
            ),
          ),
        ),
      );

      expect(find.text('Accept quest'), findsOneWidget);
    });

    testWidgets('tapping toggles the value via onChanged', (tester) async {
      bool? changedTo;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftCheckbox(
              value: false,
              onChanged: (next) => changedTo = next,
              label: const Text('Accept quest'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Accept quest'));
      await tester.pump();

      expect(changedTo, isTrue);
    });

    testWidgets('onChanged is optional and tapping is a no-op without it', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftCheckbox(value: false, label: Text('Accept quest')),
          ),
        ),
      );

      await tester.tap(find.byType(WarcraftCheckbox));
      await tester.pump();

      expect(find.byType(WarcraftCheckbox), findsOneWidget);
    });

    testWidgets('enabled: false prevents onChanged from firing', (
      tester,
    ) async {
      var callCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftCheckbox(
              value: false,
              enabled: false,
              onChanged: (_) => callCount++,
              label: const Text('Accept quest'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(WarcraftCheckbox));
      await tester.pump();

      expect(callCount, 0);
    });

    testWidgets('exposes checked/enabled semantics', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftCheckbox(
              value: true,
              onChanged: (_) {},
              label: const Text('Accept quest'),
            ),
          ),
        ),
      );

      final boundary = tester.getSemantics(
        find.bySemanticsLabel('Accept quest'),
      );
      final semantics = boundary
          .debugListChildrenInOrder(DebugSemanticsDumpOrder.traversalOrder)
          .single;
      expect(semantics.label, 'Accept quest');
      expect(semantics.flagsCollection.isChecked, CheckedState.isTrue);
      handle.dispose();
    });
  });
}
