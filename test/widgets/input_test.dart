import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftInput', () {
    testWidgets('renders its hint text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WarcraftInput(hintText: 'Enter name')),
        ),
      );

      expect(find.text('Enter name'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('entering text calls onChanged and updates the field', (
      tester,
    ) async {
      String? lastValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftInput(
              hintText: 'Enter name',
              onChanged: (value) => lastValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Thrall');
      await tester.pump();

      expect(lastValue, 'Thrall');
      expect(find.text('Thrall'), findsOneWidget);
    });

    testWidgets('a controller reflects entered text', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: WarcraftInput(controller: controller)),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Jaina');
      await tester.pump();

      expect(controller.text, 'Jaina');
    });

    testWidgets('disabled input does not accept focus for editing', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftInput(hintText: 'Enter name', enabled: false),
          ),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isFalse);
    });

    testWidgets('maxWidth constrains the rendered width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: WarcraftInput(hintText: 'Enter name', maxWidth: 200),
            ),
          ),
        ),
      );

      final width = tester.getSize(find.byType(WarcraftInput)).width;
      expect(width, lessThanOrEqualTo(200));
    });

    testWidgets('renders helper and error messages', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                WarcraftInput(helperText: 'Choose a public name'),
                WarcraftInput(errorText: 'Name is already taken'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Choose a public name'), findsOneWidget);
      expect(find.text('Name is already taken'), findsOneWidget);
    });

    testWidgets('supports focus, icons, and submission', (tester) async {
      var submitted = '';
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: WarcraftTheme.themeData(),
          home: Scaffold(
            body: WarcraftInput(
              focusNode: focusNode,
              prefixIcon: const Icon(Icons.person),
              onSubmitted: (value) => submitted = value,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
      focusNode.requestFocus();
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'Thrall');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(submitted, 'Thrall');
    });

    testWidgets('forwards production text-entry configuration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftInput(
              maxLength: 12,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.username],
              inputFormatters: [FilteringTextInputFormatter.deny(' ')],
              textAlign: TextAlign.center,
              enableSuggestions: false,
              autocorrect: false,
            ),
          ),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.maxLength, 12);
      expect(field.textCapitalization, TextCapitalization.words);
      expect(field.autofillHints, contains(AutofillHints.username));
      expect(field.inputFormatters, hasLength(1));
      expect(field.textAlign, TextAlign.center);
      expect(field.enableSuggestions, isFalse);
      expect(field.autocorrect, isFalse);
    });
  });
}
