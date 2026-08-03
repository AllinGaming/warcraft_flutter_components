import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftToast', () {
    testWidgets('shows a message and auto-dismisses after its duration',
        (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      WarcraftToast.show(
        capturedContext,
        message: 'Quest complete',
        duration: const Duration(milliseconds: 300),
      );
      // Bounded pumps rather than `pumpAndSettle`: with a short duration,
      // `pumpAndSettle` would fast-forward straight through the entrance,
      // the auto-dismiss timer, *and* the exit animation in one call,
      // leaving nothing to assert on in between.
      await tester.pump(); // mount the OverlayEntry
      await tester.pump(); // run the postFrameCallback that adds the toast
      await tester.pump(const Duration(milliseconds: 200)); // entrance settled

      expect(find.text('Quest complete'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 300)); // duration elapses
      await tester.pump(const Duration(milliseconds: 200)); // exit settled

      expect(find.text('Quest complete'), findsNothing);
    });

    testWidgets('tapping a toast dismisses it immediately', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      WarcraftToast.show(
        capturedContext,
        message: 'Tap to dismiss',
        duration: const Duration(seconds: 30),
      );
      await tester.pumpAndSettle();
      expect(find.text('Tap to dismiss'), findsOneWidget);

      await tester.tap(find.text('Tap to dismiss'));
      await tester.pumpAndSettle();

      expect(find.text('Tap to dismiss'), findsNothing);
    });

    testWidgets('stacks multiple toasts at the same position', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      WarcraftToast.show(capturedContext,
          message: 'First', duration: const Duration(seconds: 30));
      await tester.pumpAndSettle();
      WarcraftToast.show(capturedContext,
          message: 'Second', duration: const Duration(seconds: 30));
      await tester.pumpAndSettle();

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
    });

    testWidgets('renders for every type without throwing', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      for (final type in WarcraftToastType.values) {
        WarcraftToast.show(
          capturedContext,
          message: 'Message for $type',
          type: type,
          duration: const Duration(seconds: 30),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('renders for every faction without throwing', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      for (final faction in WarcraftFaction.values) {
        WarcraftToast.show(
          capturedContext,
          message: 'Message for $faction',
          faction: faction,
          duration: const Duration(seconds: 30),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  });
}
