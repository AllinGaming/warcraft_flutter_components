import 'dart:async';
import 'package:flutter/material.dart';
import '../foundation/warcraft_faction.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';

/// Severity/intent variants for [WarcraftToast].
enum WarcraftToastType {
  /// Neutral, general-purpose toast with no specific severity.
  defaultType,

  /// Indicates a successful action or outcome.
  success,

  /// Indicates a failure or error condition.
  error,

  /// Indicates a warning or caution.
  warning,

  /// Indicates an informational message.
  info,
}

/// Screen anchor for a stack of toasts.
enum WarcraftToastPosition {
  /// Top-left corner of the screen.
  topLeft,

  /// Top-center of the screen.
  topCenter,

  /// Top-right corner of the screen.
  topRight,

  /// Bottom-left corner of the screen.
  bottomLeft,

  /// Bottom-center of the screen.
  bottomCenter,

  /// Bottom-right corner of the screen.
  bottomRight,
}

/// Handle returned by [WarcraftToast.show] for dismissing a toast early.
class WarcraftToastController {
  WarcraftToastController._();

  VoidCallback? _onDismiss;
  bool _isDismissed = false;

  /// Whether this toast has already been dismissed or expired.
  bool get isDismissed => _isDismissed;

  /// Dismisses the toast. Calling this more than once is safe.
  void dismiss() {
    if (_isDismissed) return;
    _isDismissed = true;
    _onDismiss?.call();
  }

  void _attach(VoidCallback callback) {
    _onDismiss = callback;
    if (_isDismissed) callback();
  }

  void _markDismissed() {
    _isDismissed = true;
    _onDismiss = null;
  }
}

/// Warcraft-themed transient notification, shown via the static [show] API.
///
/// Multiple toasts at the same [WarcraftToastPosition] stack, newest toward
/// the screen edge; each position is capped at [WarcraftToast.maxStacked]
/// simultaneous toasts, evicting the oldest when exceeded.
class WarcraftToast {
  const WarcraftToast._();

  /// Maximum number of toasts stacked at a single [WarcraftToastPosition]
  /// simultaneously; the oldest toast is evicted once this is exceeded.
  static const int maxStacked = 4;

  // Keyed by OverlayState so separate app/test instances (each with their
  // own Overlay) never share or leak toast state into one another.
  static final Map<
    OverlayState,
    Map<WarcraftToastPosition, GlobalKey<_ToastStackState>>
  >
  _stacks = {};

  /// Shows a toast anchored at [position]. [duration] controls how long it
  /// stays visible before auto-dismissing; tapping a toast dismisses it
  /// immediately.
  static WarcraftToastController show(
    BuildContext context, {
    required String message,
    WarcraftToastType type = WarcraftToastType.defaultType,
    WarcraftFaction faction = WarcraftFaction.defaultFaction,
    WarcraftToastPosition position = WarcraftToastPosition.bottomRight,
    Duration duration = const Duration(seconds: 3),
    String dismissLabel = 'Dismiss notification',
  }) {
    assert(!duration.isNegative, 'duration cannot be negative');
    final overlay = Overlay.of(context, rootOverlay: true);
    final positions = _stacks.putIfAbsent(overlay, () => {});
    final key = positions[position] ?? GlobalKey<_ToastStackState>();
    final controller = WarcraftToastController._();

    if (positions[position] == null) {
      positions[position] = key;
      late OverlayEntry entry;

      void removeRegistration() {
        positions.remove(position);
        if (positions.isEmpty) _stacks.remove(overlay);
      }

      void removeEntry() {
        removeRegistration();
        if (entry.mounted) entry.remove();
      }

      entry = OverlayEntry(
        builder: (context) => _ToastStack(
          key: key,
          position: position,
          onEmpty: removeEntry,
          onDisposed: removeRegistration,
        ),
      );
      overlay.insert(entry);
    }

    void addToast() => key.currentState?.add(
      message: message,
      type: type,
      faction: faction,
      duration: duration,
      dismissLabel: dismissLabel,
      controller: controller,
    );

    if (key.currentState != null) {
      addToast();
    } else {
      // The stack's OverlayEntry was just inserted this frame and hasn't
      // built yet; retry once the frame that mounts it has completed.
      WidgetsBinding.instance.addPostFrameCallback((_) => addToast());
    }
    return controller;
  }
}

class _ToastData {
  _ToastData({
    required this.message,
    required this.type,
    required this.faction,
    required this.duration,
    required this.dismissLabel,
    required this.controller,
  });

  final String message;
  final WarcraftToastType type;
  final WarcraftFaction faction;
  final Duration duration;
  final String dismissLabel;
  final WarcraftToastController controller;
  Timer? timer;
}

class _ToastStack extends StatefulWidget {
  const _ToastStack({
    required GlobalKey<_ToastStackState> super.key,
    required this.position,
    required this.onEmpty,
    required this.onDisposed,
  });

  final WarcraftToastPosition position;
  final VoidCallback onEmpty;
  final VoidCallback onDisposed;

  @override
  State<_ToastStack> createState() => _ToastStackState();
}

class _ToastStackState extends State<_ToastStack> {
  final _listKey = GlobalKey<AnimatedListState>();
  final List<_ToastData> _items = [];
  Timer? _emptyTimer;

  bool get _isTop =>
      widget.position == WarcraftToastPosition.topLeft ||
      widget.position == WarcraftToastPosition.topCenter ||
      widget.position == WarcraftToastPosition.topRight;

