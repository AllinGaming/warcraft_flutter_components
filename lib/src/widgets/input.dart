import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';
import 'border_box.dart';

/// Warcraft-themed single-line text input.
class WarcraftInput extends StatefulWidget {
  /// Creates a [WarcraftInput].
  const WarcraftInput({
    super.key,
    this.controller,
    this.hintText,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.obscureText = false,
    this.readOnly = false,
    this.inputFormatters,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.obscuringCharacter = '•',
    this.prefixIcon,
    this.suffixIcon,
    this.helperText,
    this.errorText,
    this.semanticLabel,
    this.textPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.capWidth = 72,
    this.capHeight = 72,
    this.maxWidth,
  }) : assert(capWidth >= 0),
       assert(capHeight >= 0),
       assert(maxWidth == null || maxWidth > 0),
       assert(maxLength == null || maxLength >= 0),
       assert(obscuringCharacter.length == 1);

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

  /// Action button shown by the software keyboard.
  final TextInputAction? textInputAction;

  /// Called with the current text every time it changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field.
  final ValueChanged<String>? onSubmitted;

  /// Called when editing is complete, before focus traversal occurs.
  final VoidCallback? onEditingComplete;

  /// Called when the field is tapped.
  final VoidCallback? onTap;

  /// Optional focus node for programmatic focus control.
  final FocusNode? focusNode;

  /// Whether the field should claim focus when first shown.
  final bool autofocus;

  /// Whether the entered text is visually obscured.
  final bool obscureText;

  /// Whether the value can be selected but not changed.
  final bool readOnly;

  /// Optional formatters applied as the user edits.
  final List<TextInputFormatter>? inputFormatters;

  /// Hints used by platform autofill services.
  final Iterable<String>? autofillHints;

  /// Automatic capitalization behavior for the software keyboard.
  final TextCapitalization textCapitalization;

  /// Whether the platform should automatically correct input.
  final bool autocorrect;

  /// Whether the platform should show input suggestions.
  final bool enableSuggestions;

  /// Optional maximum character count.
  final int? maxLength;

  /// Horizontal alignment of the editable text.
  final TextAlign textAlign;

  /// Character used to obscure input when [obscureText] is true.
  final String obscuringCharacter;

  /// Optional icon displayed before the editable text.
  final Widget? prefixIcon;

  /// Optional icon displayed after the editable text.
  final Widget? suffixIcon;

  /// Supporting copy displayed beneath the field.
  final String? helperText;

  /// Validation message displayed beneath the field.
  final String? errorText;

  /// Optional accessible label when no visible label describes the field.
  final String? semanticLabel;

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
  State<WarcraftInput> createState() => _WarcraftInputState();
}

class _WarcraftInputState extends State<WarcraftInput> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    final supportingText = widget.errorText ?? widget.helperText;
    final field = Semantics(
      textField: true,
      label: widget.semanticLabel,
      validationResult: widget.errorText == null
          ? SemanticsValidationResult.none
          : SemanticsValidationResult.invalid,
      child: Focus(
        onFocusChange: (focused) => setState(() => _focused = focused),
        child: AnimatedContainer(
          duration: WarcraftTheme.motionDurationOf(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.radius),
            border: Border.all(
              color: widget.errorText != null
                  ? theme.danger
                  : (_focused ? theme.focusRing : Colors.transparent),
              width: 2,
            ),
            boxShadow: _focused
                ? [
                    BoxShadow(
                      color: theme.focusRing.withAlpha(45),
                      blurRadius: 12,
                    ),
                  ]
                : const [],
          ),
          child: WarcraftBorderBox(
            asset: WarcraftAssets.inputFrame,
            sliceInsets: EdgeInsets.symmetric(
              horizontal: widget.capWidth,
              vertical: widget.capHeight,
            ),
            padding: widget.textPadding,
            borderRadius: BorderRadius.circular(theme.radius),
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              onEditingComplete: widget.onEditingComplete,
              onTap: widget.onTap,
              inputFormatters: widget.inputFormatters,
              autofillHints: widget.autofillHints,
              textCapitalization: widget.textCapitalization,
              autocorrect: widget.autocorrect,
              enableSuggestions: widget.enableSuggestions,
              maxLength: widget.maxLength,
              textAlign: widget.textAlign,
              obscuringCharacter: widget.obscuringCharacter,
              style: WarcraftTheme.baseTextStyle(context).copyWith(
                color: theme.foreground,
                fontSize: WarcraftTokens.typeLg,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: widget.hintText,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon,
                prefixIconColor: theme.mutedForeground,
                suffixIconColor: theme.mutedForeground,
                hintStyle: WarcraftTheme.baseTextStyle(context).copyWith(
                  color: theme.mutedForeground,
                  fontSize: WarcraftTokens.typeBase,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        field,
        if (supportingText != null)
          Padding(
            padding: const EdgeInsets.only(
              left: WarcraftTokens.spacingSm,
              top: WarcraftTokens.spacingXs,
            ),
            child: Semantics(
              liveRegion: widget.errorText != null,
              child: Text(
                supportingText,
                style: WarcraftTheme.baseTextStyle(context).copyWith(
                  color: widget.errorText != null
                      ? theme.danger
                      : theme.mutedForeground,
                  fontSize: WarcraftTokens.typeSm,
                ),
              ),
            ),
          ),
      ],
    );

    if (widget.maxWidth == null) return content;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.maxWidth!),
      child: content,
    );
  }
}
