import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../foundation/warcraft_faction.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';

/// Callback signature for Warcraft checkbox changes.
typedef WarcraftCheckboxChanged = void Function(bool value);

/// Warcraft-themed checkbox with faction skins.
class WarcraftCheckbox extends StatelessWidget {
  /// Creates a [WarcraftCheckbox].
  const WarcraftCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.faction = WarcraftFaction.defaultFaction,
    this.label,
    this.enabled = true,
  });

  /// Whether the checkbox is currently checked.
  final bool value;

  /// Called with the toggled value when the checkbox is tapped.
  final WarcraftCheckboxChanged? onChanged;

  /// The faction skin used to render the checkbox artwork.
  final WarcraftFaction faction;

  /// Optional label displayed next to the checkbox.
  final Widget? label;

  /// Whether the checkbox responds to user interaction.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    final interactive = enabled && onChanged != null;
    final checkbox = Opacity(
      opacity: enabled ? 1 : theme.disabledOpacity,
      child: Container(
        width: WarcraftTokens.minTapTarget,
        height: WarcraftTokens.minTapTarget,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              _assetFor(faction, value),
              package: 'warcraft_flutter_components',
            ),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        checkbox,
        if (label != null) ...[
          const SizedBox(width: WarcraftTokens.spacingMd),
          Flexible(
            child: DefaultTextStyle.merge(
              style: WarcraftTheme.baseTextStyle(context).copyWith(
                fontWeight: FontWeight.w700,
                color: _labelColor(context),
              ),
              child: label!,
            ),
          ),
        ],
      ],
    );

    return MergeSemantics(
      child: Semantics(
        container: true,
        checked: value,
        enabled: interactive,
        onTap: interactive ? () => onChanged?.call(!value) : null,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: interactive ? () => onChanged?.call(!value) : null,
            excludeFromSemantics: true,
            borderRadius: BorderRadius.circular(theme.radius),
            focusColor: theme.focusRing.withAlpha(45),
            hoverColor: theme.primary.withAlpha(24),
            mouseCursor: interactive
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            child: content,
          ),
        ),
      ),
    );
  }

  String _assetFor(WarcraftFaction faction, bool checked) {
    switch (faction) {
      case WarcraftFaction.orc:
        return checked
            ? WarcraftAssets.checkboxOrcChecked
            : WarcraftAssets.checkboxOrc;
      case WarcraftFaction.elf:
        return checked
            ? WarcraftAssets.checkboxElfChecked
            : WarcraftAssets.checkboxElf;
      case WarcraftFaction.human:
        return checked
            ? WarcraftAssets.checkboxHumanChecked
            : WarcraftAssets.checkboxHuman;
      case WarcraftFaction.undead:
        return checked
            ? WarcraftAssets.checkboxUndeadChecked
            : WarcraftAssets.checkboxUndead;
      case WarcraftFaction.defaultFaction:
        return checked
            ? WarcraftAssets.checkboxDefaultChecked
            : WarcraftAssets.checkboxDefault;
    }
  }

  Color _labelColor(BuildContext context) {
    switch (faction) {
      case WarcraftFaction.orc:
        return WarcraftThemeData.forFaction(faction).primary;
      case WarcraftFaction.elf:
        return WarcraftThemeData.forFaction(faction).primary;
      case WarcraftFaction.human:
        return WarcraftThemeData.forFaction(faction).primary;
      case WarcraftFaction.undead:
        return WarcraftThemeData.forFaction(faction).primary;
      case WarcraftFaction.defaultFaction:
        return WarcraftTheme.of(context).primary;
    }
  }
}
