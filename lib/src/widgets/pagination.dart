import 'package:flutter/material.dart';
import 'button.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';

/// Warcraft-themed pagination with ellipsis and navigation buttons.
class WarcraftPagination extends StatelessWidget {
  /// Creates a [WarcraftPagination].
  const WarcraftPagination({
    super.key,
    required this.currentPage,
    required this.pageCount,
    required this.onPageChanged,
    this.maxVisiblePages = 3,
  });

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

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    final start = _startPage();
    final end = _endPage(start);

    items.add(_NavButton(
      label: 'Previous',
      enabled: currentPage > 1,
      onPressed: () => onPageChanged(currentPage - 1),
    ));

    if (start > 1) {
      final hidden = start - 1;
      items.add(_Ellipsis(count: _clampEllipsisCount(hidden)));
    }

    for (var i = start; i <= end; i++) {
      items.add(_PageButton(
        page: i,
        isActive: i == currentPage,
        onPressed: () => onPageChanged(i),
      ));
    }

    if (end < pageCount) {
      final hidden = pageCount - end;
      items.add(_Ellipsis(count: _clampEllipsisCount(hidden)));
    }

    items.add(_NavButton(
      label: 'Next',
      enabled: currentPage < pageCount,
      onPressed: () => onPageChanged(currentPage + 1),
    ));

    return Wrap(
      spacing: 8,
      alignment: WrapAlignment.center,
      children: items,
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
  });

  final int page;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return WarcraftButton(
      variant: WarcraftButtonVariant.frame,
      size: WarcraftButtonSize.sm,
      maxWidth: 56,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      onPressed: onPressed,
      child: Text(
        '$page',
        style: WarcraftTheme.baseTextStyle(context).copyWith(
          color: isActive
              ? WarcraftColors.amber200
              : WarcraftColors.amber200.withAlpha(178),
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
    return WarcraftButton(
      variant: WarcraftButtonVariant.frame,
      size: WarcraftButtonSize.sm,
      maxWidth: 140,
      onPressed: enabled ? onPressed : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: WarcraftTheme.baseTextStyle(context).copyWith(
              color: enabled
                  ? WarcraftColors.amber200
                  : WarcraftColors.amber200.withAlpha(128),
              fontSize: WarcraftTokens.typeMd,
            ),
          ),
        ],
      ),
    );
  }
}

class _Ellipsis extends StatelessWidget {
  const _Ellipsis({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final dots = List.filled(count, '♦').join(' ');
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: WarcraftTokens.minTapTarget),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Text(
            dots,
            style: WarcraftTheme.baseTextStyle(context).copyWith(
              color: const Color(0xFFF59E0B),
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: WarcraftTokens.typeXs,
            ),
          ),
        ),
      ),
    );
  }
}
