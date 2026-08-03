import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';
import 'border_box.dart';

/// Warcraft-themed single-line text input.
class WarcraftInput extends StatelessWidget {
  /// Creates a [WarcraftInput].
  const WarcraftInput({
    super.key,
    this.controller,
    this.hintText,
    this.enabled = true,
    this.keyboardType,
    this.onChanged,
    this.textPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.capWidth = 72,
    this.capHeight = 72,
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

  /// The type of keyboard to show for editing, e.g. [TextInputType.number].
  final TextInputType? keyboardType;

  /// Called with the current text every time it changes.
  final ValueChanged<String>? onChanged;

  /// Padding applied around the text, inside the decorative frame.
  final EdgeInsets textPadding;

  /// Width, in source-image pixels, of the frame's left/right cap. Measured
  /// from `input-frame.webp` (2048x400), whose carved-metal border is ~72px
  /// thick on every side around a transparent center — matching this to the
  /// real artwork keeps the rivets/bevel crisp instead of partially bleeding
  /// into the stretched middle.
  final double capWidth;

  /// Height, in source-image pixels, of the frame's top/bottom cap. See
  /// [capWidth]; without this the whole 400px-tall source (border and all)
  /// gets uniformly squashed to the field's actual ~48px height.
  final double capHeight;

  /// Maximum width of the input. When `null`, the input expands to fill
  /// its parent.
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final field = WarcraftBorderBox(
      asset: WarcraftAssets.inputFrame,
      sliceInsets:
          EdgeInsets.symmetric(horizontal: capWidth, vertical: capHeight),
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
