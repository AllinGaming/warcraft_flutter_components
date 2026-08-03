import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftTheme.textTheme', () {
    testWidgets('applies the bundled font family to every text style',
        (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final themed = WarcraftTheme.textTheme(capturedContext);

      expect(themed.bodyMedium?.fontFamily, WarcraftTheme.fontFamily);
      expect(themed.titleLarge?.fontFamily, WarcraftTheme.fontFamily);
      expect(themed.labelSmall?.fontFamily, WarcraftTheme.fontFamily);
    });
  });
}
