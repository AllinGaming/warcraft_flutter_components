import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';
import 'border_box.dart';

/// Warcraft-themed single-line text input.
class WarcraftInput extends StatelessWidget {
  const WarcraftInput({
    super.key,
    this.controller,
    this.hintText,
    this.enabled = true,
    this.keyboardType,
    this.onChanged,
    this.textPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.capWidth = 36,
    this.maxWidth,
  });

  final TextEditingController? controller;
  final String? hintText;
  final bool enabled;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final EdgeInsets textPadding;
  final double capWidth;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final field = WarcraftBorderBox(
      asset: WarcraftAssets.inputFrame,
      sliceInsets: EdgeInsets.only(left: capWidth, right: capWidth),
      padding: textPadding,
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: WarcraftTheme.baseTextStyle(context).copyWith(
          color: Colors.white,
          fontSize: WarcraftTokens.typeLg,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: WarcraftTheme.baseTextStyle(context).copyWith(
            color: WarcraftColors.textMuted,
            fontSize: WarcraftTokens.typeBase,
          ),
        ),
      ),
    );

    if (maxWidth == null) return field;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth!),
      child: field,
    );
  }
}
