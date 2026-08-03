import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';
import 'border_box.dart';

/// Icon variants for Warcraft accordion headers.
enum WarcraftAccordionIcon {
  /// A crossed-swords icon.
  sword,

  /// A shield icon.
  shield,

  /// A rune stone icon.
  runeStone
}

/// Model for a single accordion item.
class WarcraftAccordionItem {
  /// Creates a [WarcraftAccordionItem].
  WarcraftAccordionItem({
    required this.title,
    required this.content,
    this.icon = WarcraftAccordionIcon.sword,
    this.isExpanded = false,
  });

  /// The text shown in the item's header.
  final String title;

  /// The widget shown in the item's body when it is expanded.
  final Widget content;

  /// The icon shown in the item's header.
  final WarcraftAccordionIcon icon;

  /// The item's initial expand state. Only read once, when the enclosing
  /// [WarcraftAccordion] first mounts (or when its `items` list is swapped
  /// for a different one) — expand/collapse thereafter is tracked purely as
  /// UI state inside [WarcraftAccordion], not written back here.
  final bool isExpanded;
}

/// Warcraft-themed accordion with animated expand/collapse.
class WarcraftAccordion extends StatefulWidget {
  /// Creates a [WarcraftAccordion].
  const WarcraftAccordion({
    super.key,
    required this.items,
  });

  /// The items rendered as expandable sections, in order.
  final List<WarcraftAccordionItem> items;

  @override
  State<WarcraftAccordion> createState() => _WarcraftAccordionState();
}

class _WarcraftAccordionState extends State<WarcraftAccordion> {
  late List<bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.items.map((item) => item.isExpanded).toList();
  }

  @override
  void didUpdateWidget(covariant WarcraftAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Compare by element identity (not just list length) so swapping in a
    // same-length-but-different set of items correctly resets expand state,
    // while an unrelated rebuild that passes the same item instances back
    // preserves whatever the user has toggled.
    if (!listEquals(oldWidget.items, widget.items)) {
      _expanded = widget.items.map((item) => item.isExpanded).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(widget.items.length, (index) {
        final item = widget.items[index];
        final isExpanded = _expanded[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: WarcraftTokens.spacingSm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _expanded[index] = !_expanded[index];
                  });
                },
                child: _Header(item: item, isExpanded: isExpanded),
              ),
              ClipRect(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  child: isExpanded
                      ? _Body(content: item.content)
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.item, required this.isExpanded});

  final WarcraftAccordionItem item;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return WarcraftBorderBox(
      asset: WarcraftAssets.accordionHeader,
      sliceInsets: const EdgeInsets.all(6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.title,
              style: WarcraftTheme.baseTextStyle(context).copyWith(
                color: Colors.white,
                fontSize: WarcraftTokens.typeLg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          AnimatedRotation(
            turns: isExpanded ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 220),
            child: SvgPicture.asset(
              _iconAsset(item.icon),
              width: 16,
              height: 16,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              package: 'warcraft_flutter_components',
            ),
          ),
        ],
      ),
    );
  }

  String _iconAsset(WarcraftAccordionIcon icon) {
    switch (icon) {
      case WarcraftAccordionIcon.shield:
        return WarcraftAssets.svgShield;
      case WarcraftAccordionIcon.runeStone:
        return WarcraftAssets.svgRuneStone;
      case WarcraftAccordionIcon.sword:
        return WarcraftAssets.svgSword;
    }
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return WarcraftBorderBox(
      asset: WarcraftAssets.accordionContentBg,
      sliceInsets: const EdgeInsets.all(6),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: DefaultTextStyle.merge(
        style: WarcraftTheme.baseTextStyle(context).copyWith(
          color: WarcraftColors.cardForeground,
          fontSize: WarcraftTokens.typeBase,
        ),
        child: content,
      ),
    );
  }
}