  void add({
    required String message,
    required WarcraftToastType type,
    required WarcraftFaction faction,
    required Duration duration,
    required String dismissLabel,
    required WarcraftToastController controller,
  }) {
    _emptyTimer?.cancel();
    if (_items.length >= WarcraftToast.maxStacked) {
      _removeAt(0, animate: false);
    }

    final data = _ToastData(
      message: message,
      type: type,
      faction: faction,
      duration: duration,
      dismissLabel: dismissLabel,
      controller: controller,
    );
    _items.add(data);
    _listKey.currentState?.insertItem(
      _items.length - 1,
      duration: WarcraftTheme.motionDurationOf(context),
    );
    controller._attach(() => _removeData(data));
    if (!controller.isDismissed) {
      data.timer = Timer(duration, () => _removeData(data));
    }
  }

  void _removeData(_ToastData data) {
    final index = _items.indexOf(data);
    if (index != -1) _removeAt(index);
  }

  void _removeAt(int index, {bool animate = true}) {
    final data = _items.removeAt(index);
    data.timer?.cancel();
    data.controller._markDismissed();
    final exitDuration = animate
        ? WarcraftTheme.motionDurationOf(context)
        : Duration.zero;
    _listKey.currentState?.removeItem(
      index,
      (context, animation) =>
          animate ? _buildToast(data, animation) : const SizedBox.shrink(),
      duration: exitDuration,
    );
    if (_items.isEmpty) {
      _emptyTimer?.cancel();
      _emptyTimer = Timer(exitDuration, () {
        if (mounted && _items.isEmpty) widget.onEmpty();
      });
    }
  }

  Widget _buildToast(_ToastData data, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, _isTop ? -0.2 : 0.2),
            end: Offset.zero,
          ).animate(animation),
          child: Padding(
            padding: const EdgeInsets.only(bottom: WarcraftTokens.spacingSm),
            child: _WarcraftToastCard(
              data: data,
              onDismiss: () => _removeData(data),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emptyTimer?.cancel();
    for (final item in _items) {
      item.timer?.cancel();
      item.controller._markDismissed();
    }
    widget.onDisposed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _alignmentFor(widget.position),
      child: Padding(
        padding: const EdgeInsets.all(WarcraftTokens.spacingMd),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: AnimatedList(
            key: _listKey,
            shrinkWrap: true,
            reverse: !_isTop,
            itemBuilder: (context, index, animation) =>
                _buildToast(_items[index], animation),
          ),
        ),
      ),
    );
  }

  Alignment _alignmentFor(WarcraftToastPosition position) {
    switch (position) {
      case WarcraftToastPosition.topLeft:
        return Alignment.topLeft;
      case WarcraftToastPosition.topCenter:
        return Alignment.topCenter;
      case WarcraftToastPosition.topRight:
        return Alignment.topRight;
      case WarcraftToastPosition.bottomLeft:
        return Alignment.bottomLeft;
      case WarcraftToastPosition.bottomCenter:
        return Alignment.bottomCenter;
      case WarcraftToastPosition.bottomRight:
        return Alignment.bottomRight;
    }
  }
}

class _WarcraftToastCard extends StatelessWidget {
  const _WarcraftToastCard({required this.data, required this.onDismiss});

  final _ToastData data;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    final accent = _accentColor(data.type, theme);

    return Semantics(
      liveRegion: true,
      label: data.message,
      hint: data.dismissLabel,
      button: true,
      onTap: onDismiss,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onDismiss,
          borderRadius: BorderRadius.circular(theme.radius),
          mouseCursor: SystemMouseCursors.click,
          focusColor: theme.focusRing.withAlpha(45),
          hoverColor: theme.primary.withAlpha(24),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _factionTint(data.faction, theme),
              borderRadius: BorderRadius.circular(theme.radius),
              border: Border.all(color: accent, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: theme.shadow,
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: WarcraftTokens.spacingMd,
                vertical: WarcraftTokens.spacingSm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_iconFor(data.type), size: 18, color: accent),
                  const SizedBox(width: WarcraftTokens.spacingSm),
                  Flexible(
                    child: Text(
                      data.message,
                      style: WarcraftTheme.baseTextStyle(context).copyWith(
                        color: theme.foreground,
                        fontSize: WarcraftTokens.typeBase,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _accentColor(WarcraftToastType type, WarcraftThemeData theme) {
    switch (type) {
      case WarcraftToastType.success:
        return theme.success;
      case WarcraftToastType.error:
        return theme.danger;
      case WarcraftToastType.warning:
        return theme.warning;
      case WarcraftToastType.info:
        return theme.info;
      case WarcraftToastType.defaultType:
        return theme.border;
    }
  }

  IconData _iconFor(WarcraftToastType type) {
    switch (type) {
      case WarcraftToastType.success:
        return Icons.check_circle;
      case WarcraftToastType.error:
        return Icons.error;
      case WarcraftToastType.warning:
        return Icons.warning_amber_rounded;
      case WarcraftToastType.info:
        return Icons.info;
      case WarcraftToastType.defaultType:
        return Icons.shield_moon;
    }
  }

  Color _factionTint(WarcraftFaction faction, WarcraftThemeData theme) {
    if (faction == WarcraftFaction.defaultFaction) {
      return theme.surfaceElevated;
    }
    final accent = WarcraftThemeData.forFaction(faction).primary.withAlpha(36);
    return Color.alphaBlend(accent, theme.surfaceElevated);
  }
}
