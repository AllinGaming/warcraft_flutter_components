import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../foundation/warcraft_faction.dart';
import '../theme/warcraft_theme.dart';

/// Callback signature for Warcraft checkbox changes.
typedef WarcraftCheckboxChanged = void Function(bool value);

/// Warcraft-themed checkbox with faction skins.
class WarcraftCheckbox extends StatelessWidget {
  const WarcraftCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.faction = WarcraftFaction.defaultFaction,
    this.label,
    this.enabled = true,
  });

  final bool value;
  final WarcraftCheckboxChanged? onChanged;
  final WarcraftFaction faction;
  final Widget? label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final checkbox = Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Container(
        width: 48,
        height: 48,
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
          const SizedBox(width: 12),
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

    return GestureDetector(
      onTap: enabled ? () => onChanged?.call(!value) : null,
      child: content,
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
        return const Color(0xFFB91C1C);
      case WarcraftFaction.elf:
        return const Color(0xFF15803D);
      case WarcraftFaction.human:
        return const Color(0xFF1D4ED8);
      case WarcraftFaction.undead:
        return const Color(0xFF6B21A8);
      case WarcraftFaction.defaultFaction:
        return const Color(0xFF92400E);
    }
  }
}
