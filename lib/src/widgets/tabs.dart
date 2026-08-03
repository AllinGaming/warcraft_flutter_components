import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../foundation/warcraft_faction.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';
import 'border_box.dart';

/// Warcraft-themed tabs with faction styling.
class WarcraftTabs extends StatefulWidget {
  const WarcraftTabs({
    super.key,
    required this.labels,
    required this.contents,
    this.faction = WarcraftFaction.defaultFaction,
    this.initialIndex = 0,
    this.orientation = Axis.horizontal,
    this.onChanged,
  }) : assert(
            labels.length == contents.length, 'labels and contents must match');

  final List<String> labels;
  final List<Widget> contents;
  final WarcraftFaction faction;
  final int initialIndex;
  final Axis orientation;
  final ValueChanged<int>? onChanged;

  @override
  State<WarcraftTabs> createState() => _WarcraftTabsState();
}

class _WarcraftTabsState extends State<WarcraftTabs> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.labels.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final tabList = _buildTabList(context);
    final content = _buildContent(context);

    if (widget.orientation == Axis.vertical) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tabList,
          const SizedBox(width: WarcraftTokens.spacingMd),
          Expanded(child: content),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        tabList,
        const SizedBox(height: WarcraftTokens.spacingSm),
        content,
      ],
    );
  }

  Widget _buildTabList(BuildContext context) {
    final children = List.generate(widget.labels.length, (i) {
      final selected = i == _index;
      return Padding(
        padding: const EdgeInsets.only(right: 6, bottom: 6),
        child: _TabTrigger(
          label: widget.labels[i],
          selected: selected,
          faction: widget.faction,
          onTap: () {
            setState(() => _index = i);
            widget.onChanged?.call(i);
          },
          orientation: widget.orientation,
        ),
      );
    });

    return SingleChildScrollView(
      scrollDirection:
          widget.orientation == Axis.vertical ? Axis.vertical : Axis.horizontal,
      child: widget.orientation == Axis.vertical
          ? Column(children: children)
          : Row(children: children),
    );
  }

  Widget _buildContent(BuildContext context) {
    final contentAsset = _contentAsset(widget.faction);
    // No maxHeight cap: taller panel content scrolls instead of being
    // silently clipped by WarcraftBorderBox's ClipRRect.
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 160),
      child: WarcraftBorderBox(
        asset: contentAsset,
        sliceInsets: const EdgeInsets.all(48),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: DefaultTextStyle.merge(
            style: WarcraftTheme.baseTextStyle(context).copyWith(
              color: WarcraftColors.cardForeground,
              fontSize: WarcraftTokens.typeBase,
            ),
            child: widget.contents[_index],
          ),
        ),
      ),
    );
  }

  String _contentAsset(WarcraftFaction faction) {
    switch (faction) {
      case WarcraftFaction.human:
        return WarcraftAssets.tabContentHuman;
      case WarcraftFaction.orc:
        return WarcraftAssets.tabContentOrc;
      case WarcraftFaction.elf:
        return WarcraftAssets.tabContentElf;
      case WarcraftFaction.undead:
        return WarcraftAssets.tabContentUndead;
      case WarcraftFaction.defaultFaction:
        return WarcraftAssets.tabContent;
    }
  }
}

class _TabTrigger extends StatelessWidget {
  const _TabTrigger({
    required this.label,
    required this.selected,
    required this.faction,
    required this.onTap,
    required this.orientation,
  });

  final String label;
  final bool selected;
  final WarcraftFaction faction;
  final VoidCallback onTap;
  final Axis orientation;

  @override
  Widget build(BuildContext context) {
    final asset = selected ? _activeAsset(faction) : _inactiveAsset(faction);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minWidth: orientation == Axis.vertical ? 180 : 140,
          minHeight: WarcraftTokens.minTapTarget,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(asset, package: 'warcraft_flutter_components'),
            fit: BoxFit.fill,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: WarcraftTheme.baseTextStyle(context).copyWith(
            color: faction == WarcraftFaction.elf ||
                    faction == WarcraftFaction.undead
                ? Colors.black
                : Colors.white,
            fontSize: WarcraftTokens.typeMd,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _inactiveAsset(WarcraftFaction faction) {
    switch (faction) {
      case WarcraftFaction.human:
        return WarcraftAssets.tabListHuman;
      case WarcraftFaction.orc:
        return WarcraftAssets.tabListOrc;
      case WarcraftFaction.elf:
        return WarcraftAssets.tabListElf;
      case WarcraftFaction.undead:
        return WarcraftAssets.tabListUndead;
      case WarcraftFaction.defaultFaction:
        return WarcraftAssets.tabList;
    }
  }

  String _activeAsset(WarcraftFaction faction) {
    switch (faction) {
      case WarcraftFaction.human:
        return WarcraftAssets.tabListActiveHuman;
      case WarcraftFaction.orc:
        return WarcraftAssets.tabListActiveOrc;
      case WarcraftFaction.elf:
        return WarcraftAssets.tabListActiveElf;
      case WarcraftFaction.undead:
        return WarcraftAssets.tabListActiveUndead;
      case WarcraftFaction.defaultFaction:
        return WarcraftAssets.tabListActive;
    }
  }
}
