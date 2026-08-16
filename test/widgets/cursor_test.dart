import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftCursor', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WarcraftCursor(child: Text('Hoverable area'))),
        ),
      );

      expect(find.text('Hoverable area'), findsOneWidget);
    });

    testWidgets('paints nothing before any hover event', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftCursor(child: SizedBox(width: 200, height: 200)),
          ),
        ),
      );

      expect(find.byType(Positioned), findsNothing);
    });

    testWidgets('paints the faction cursor once a mouse hovers', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftCursor(child: SizedBox(width: 200, height: 200)),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(WarcraftCursor)));
      await tester.pump();

      expect(find.byType(Positioned), findsOneWidget);
    });

    testWidgets('hides the cursor again once the mouse exits', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftCursor(child: SizedBox(width: 200, height: 200)),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(WarcraftCursor)));
      await tester.pump();
      expect(find.byType(Positioned), findsOneWidget);

      await gesture.moveTo(const Offset(2000, 2000));
      await tester.pump();

      expect(find.byType(Positioned), findsNothing);
    });

    testWidgets('uses a custom builder when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WarcraftCursor(
              builder: (context, faction) =>
                  const Icon(Icons.pets, key: Key('custom-cursor')),
              child: const SizedBox(width: 200, height: 200),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(WarcraftCursor)));
      await tester.pump();

      expect(find.byKey(const Key('custom-cursor')), findsOneWidget);
    });
  });
}
