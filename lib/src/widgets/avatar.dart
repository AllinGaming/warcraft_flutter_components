import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../foundation/warcraft_faction.dart';
import '../theme/warcraft_theme.dart';

/// Size presets for Warcraft avatars.
enum WarcraftAvatarSize { sm, md, lg }

/// Warcraft-styled avatar with faction frame and optional image.
class WarcraftAvatar extends StatelessWidget {
  const WarcraftAvatar({
    super.key,
    this.image,
    this.fallback,
    this.faction = WarcraftFaction.defaultFaction,
    this.size = WarcraftAvatarSize.md,
  });

  final ImageProvider? image;
  final Widget? fallback;
  final WarcraftFaction faction;
  final WarcraftAvatarSize size;

  @override
  Widget build(BuildContext context) {
    final dimension = _sizePx(size);

    return SizedBox(
      width: dimension,
      height: dimension,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.all(dimension * 0.2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(dimension * 0.08),
              child: image != null
                  ? Image(image: image!, fit: BoxFit.cover)
                  : Container(
                      color: const Color(0xFF1F2937),
                      alignment: Alignment.center,
                      child: DefaultTextStyle.merge(
                        style: WarcraftTheme.baseTextStyle(context).copyWith(
                          color: WarcraftColors.amber200,
                          fontSize: dimension * 0.2,
                        ),
                        child: fallback ?? const SizedBox.shrink(),
                      ),
                    ),
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              _frameAsset(faction),
              fit: BoxFit.contain,
              package: 'warcraft_flutter_components',
            ),
          ),
        ],
      ),
    );
  }

  double _sizePx(WarcraftAvatarSize size) {
    switch (size) {
      case WarcraftAvatarSize.sm:
        return 96;
      case WarcraftAvatarSize.md:
        return 160;
      case WarcraftAvatarSize.lg:
        return 240;
    }
  }

  String _frameAsset(WarcraftFaction faction) {
    switch (faction) {
      case WarcraftFaction.orc:
        return WarcraftAssets.avatarOrc;
      case WarcraftFaction.elf:
        return WarcraftAssets.avatarElf;
      case WarcraftFaction.human:
        return WarcraftAssets.avatarHuman;
      case WarcraftFaction.undead:
        return WarcraftAssets.avatarUndead;
      case WarcraftFaction.defaultFaction:
        return WarcraftAssets.avatarDefault;
    }
  }
}
