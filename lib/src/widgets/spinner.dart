import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/warcraft_theme.dart';

/// Warcraft-themed loading spinner.
class WarcraftSpinner extends StatefulWidget {
  const WarcraftSpinner({
    super.key,
    this.size = 48,
    this.color = WarcraftColors.amber400,
    this.strokeWidth = 4,
  });

  final double size;
  final Color color;
  final double strokeWidth;

  @override
  State<WarcraftSpinner> createState() => _WarcraftSpinnerState();
}

class _WarcraftSpinnerState extends State<WarcraftSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: CustomPaint(
              painter: _SpinnerPainter(
                color: widget.color,
                strokeWidth: widget.strokeWidth,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final glowPaint = Paint()
      ..color = color.withAlpha(89)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 2.2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final accentPaint = Paint()
      ..color = WarcraftColors.amber100
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.7
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, glowPaint);

    const startAngle = -math.pi / 2;
    final sweep = math.pi * 1.4;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep,
      false,
      ringPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.75),
      startAngle + math.pi * 0.9,
      math.pi * 0.6,
      false,
      accentPaint,
    );

    final runePaint = Paint()
      ..color = color.withAlpha(230)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.6
      ..strokeCap = StrokeCap.round;

    final runeRadius = radius * 0.45;
    for (var i = 0; i < 3; i++) {
      final angle = startAngle + i * (2 * math.pi / 3);
      final start = center + Offset(math.cos(angle), math.sin(angle)) * runeRadius;
      final end = center + Offset(math.cos(angle + 0.4), math.sin(angle + 0.4)) * runeRadius;
      canvas.drawLine(start, end, runePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
