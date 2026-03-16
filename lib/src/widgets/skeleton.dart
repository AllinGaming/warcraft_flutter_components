import 'package:flutter/material.dart';
import '../foundation/warcraft_faction.dart';

/// Shape variants for skeletons.
enum WarcraftSkeletonShape { rounded, circular }

/// Warcraft-themed loading skeleton with shimmer.
class WarcraftSkeleton extends StatefulWidget {
  const WarcraftSkeleton({
    super.key,
    this.width,
    this.height,
    this.faction = WarcraftFaction.defaultFaction,
    this.shape = WarcraftSkeletonShape.rounded,
  });

  final double? width;
  final double? height;
  final WarcraftFaction faction;
  final WarcraftSkeletonShape shape;

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.shape == WarcraftSkeletonShape.circular
        ? BorderRadius.circular(999)
        : BorderRadius.circular(6);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(decoration: BoxDecoration(gradient: _baseGradient())),
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                final shimmerPosition = _controller.value * 2 - 1;
                return Transform.translate(
                  offset: Offset(shimmerPosition * (widget.width ?? 200), 0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: _shimmerGradient(),
                    ),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(color: Colors.black.withAlpha(51)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Gradient _baseGradient() {
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
        return const LinearGradient(
          colors: [Color(0xFF221B14), Color(0xFF2B2118), Color(0xFF241C15)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Gradient _shimmerGradient() {
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
        return const LinearGradient(
          colors: [Colors.transparent, Color(0x33F8C65E), Colors.transparent],
          stops: [0.0, 0.5, 1.0],
        );
    }
  }
}
