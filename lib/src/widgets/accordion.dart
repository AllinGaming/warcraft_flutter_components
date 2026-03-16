import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';
import 'border_box.dart';

/// Icon variants for Warcraft accordion headers.
enum WarcraftAccordionIcon { sword, shield, runeStone }

/// Model for a single accordion item.
class WarcraftAccordionItem {
  WarcraftAccordionItem({
    required this.title,
    required this.content,
    this.icon = WarcraftAccordionIcon.sword,
    this.isExpanded = false,
  });

  final String title;
  final Widget content;
  final WarcraftAccordionIcon icon;
  bool isExpanded;
}

/// Warcraft-themed accordion with animated expand/collapse.
class WarcraftAccordion extends StatefulWidget {
  const WarcraftAccordion({
    super.key,
    required this.items,
  });

  final List<WarcraftAccordionItem> items;

  @override
  State<WarcraftAccordion> createState() => _WarcraftAccordionState();
}

class _WarcraftAccordionState extends State<WarcraftAccordion>
    with TickerProviderStateMixin {
  late List<bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.items.map((item) => item.isExpanded).toList();
  }

  @override
  void didUpdateWidget(covariant WarcraftAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _expanded = widget.items.map((item) => item.isExpanded).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.items.length, (index) {
        final item = widget.items[index];
        final isExpanded = _expanded[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _expanded[index] = !_expanded[index];
                    item.isExpanded = _expanded[index];
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
                fontSize: 14,
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
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      child: DefaultTextStyle.merge(
        style: WarcraftTheme.baseTextStyle(context).copyWith(
          color: WarcraftColors.cardForeground,
          fontSize: 13,
        ),
        child: content,
      ),
    );
  }
}
