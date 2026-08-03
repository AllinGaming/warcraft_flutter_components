import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

void main() {
  group('WarcraftAvatar', () {
    testWidgets('renders its fallback content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftAvatar(fallback: Text('U')),
          ),
        ),
      );

      expect(find.text('U'), findsOneWidget);
    });

    testWidgets('sizes itself per WarcraftAvatarSize', (tester) async {
      for (final entry in const {
        WarcraftAvatarSize.sm: 96.0,
        WarcraftAvatarSize.md: 160.0,
        WarcraftAvatarSize.lg: 240.0,
      }.entries) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WarcraftAvatar(size: entry.key, fallback: const Text('U')),
            ),
          ),
        );

        final size = tester.getSize(find.byType(WarcraftAvatar));
        expect(size.width, entry.value);
        expect(size.height, entry.value);
      }
    });

    testWidgets('renders the provided image instead of the fallback',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WarcraftAvatar(
              image: AssetImage(
                WarcraftAssets.avatarDefault,
                package: 'warcraft_flutter_components',
              ),
              fallback: Text('U'),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Image), findsWidgets);
      expect(find.text('U'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders for every faction without throwing', (tester) async {
      for (final faction in WarcraftFaction.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WarcraftAvatar(faction: faction, fallback: const Text('U')),
            ),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
      }
    });
  });
}
