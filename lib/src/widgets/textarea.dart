import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';
import 'border_box.dart';

/// Warcraft-themed multi-line text input.
class WarcraftTextarea extends StatefulWidget {
  /// Creates a [WarcraftTextarea].
  const WarcraftTextarea({
    super.key,
    this.controller,
    this.hintText,
    this.enabled = true,
    this.maxLines = 5,
    this.minLines = 3,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.readOnly = false,
    this.keyboardType = TextInputType.multiline,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.sentences,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.helperText,
    this.errorText,
    this.semanticLabel,
    this.textPadding = const EdgeInsets.fromLTRB(20, 18, 20, 18),
    this.capWidth = 9,
    this.capHeight = 6,
    this.maxWidth,
  }) : assert(minLines > 0),
       assert(maxLines >= minLines),
       assert(capWidth >= 0),
       assert(capHeight >= 0),
       assert(maxWidth == null || maxWidth > 0),
       assert(maxLength == null || maxLength >= 0);

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

  /// The minimum number of visible lines.
  final int minLines;

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

  /// Whether text can be selected but not changed.
  final bool readOnly;

  /// The keyboard layout requested from the platform.
  final TextInputType? keyboardType;

  /// Action button shown by the software keyboard.
  final TextInputAction? textInputAction;

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

  /// Supporting copy displayed beneath the field.
  final String? helperText;

  /// Validation message displayed beneath the field.
  final String? errorText;

  /// Optional accessible label when no visible label describes the field.
  final String? semanticLabel;

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
  State<WarcraftTextarea> createState() => _WarcraftTextareaState();
}

class _WarcraftTextareaState extends State<WarcraftTextarea> {
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
            asset: WarcraftAssets.textareaBg,
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
              minLines: widget.minLines,
              maxLines: widget.maxLines,
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
              style: WarcraftTheme.baseTextStyle(context).copyWith(
                color: theme.foreground,
                fontSize: WarcraftTokens.typeLg,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: widget.hintText,
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
