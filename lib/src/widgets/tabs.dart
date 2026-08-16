import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../assets/warcraft_assets.dart';
import '../foundation/warcraft_faction.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';
import 'border_box.dart';

/// Warcraft-themed tabs with faction styling.
class WarcraftTabs extends StatefulWidget {
  /// Creates a [WarcraftTabs]. [labels] and [contents] must be the same
  /// length, since each label corresponds to the content shown when it's
  /// selected.
  const WarcraftTabs({
    super.key,
    required this.labels,
    required this.contents,
    this.faction = WarcraftFaction.defaultFaction,
    this.initialIndex = 0,
    this.selectedIndex,
    this.orientation = Axis.horizontal,
    this.onChanged,
    this.autofocus = false,
  }) : assert(labels.length > 0, 'at least one tab is required'),
       assert(
         labels.length == contents.length,
         'labels and contents must match',
       ),
       assert(
         initialIndex >= 0 && initialIndex < labels.length,
         'initialIndex must identify an existing tab',
       ),
       assert(
         selectedIndex == null ||
             (selectedIndex >= 0 && selectedIndex < labels.length),
         'selectedIndex must identify an existing tab',
       );

  /// The text shown on each tab trigger, in display order.
  final List<String> labels;

  /// The content panel shown for each tab, matched by index to [labels].
  final List<Widget> contents;

  /// Which faction's assets and colors to use for the tab triggers and
  /// content panel.
  final WarcraftFaction faction;

  /// The index of the tab selected when the widget is first built.
  final int initialIndex;

  /// Controlled selected index. When set, taps only invoke [onChanged]; the
  /// parent must rebuild with a new value to change the visible tab.
  final int? selectedIndex;

  /// Whether the tab triggers are laid out in a horizontal row (with the
  /// content below) or a vertical column (with the content beside them).
  final Axis orientation;

  /// Called with the newly selected index whenever the user picks a
  /// different tab.
  final ValueChanged<int>? onChanged;

  /// Whether the initially selected trigger should claim keyboard focus.
  final bool autofocus;

  @override
  State<WarcraftTabs> createState() => _WarcraftTabsState();
}

