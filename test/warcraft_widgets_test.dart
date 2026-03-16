import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  testWidgets('renders core widgets', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                WarcraftButton(child: Text('Button')),
                WarcraftBadge(child: Text('Badge')),
                WarcraftCard(child: Text('Card')),
                WarcraftLabel(text: 'Label', required: true),
                WarcraftInput(hintText: 'Input'),
                WarcraftTextarea(hintText: 'Textarea'),
                WarcraftSpinner(),
                WarcraftSkeleton(width: 120, height: 16),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Button'), findsOneWidget);
    expect(find.text('Badge'), findsOneWidget);
    expect(find.text('Card'), findsOneWidget);
    expect(find.text('Label'), findsOneWidget);
  });

  testWidgets('checkbox toggles', (tester) async {
    var value = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WarcraftCheckbox(
            value: value,
            onChanged: (next) => value = next,
            label: const Text('Check'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Check'));
    expect(value, isTrue);
  });
}
