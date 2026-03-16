import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  testWidgets('Example widgets render', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              WarcraftButton(onPressed: null, child: Text('Button')),
              WarcraftInput(hintText: 'Enter your name...'),
              WarcraftTextarea(hintText: 'Details'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Button'), findsOneWidget);
    expect(find.text('Enter your name...'), findsOneWidget);
  });
}
