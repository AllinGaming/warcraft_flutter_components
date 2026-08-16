import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftSpinner', () {
    testWidgets('renders at its requested size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WarcraftSpinner(size: 64))),
      );

      final size = tester.getSize(find.byType(WarcraftSpinner));
      expect(size, const Size(64, 64));
    });

    testWidgets('exposes a loading semantic label', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WarcraftSpinner())),
      );

      expect(find.bySemanticsLabel('Loading'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('animates without throwing across several frames', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WarcraftSpinner())),
      );

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.takeException(), isNull);
    });

    testWidgets('pauses when reduced motion is requested', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(body: WarcraftSpinner()),
          ),
        ),
      );

      final spinnerTransform = find.descendant(
        of: find.byType(WarcraftSpinner),
        matching: find.byType(Transform),
      );
      List<double> transform() =>
          tester.widget<Transform>(spinnerTransform).transform.storage;

      final before = List<double>.of(transform());
      await tester.pump(const Duration(milliseconds: 600));
      expect(transform(), before);
    });
  });
}