class _WarcraftTabsState extends State<WarcraftTabs> {
  late int _index;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _focusNodes = List.generate(
      widget.labels.length,
      (index) => FocusNode(debugLabel: 'Warcraft tab ${widget.labels[index]}'),
    );
  }

  @override
  void didUpdateWidget(covariant WarcraftTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.labels.length > _focusNodes.length) {
      _focusNodes.addAll(
        List.generate(widget.labels.length - _focusNodes.length, (offset) {
          final index = _focusNodes.length + offset;
          return FocusNode(debugLabel: 'Warcraft tab ${widget.labels[index]}');
        }),
      );
    } else if (widget.labels.length < _focusNodes.length) {
      final removed = _focusNodes.sublist(widget.labels.length);
      _focusNodes = _focusNodes.sublist(0, widget.labels.length);
      for (final node in removed) {
        node.dispose();
      }
    }
    if (widget.selectedIndex == null) {
      if (oldWidget.selectedIndex != null) {
        _index = oldWidget.selectedIndex!.clamp(0, widget.labels.length - 1);
      } else if (_index >= widget.labels.length) {
        _index = widget.labels.length - 1;
      }
    }
  }

  int get _effectiveIndex => widget.selectedIndex ?? _index;

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _select(int index, {bool requestFocus = false}) {
    if (requestFocus) _focusNodes[index].requestFocus();
    if (index == _effectiveIndex) return;
    if (widget.selectedIndex == null) {
      setState(() => _index = index);
    }
    widget.onChanged?.call(index);
  }

  void _moveSelection(int delta) {
    final next = (_effectiveIndex + delta) % widget.labels.length;
    _select(next, requestFocus: true);
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
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final children = List.generate(widget.labels.length, (i) {
      final selected = i == _effectiveIndex;
      return Padding(
        padding: const EdgeInsets.only(right: 6, bottom: 6),
        child: _TabTrigger(
          label: widget.labels[i],
          selected: selected,
          faction: widget.faction,
          onTap: () => _select(i),
          orientation: widget.orientation,
          focusNode: _focusNodes[i],
          autofocus: widget.autofocus && selected,
          onPrevious: () => _moveSelection(
            widget.orientation == Axis.horizontal && rtl ? 1 : -1,
          ),
          onNext: () => _moveSelection(
            widget.orientation == Axis.horizontal && rtl ? -1 : 1,
          ),
          onFirst: () => _select(0, requestFocus: true),
          onLast: () => _select(widget.labels.length - 1, requestFocus: true),
        ),
      );
    });

    return SingleChildScrollView(
      scrollDirection: widget.orientation == Axis.vertical
          ? Axis.vertical
          : Axis.horizontal,
      child: widget.orientation == Axis.vertical
          ? Column(children: children)
          : Row(children: children),
    );
  }

  Widget _buildContent(BuildContext context) {
    final contentAsset = _contentAsset(widget.faction);
    // No maxHeight cap: taller panel content scrolls instead of being
    // silently clipped by WarcraftBorderBox's ClipRRect.
    //
    // minHeight only needs to cover the frame's own 48px top/bottom cap
    // (see sliceInsets below) so the carved corners always render at full
    // size instead of Skia proportionally shrinking them to fit a shorter
    // panel — it's deliberately not a bigger, made-up "looks nice" number,
    // which is what left short demo content stranded in a mostly-empty box.
    final index = _effectiveIndex;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48 * 2),
      child: WarcraftBorderBox(
        asset: contentAsset,
        sliceInsets: const EdgeInsets.all(48),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: AnimatedSwitcher(
            duration: WarcraftTheme.motionDurationOf(context),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: DefaultTextStyle.merge(
              key: ValueKey(index),
              style: WarcraftTheme.baseTextStyle(context).copyWith(
                color: WarcraftTheme.of(context).foreground,
                fontSize: WarcraftTokens.typeBase,
              ),
              child: widget.contents[index],
            ),
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
    required this.focusNode,
    required this.autofocus,
    required this.onPrevious,
    required this.onNext,
    required this.onFirst,
    required this.onLast,
  });

  final String label;
  final bool selected;
  final WarcraftFaction faction;
  final VoidCallback onTap;
  final Axis orientation;
  final FocusNode focusNode;
  final bool autofocus;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onFirst;
  final VoidCallback onLast;

  @override
  Widget build(BuildContext context) {
    final asset = selected ? _activeAsset(faction) : _inactiveAsset(faction);

    final theme = WarcraftTheme.of(context);
    final previousKey = orientation == Axis.horizontal
        ? LogicalKeyboardKey.arrowLeft
        : LogicalKeyboardKey.arrowUp;
    final nextKey = orientation == Axis.horizontal
        ? LogicalKeyboardKey.arrowRight
        : LogicalKeyboardKey.arrowDown;

    return CallbackShortcuts(
      bindings: {
        SingleActivator(previousKey): onPrevious,
        SingleActivator(nextKey): onNext,
        const SingleActivator(LogicalKeyboardKey.home): onFirst,
        const SingleActivator(LogicalKeyboardKey.end): onLast,
      },
      child: Semantics(
        button: true,
        selected: selected,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            focusNode: focusNode,
            autofocus: autofocus,
            onTap: onTap,
            borderRadius: BorderRadius.circular(theme.radius),
            focusColor: theme.focusRing.withAlpha(55),
            hoverColor: theme.primary.withAlpha(28),
            mouseCursor: SystemMouseCursors.click,
            child: Container(
              constraints: BoxConstraints(
                minWidth: orientation == Axis.vertical ? 180 : 140,
                minHeight: WarcraftTokens.minTapTarget,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    asset,
                    package: 'warcraft_flutter_components',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: WarcraftTheme.baseTextStyle(context).copyWith(
                  color:
                      faction == WarcraftFaction.elf ||
                          faction == WarcraftFaction.undead
                      ? Colors.black
                      : Colors.white,
                  fontSize: WarcraftTokens.typeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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
