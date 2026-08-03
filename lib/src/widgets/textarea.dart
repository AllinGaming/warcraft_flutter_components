import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';
import 'border_box.dart';

/// Warcraft-themed multi-line text input.
class WarcraftTextarea extends StatelessWidget {
  /// Creates a [WarcraftTextarea].
  const WarcraftTextarea({
    super.key,
    this.controller,
    this.hintText,
    this.enabled = true,
    this.maxLines = 5,
    this.onChanged,
    this.textPadding = const EdgeInsets.fromLTRB(20, 18, 20, 18),
    this.capWidth = 9,
    this.capHeight = 6,
    this.maxWidth,
  });

  /// Controls the text being edited. When `null`, the field manages its
  /// own internal [TextEditingController].
  final TextEditingController? controller;

  /// Placeholder text shown when the field is empty.
  final String? hintText;

  /// Whether the field accepts input. When `false`, the field is greyed
  /// out and ignores taps.
  final bool enabled;

  /// The maximum number of lines the field can span.
  final int maxLines;

  /// Called with the current text every time it changes.
  final ValueChanged<String>? onChanged;

  /// Padding applied around the text, inside the decorative frame.
  final EdgeInsets textPadding;

  /// Width, in source-image pixels, of `textarea-bg.webp`'s (949x494) thin
  /// decorative left/right rim — measured from the asset itself so it isn't
  /// stretched or, previously, mismatched against the actual ~9px edge.
  final double capWidth;

  /// Height, in source-image pixels, of the asset's thin top/bottom rim
  /// (~6px). See [capWidth].
  final double capHeight;

  /// Maximum width of the textarea. When `null`, the textarea expands to
  /// fill its parent.
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final field = WarcraftBorderBox(
      asset: WarcraftAssets.textareaBg,
      sliceInsets:
          EdgeInsets.symmetric(horizontal: capWidth, vertical: capHeight),
      padding: textPadding,
      child: TextField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
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
