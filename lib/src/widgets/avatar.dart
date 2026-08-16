import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../foundation/warcraft_faction.dart';
import '../theme/warcraft_theme.dart';

/// Size presets for Warcraft avatars.
enum WarcraftAvatarSize {
  /// Small avatar (96x96 logical pixels).
  sm,

  /// Medium avatar (160x160 logical pixels).
  md,

  /// Large avatar (240x240 logical pixels).
  lg,
}

/// Warcraft-styled avatar with faction frame and optional image.
class WarcraftAvatar extends StatelessWidget {
  /// Creates a [WarcraftAvatar].
  const WarcraftAvatar({
    super.key,
    this.image,
    this.fallback,
    this.faction = WarcraftFaction.defaultFaction,
    this.size = WarcraftAvatarSize.md,
    this.semanticLabel,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// The image shown inside the frame. When `null`, [fallback] is shown
  /// instead.
  final ImageProvider? image;

  /// Widget shown in place of [image] when no image is provided.
  final Widget? fallback;

  /// The faction whose decorative frame is drawn around the avatar.
  final WarcraftFaction faction;

  /// The overall size of the avatar.
  final WarcraftAvatarSize size;

  /// Accessible description of the represented character or profile.
  final String? semanticLabel;

  /// Background behind [fallback]. Defaults to the themed elevated surface.
  final Color? backgroundColor;

  /// Content color inherited by [fallback]. Defaults to the theme accent.
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    final dimension = _sizePx(size);

    final fallbackContent = Container(
      color: backgroundColor ?? theme.surfaceElevated,
      alignment: Alignment.center,
      child: DefaultTextStyle.merge(
        style: WarcraftTheme.baseTextStyle(context).copyWith(
          color: foregroundColor ?? theme.primary,
          fontSize: dimension * 0.2,
          fontWeight: FontWeight.w600,
        ),
        child: fallback ?? const SizedBox.shrink(),
      ),
    );

    return Semantics(
      image: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        excluding: semanticLabel != null,
        child: SizedBox(
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
                      ? Image(
                          image: image!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => fallbackContent,
                        )
                      : fallbackContent,
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
        ),
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
