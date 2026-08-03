import 'package:flutter_test/flutter_test.dart';

import 'package:warcraft_flutter_components_example/main.dart';

void main() {
  testWidgets('Example app renders every showcase section', (tester) async {
    await tester.pumpWidget(const WarcraftExampleApp());
    // Several sections (spinner, skeleton shimmer) run repeating animations
    // that never settle, so pump a bounded number of frames instead of
    // pumpAndSettle (which would time out waiting for them to stop).
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Warcraft UI Components'), findsOneWidget);
    expect(find.text('Buttons'), findsOneWidget);
    expect(find.text('Toast'), findsOneWidget);
    expect(find.text('Cursor'), findsOneWidget);
  });
}
