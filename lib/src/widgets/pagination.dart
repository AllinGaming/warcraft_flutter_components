import 'package:flutter/material.dart';
import 'button.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';

/// Builds an accessible label for a 1-based pagination page number.
typedef WarcraftPageSemanticLabelBuilder = String Function(int page);

/// Warcraft-themed pagination with ellipsis and navigation buttons.
class WarcraftPagination extends StatelessWidget {
  /// Creates a [WarcraftPagination].
  const WarcraftPagination({
    super.key,
    required this.currentPage,
    required this.pageCount,
    required this.onPageChanged,
    this.maxVisiblePages = 3,
    this.previousLabel = 'Previous',
    this.nextLabel = 'Next',
    this.semanticLabel = 'Pagination',
    this.pageSemanticLabelBuilder,
    this.currentPageSemanticLabelBuilder,
    this.ellipsisSemanticLabel = 'More pages',
  }) : assert(pageCount > 0, 'pageCount must be greater than zero'),
       assert(
         currentPage >= 1 && currentPage <= pageCount,
         'currentPage must be between 1 and pageCount',
       ),
       assert(maxVisiblePages > 0, 'maxVisiblePages must be greater than zero');

  /// The currently selected page, 1-based.
  final int currentPage;

  /// The total number of pages available.
  final int pageCount;

  /// Called with the new page number when a page button, or the
  /// previous/next button, is pressed.
  final ValueChanged<int> onPageChanged;

  /// The maximum number of page buttons shown at once around
  /// [currentPage]. Pages that fall outside this window are collapsed
  /// into an ellipsis indicator on the corresponding side instead of
  /// being rendered individually.
  final int maxVisiblePages;

  /// Localizable label for the previous-page action.
  final String previousLabel;

  /// Localizable label for the next-page action.
  final String nextLabel;

  /// Accessible label for the pagination navigation region.
  final String semanticLabel;

  /// Optional localizable accessible-label builder for inactive page buttons.
  final WarcraftPageSemanticLabelBuilder? pageSemanticLabelBuilder;

  /// Optional localizable accessible-label builder for the current page.
  final WarcraftPageSemanticLabelBuilder? currentPageSemanticLabelBuilder;

  /// Localizable accessible label for each collapsed page range.
  final String ellipsisSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    final start = _startPage();
    final end = _endPage(start);

    items.add(
      _NavButton(
        label: previousLabel,
        enabled: currentPage > 1,
        onPressed: () => onPageChanged(currentPage - 1),
      ),
    );

    if (start > 1) {
      final hidden = start - 1;
      items.add(
        _Ellipsis(
          count: _clampEllipsisCount(hidden),
          semanticLabel: ellipsisSemanticLabel,
        ),
      );
    }

    for (var i = start; i <= end; i++) {
      items.add(
        _PageButton(
          page: i,
          isActive: i == currentPage,
          onPressed: () => onPageChanged(i),
          semanticLabel: i == currentPage
              ? (currentPageSemanticLabelBuilder?.call(i) ??
                    'Page $i, current page')
              : (pageSemanticLabelBuilder?.call(i) ?? 'Go to page $i'),
        ),
      );
    }

    if (end < pageCount) {
      final hidden = pageCount - end;
      items.add(
        _Ellipsis(
          count: _clampEllipsisCount(hidden),
          semanticLabel: ellipsisSemanticLabel,
        ),
      );
    }

    items.add(
      _NavButton(
        label: nextLabel,
        enabled: currentPage < pageCount,
        onPressed: () => onPageChanged(currentPage + 1),
      ),
    );

    return Semantics(
      container: true,
      label: semanticLabel,
      child: Wrap(
        spacing: WarcraftTokens.spacingSm,
        runSpacing: WarcraftTokens.spacingSm,
        alignment: WrapAlignment.center,
        children: items,
      ),
    );
  }

  int _startPage() {
    final half = maxVisiblePages ~/ 2;
    var start = currentPage - half;
    if (start < 1) start = 1;
    if (start + maxVisiblePages - 1 > pageCount) {
      start = (pageCount - maxVisiblePages + 1).clamp(1, pageCount);
    }
    return start;
  }

  int _endPage(int start) {
    var end = start + maxVisiblePages - 1;
    if (end > pageCount) end = pageCount;
    return end;
  }

  int _clampEllipsisCount(int hidden) {
    if (hidden <= 1) return 1;
    if (hidden == 2) return 2;
    return 3;
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.page,
    required this.isActive,
    required this.onPressed,
    required this.semanticLabel,
  });

  final int page;
  final bool isActive;
  final VoidCallback onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    return WarcraftButton(
      variant: WarcraftButtonVariant.frame,
      size: WarcraftButtonSize.sm,
      maxWidth: 56,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      onPressed: onPressed,
      selected: isActive,
      semanticLabel: semanticLabel,
      child: Text(
        '$page',
        style: WarcraftTheme.baseTextStyle(context).copyWith(
          color: isActive ? theme.primary : theme.mutedForeground,
          fontWeight: FontWeight.bold,
          fontSize: WarcraftTokens.typeMd,
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    return WarcraftButton(
      variant: WarcraftButtonVariant.frame,
      size: WarcraftButtonSize.sm,
      maxWidth: 140,
      onPressed: enabled ? onPressed : null,
      semanticLabel: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: WarcraftTheme.baseTextStyle(context).copyWith(
              color: enabled ? theme.foreground : theme.mutedForeground,
              fontSize: WarcraftTokens.typeMd,
            ),
          ),
        ],
      ),
    );
  }
}

class _Ellipsis extends StatelessWidget {
  const _Ellipsis({required this.count, required this.semanticLabel});

  final int count;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    final dots = List.filled(count, '♦').join(' ');
    return Semantics(
      container: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: WarcraftTokens.minTapTarget,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Text(
              dots,
              style: WarcraftTheme.baseTextStyle(context).copyWith(
                color: theme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: WarcraftTokens.typeXs,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
