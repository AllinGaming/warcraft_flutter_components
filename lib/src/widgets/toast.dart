import 'dart:async';
import 'package:flutter/material.dart';
import '../foundation/warcraft_faction.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';

/// Severity/intent variants for [WarcraftToast].
enum WarcraftToastType { defaultType, success, error, warning, info }

/// Screen anchor for a stack of toasts.
enum WarcraftToastPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight
}

/// Warcraft-themed transient notification, shown via the static [show] API.
///
/// Multiple toasts at the same [WarcraftToastPosition] stack, newest toward
/// the screen edge; each position is capped at [WarcraftToast.maxStacked]
/// simultaneous toasts, evicting the oldest when exceeded.
class WarcraftToast {
  const WarcraftToast._();

  static const int maxStacked = 4;

  // Keyed by OverlayState so separate app/test instances (each with their
  // own Overlay) never share or leak toast state into one another.
  static final Map<OverlayState,
      Map<WarcraftToastPosition, GlobalKey<_ToastStackState>>> _stacks = {};

  /// Shows a toast anchored at [position]. [duration] controls how long it
  /// stays visible before auto-dismissing; tapping a toast dismisses it
  /// immediately.
  static void show(
    BuildContext context, {
    required String message,
    WarcraftToastType type = WarcraftToastType.defaultType,
    WarcraftFaction faction = WarcraftFaction.defaultFaction,
    WarcraftToastPosition position = WarcraftToastPosition.bottomRight,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final positions = _stacks.putIfAbsent(overlay, () => {});
    final key = positions[position] ?? GlobalKey<_ToastStackState>();

    if (positions[position] == null) {
      positions[position] = key;
      overlay.insert(
        OverlayEntry(
            builder: (context) => _ToastStack(key: key, position: position)),
      );
    }

    void addToast() => key.currentState?.add(
          message: message,
          type: type,
          faction: faction,
          duration: duration,
        );

    if (key.currentState != null) {
      addToast();
    } else {
      // The stack's OverlayEntry was just inserted this frame and hasn't
      // built yet; retry once the frame that mounts it has completed.
      WidgetsBinding.instance.addPostFrameCallback((_) => addToast());
    }
  }
}

class _ToastData {
  _ToastData({
    required this.message,
    required this.type,
    required this.faction,
    required this.duration,
  });

  final String message;
  final WarcraftToastType type;
  final WarcraftFaction faction;
  final Duration duration;
  Timer? timer;
}

class _ToastStack extends StatefulWidget {
  const _ToastStack(
      {required GlobalKey<_ToastStackState> super.key, required this.position});

  final WarcraftToastPosition position;

  @override
  State<_ToastStack> createState() => _ToastStackState();
}

class _ToastStackState extends State<_ToastStack> {
  final _listKey = GlobalKey<AnimatedListState>();
  final List<_ToastData> _items = [];

  bool get _isTop =>
      widget.position == WarcraftToastPosition.topLeft ||
      widget.position == WarcraftToastPosition.topCenter ||
      widget.position == WarcraftToastPosition.topRight;

  void add({
    required String message,
    required WarcraftToastType type,
    required WarcraftFaction faction,
    required Duration duration,
  }) {
    if (_items.length >= WarcraftToast.maxStacked) {
      _removeAt(0, animate: false);
    }

    final data = _ToastData(
        message: message, type: type, faction: faction, duration: duration);
    _items.add(data);
    _listKey.currentState?.insertItem(
      _items.length - 1,
      duration: const Duration(milliseconds: 200),
    );
    data.timer = Timer(duration, () => _removeData(data));
  }

  void _removeData(_ToastData data) {
    final index = _items.indexOf(data);
    if (index != -1) _removeAt(index);
  }

  void _removeAt(int index, {bool animate = true}) {
    final data = _items.removeAt(index);
    data.timer?.cancel();
    _listKey.currentState?.removeItem(
      index,
      (context, animation) =>
          animate ? _buildToast(data, animation) : const SizedBox.shrink(),
      duration: animate ? const Duration(milliseconds: 200) : Duration.zero,
    );
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
    for (final item in _items) {
      item.timer?.cancel();
    }
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
    final accent = _accentColor(data.type);

    return Semantics(
      liveRegion: true,
      label: data.message,
      child: GestureDetector(
        onTap: onDismiss,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _factionTint(data.faction) ?? const Color(0xFF1B130B),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: accent, width: 1.5),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black87, blurRadius: 16, offset: Offset(0, 4)),
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
                      color: WarcraftColors.amber100,
                      fontSize: WarcraftTokens.typeBase,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _accentColor(WarcraftToastType type) {
    switch (type) {
      case WarcraftToastType.success:
        return const Color(0xFF22C55E);
      case WarcraftToastType.error:
        return const Color(0xFFEF4444);
      case WarcraftToastType.warning:
        return const Color(0xFFF59E0B);
      case WarcraftToastType.info:
        return const Color(0xFF3B82F6);
      case WarcraftToastType.defaultType:
        return const Color(0xFF6B4A16);
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

  Color? _factionTint(WarcraftFaction faction) {
    switch (faction) {
      case WarcraftFaction.orc:
        return const Color(0xFF450A0A).withAlpha(230);
      case WarcraftFaction.elf:
        return const Color(0xFF0A2C28).withAlpha(230);
      case WarcraftFaction.human:
        return const Color(0xFF0F172A).withAlpha(230);
      case WarcraftFaction.undead:
        return const Color(0xFF1A1223).withAlpha(230);
      case WarcraftFaction.defaultFaction:
        return null;
    }
  }
}
