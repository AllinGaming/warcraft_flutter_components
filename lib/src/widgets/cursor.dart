import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../assets/warcraft_assets.dart';
import '../foundation/warcraft_faction.dart';
import '../theme/warcraft_theme.dart';

/// Wraps [child] and paints a faction-tinted hero cursor that follows the
/// mouse pointer, replacing the system cursor while hovering.
///
/// This has no effect on touch-only input: [MouseRegion]'s hover callbacks
/// only ever fire for a real mouse pointer, so on touch devices nothing is
/// painted and the platform's default touch behavior is left untouched — no
/// platform detection is required.
class WarcraftCursor extends StatefulWidget {
  const WarcraftCursor({
    super.key,
    required this.child,
    this.faction = WarcraftFaction.defaultFaction,
    this.size = 32,
    this.builder,
  });

  final Widget child;
  final WarcraftFaction faction;
  final double size;

  /// Escape hatch for supplying custom hero-cursor art instead of the
  /// bundled default sword glyph.
  final Widget Function(BuildContext context, WarcraftFaction faction)? builder;

  @override
  State<WarcraftCursor> createState() => _WarcraftCursorState();
}

class _WarcraftCursorState extends State<WarcraftCursor> {
  Offset? _pointer;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onHover: (event) => setState(() => _pointer = event.localPosition),
      onExit: (_) => setState(() => _pointer = null),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (_pointer != null)
            Positioned(
              left: _pointer!.dx - (widget.size * 0.15),
              top: _pointer!.dy - (widget.size * 0.1),
              child: IgnorePointer(
                child: widget.builder != null
                    ? widget.builder!(context, widget.faction)
                    : _defaultCursor(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _defaultCursor() {
    return SvgPicture.asset(
      WarcraftAssets.svgSword,
      package: 'warcraft_flutter_components',
      width: widget.size,
      height: widget.size,
      colorFilter: ColorFilter.mode(_factionColor(widget.faction), BlendMode.srcIn),
    );
  }

  Color _factionColor(WarcraftFaction faction) {
    switch (faction) {
      case WarcraftFaction.orc:
        return WarcraftColors.orcRed;
      case WarcraftFaction.elf:
        return WarcraftColors.elfGreen;
      case WarcraftFaction.human:
        return WarcraftColors.humanBlue;
      case WarcraftFaction.undead:
        return WarcraftColors.undeadPurple;
      case WarcraftFaction.defaultFaction:
        return WarcraftColors.amber400;
    }
  }
}
