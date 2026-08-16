import 'package:flutter/material.dart';
import '../foundation/warcraft_faction.dart';
import '../theme/warcraft_theme.dart';
import '../theme/warcraft_tokens.dart';

/// Shape variants for skeletons.
enum WarcraftSkeletonShape {
  /// A rectangle with slightly rounded corners.
  rounded,

  /// A fully rounded (pill/circle) shape, for avatars and icons.
  circular,
}

/// Warcraft-themed loading skeleton with shimmer.
class WarcraftSkeleton extends StatefulWidget {
  /// Creates a [WarcraftSkeleton].
  const WarcraftSkeleton({
    super.key,
    this.width,
    this.height,
    this.faction = WarcraftFaction.defaultFaction,
    this.shape = WarcraftSkeletonShape.rounded,
    this.semanticLabel = 'Loading',
    this.animate = true,
  }) : assert(width == null || width > 0, 'width must be greater than zero'),
       assert(height == null || height > 0, 'height must be greater than zero');

  /// Fixed width of the skeleton. If `null`, sizes to the incoming
  /// constraints.
  final double? width;

  /// Fixed height of the skeleton. If `null`, sizes to the incoming
  /// constraints.
  final double? height;

  /// Which faction's color palette to use for the base and shimmer
  /// gradients.
  final WarcraftFaction faction;

  /// Whether the skeleton is drawn as a rounded rectangle or a circle.
  final WarcraftSkeletonShape shape;

  /// Announced to assistive technology while the skeleton is shown. Pass
  /// `null` to leave the placeholder unlabeled/excluded from semantics.
  final String? semanticLabel;

  /// Whether to show the shimmer animation. Reduced-motion platform settings
  /// always take precedence and pause it automatically.
  final bool animate;

  @override
  State<WarcraftSkeleton> createState() => _WarcraftSkeletonState();
}

class _WarcraftSkeletonState extends State<WarcraftSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final shouldAnimate = widget.animate && !reduceMotion;
    if (!shouldAnimate && _controller.isAnimating) {
      _controller
        ..stop()
        ..value = 0.25;
    } else if (shouldAnimate && !_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant WarcraftSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate != widget.animate) {
      final reduceMotion =
          MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      if (widget.animate && !reduceMotion) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = WarcraftTheme.of(context);
    final borderRadius = widget.shape == WarcraftSkeletonShape.circular
        ? BorderRadius.circular(999)
        : BorderRadius.circular(WarcraftTokens.radiusSm);

    final skeleton = SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final sweepWidth =
                widget.width ??
                (constraints.maxWidth.isFinite ? constraints.maxWidth : 200.0);
            return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(gradient: _baseGradient(theme)),
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, _) {
                    final shimmerPosition = _controller.value * 2 - 1;
                    return Transform.translate(
                      offset: Offset(shimmerPosition * sweepWidth, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: _shimmerGradient(theme),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(color: theme.border.withAlpha(65)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    final label = widget.semanticLabel;
    return label == null ? skeleton : Semantics(label: label, child: skeleton);
  }

  Gradient _baseGradient(WarcraftThemeData theme) {
    switch (widget.faction) {
      case WarcraftFaction.orc:
        return const LinearGradient(
          colors: [Color(0xFF2D0B0B), Color(0xFF3A1310), Color(0xFF2A0E0E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case WarcraftFaction.elf:
        return const LinearGradient(
          colors: [Color(0xFF0A2C28), Color(0xFF123634), Color(0xFF0B2D29)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case WarcraftFaction.human:
        return const LinearGradient(
          colors: [Color(0xFF14233D), Color(0xFF1A2E4A), Color(0xFF15263F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case WarcraftFaction.undead:
        return const LinearGradient(
          colors: [Color(0xFF1A1223), Color(0xFF23162D), Color(0xFF1B1324)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case WarcraftFaction.defaultFaction:
        return LinearGradient(
          colors: [theme.surface, theme.surfaceElevated, theme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Gradient _shimmerGradient(WarcraftThemeData theme) {
    switch (widget.faction) {
      case WarcraftFaction.orc:
        return const LinearGradient(
          colors: [Colors.transparent, Color(0x33FF6B3D), Colors.transparent],
          stops: [0.0, 0.5, 1.0],
        );
      case WarcraftFaction.elf:
        return const LinearGradient(
          colors: [Colors.transparent, Color(0x3348D1C1), Colors.transparent],
          stops: [0.0, 0.5, 1.0],
        );
      case WarcraftFaction.human:
        return const LinearGradient(
          colors: [Colors.transparent, Color(0x3348B0FF), Colors.transparent],
          stops: [0.0, 0.5, 1.0],
        );
      case WarcraftFaction.undead:
        return const LinearGradient(
          colors: [Colors.transparent, Color(0x336B4CF2), Colors.transparent],
          stops: [0.0, 0.5, 1.0],
        );
      case WarcraftFaction.defaultFaction:
        return LinearGradient(
          colors: [
            Colors.transparent,
            theme.primary.withAlpha(51),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        );
    }
  }
}
