import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases [WarcraftAvatar] across every size x faction combination,
/// using [Widget]-based fallback initials since no bundled images ship
/// with the package.
class AvatarSection extends StatelessWidget {
  const AvatarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        for (final size in WarcraftAvatarSize.values)
          for (final faction in WarcraftFaction.values)
            WarcraftAvatar(
              size: size,
              faction: faction,
              fallback: Text(faction.name.substring(0, 1).toUpperCase()),
            ),
      ],
    );
  }
}
