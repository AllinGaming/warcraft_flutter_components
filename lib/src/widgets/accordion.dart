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
  runeStone,
}

/// Reports an accordion item expansion request.
typedef WarcraftAccordionChanged = void Function(int index, bool expanded);

/// Model for a single accordion item.
class WarcraftAccordionItem {
  /// Creates a [WarcraftAccordionItem].
  const WarcraftAccordionItem({
    required this.title,
    required this.content,
    this.icon = WarcraftAccordionIcon.sword,
    this.isExpanded = false,
    this.semanticLabel,
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

  /// Optional accessible replacement for [title].
  final String? semanticLabel;
}

/// Warcraft-themed accordion with animated expand/collapse.
class WarcraftAccordion extends StatefulWidget {
  /// Creates a [WarcraftAccordion].
  const WarcraftAccordion({
    super.key,
    required this.items,
    this.allowMultiple = true,
    this.onChanged,
    this.expandedIndexes,
  });

  /// The items rendered as expandable sections, in order.
  final List<WarcraftAccordionItem> items;

  /// Whether more than one item may be expanded simultaneously.
  final bool allowMultiple;

  /// Called after an item changes, with its index and new expanded state.
  final WarcraftAccordionChanged? onChanged;

  /// Controlled set of expanded item indexes. When provided, the accordion
  /// does not mutate its internal expansion state; [onChanged] reports the
  /// requested change and the parent must rebuild with a new set.
  final Set<int>? expandedIndexes;

  @override
  State<WarcraftAccordion> createState() => _WarcraftAccordionState();
}

class _WarcraftAccordionState extends State<WarcraftAccordion> {
  late List<bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = _initialExpansion();
  }

  @override
  void didUpdateWidget(covariant WarcraftAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Compare by element identity (not just list length) so swapping in a
    // same-length-but-different set of items correctly resets expand state,
    // while an unrelated rebuild that passes the same item instances back
    // preserves whatever the user has toggled.
    if (widget.expandedIndexes == null && oldWidget.expandedIndexes != null) {
      _expanded = List.generate(
        widget.items.length,
        (index) => oldWidget.expandedIndexes!.contains(index),
      );
      _normalizeSingleOpen();
    } else if (widget.expandedIndexes == null &&
        !listEquals(oldWidget.items, widget.items)) {
      _expanded = _initialExpansion();
    } else if (widget.expandedIndexes == null &&
        oldWidget.allowMultiple &&
        !widget.allowMultiple) {
      _normalizeSingleOpen();
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.expandedIndexes == null ||
          widget.expandedIndexes!.every(
            (index) => index >= 0 && index < widget.items.length,
          ),
      'expandedIndexes must only contain existing item indexes',
    );
    assert(
      widget.allowMultiple ||
          widget.expandedIndexes == null ||
          widget.expandedIndexes!.length <= 1,
      'expandedIndexes can contain at most one index when allowMultiple is false',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(widget.items.length, (index) {
        final item = widget.items[index];
        final isExpanded =
            widget.expandedIndexes?.contains(index) ?? _expanded[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: WarcraftTokens.spacingSm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MergeSemantics(
                child: Semantics(
                  container: true,
                  button: true,
                  expanded: isExpanded,
                  label: item.semanticLabel,
                  excludeSemantics: item.semanticLabel != null,
                  onTap: () => _toggle(index),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _toggle(index),
                      excludeFromSemantics: true,
                      focusColor: WarcraftTheme.of(
                        context,
                      ).focusRing.withAlpha(55),
                      hoverColor: WarcraftTheme.of(
                        context,
                      ).primary.withAlpha(28),
                      mouseCursor: SystemMouseCursors.click,
                      child: _Header(item: item, isExpanded: isExpanded),
                    ),
                  ),
                ),
              ),
              ClipRect(
                child: AnimatedSize(
                  duration: WarcraftTheme.motionDurationOf(context),
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

  void _toggle(int index) {
    final current = widget.expandedIndexes?.contains(index) ?? _expanded[index];
    final next = !current;
    if (widget.expandedIndexes != null) {
      widget.onChanged?.call(index, next);
      return;
    }
    setState(() {
      if (next && !widget.allowMultiple) {
        for (var itemIndex = 0; itemIndex < _expanded.length; itemIndex++) {
          _expanded[itemIndex] = false;
        }
      }
      _expanded[index] = next;
    });
    widget.onChanged?.call(index, next);
  }

  List<bool> _initialExpansion() {
    final result = widget.items.map((item) => item.isExpanded).toList();
    if (!widget.allowMultiple) {
      var foundExpanded = false;
      for (var index = 0; index < result.length; index++) {
        if (!result[index]) continue;
        if (foundExpanded) result[index] = false;
        foundExpanded = true;
      }
    }
    return result;
  }

  void _normalizeSingleOpen() {
    if (widget.allowMultiple) return;
    var foundExpanded = false;
    for (var index = 0; index < _expanded.length; index++) {
      if (!_expanded[index]) continue;
      if (foundExpanded) _expanded[index] = false;
      foundExpanded = true;
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.item, required this.isExpanded});

  final WarcraftAccordionItem item;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
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
                color: theme.foreground,
                fontSize: WarcraftTokens.typeLg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          AnimatedRotation(
            turns: isExpanded ? 0.5 : 0.0,
            duration: WarcraftTheme.motionDurationOf(context),
            child: SvgPicture.asset(
              _iconAsset(item.icon),
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(theme.foreground, BlendMode.srcIn),
              package: 'warcraft_flutter_components',
              excludeFromSemantics: true,
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
          color: WarcraftTheme.of(context).foreground,
          fontSize: WarcraftTokens.typeBase,
        ),
        child: content,
      ),
    );
  }
}
