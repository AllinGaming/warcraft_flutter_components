import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../assets/warcraft_assets.dart';
import '../theme/warcraft_theme.dart';

/// Warcraft-themed multi-line text input.
class WarcraftTextarea extends StatelessWidget {
  const WarcraftTextarea({
    super.key,
    this.controller,
    this.hintText,
    this.enabled = true,
    this.maxLines = 5,
    this.onChanged,
    this.textPadding = const EdgeInsets.fromLTRB(20, 18, 20, 18),
    this.capWidth = 32,
    this.maxWidth,
  });

  final TextEditingController? controller;
  final String? hintText;
  final bool enabled;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final EdgeInsets textPadding;
  final double capWidth;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final field = _HorizontalThreeSliceBox(
      asset: WarcraftAssets.textareaBg,
      capWidth: capWidth,
      padding: textPadding,
      child: TextField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        onChanged: onChanged,
        style: WarcraftTheme.baseTextStyle(context).copyWith(
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: WarcraftTheme.baseTextStyle(context).copyWith(
            color: WarcraftColors.textMuted,
            fontSize: 13,
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

class _HorizontalThreeSliceBox extends StatefulWidget {
  const _HorizontalThreeSliceBox({
    required this.asset,
    required this.capWidth,
    required this.child,
    this.padding,
  });

  final String asset;
  final double capWidth;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  State<_HorizontalThreeSliceBox> createState() => _HorizontalThreeSliceBoxState();
}

class _HorizontalThreeSliceBoxState extends State<_HorizontalThreeSliceBox> {
  ui.Image? _image;
  ImageStream? _stream;
  ImageStreamListener? _listener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void didUpdateWidget(covariant _HorizontalThreeSliceBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset != widget.asset) {
      _resolveImage();
    }
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  void _resolveImage() {
    _removeListener();
    final provider = AssetImage(widget.asset, package: 'warcraft_flutter_components');
    final stream = provider.resolve(const ImageConfiguration());
    _listener = ImageStreamListener((info, _) {
      if (mounted) {
        setState(() {
          _image = info.image;
        });
      }
    });
    stream.addListener(_listener!);
    _stream = stream;
  }

  void _removeListener() {
    if (_stream != null && _listener != null) {
      _stream!.removeListener(_listener!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final painter = _image == null
        ? null
        : _ThreeSlicePainter(
            image: _image!,
            capWidth: widget.capWidth,
          );

    return CustomPaint(
      painter: painter,
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: widget.child,
      ),
    );
  }
}

class _ThreeSlicePainter extends CustomPainter {
  _ThreeSlicePainter({required this.image, required this.capWidth});

  final ui.Image image;
  final double capWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final srcW = image.width.toDouble();
    final srcH = image.height.toDouble();
    final cap = capWidth.clamp(1.0, srcW / 2 - 1);

    final srcLeft = Rect.fromLTWH(0, 0, cap, srcH);
    final srcCenter = Rect.fromLTWH(cap, 0, srcW - 2 * cap, srcH);
    final srcRight = Rect.fromLTWH(srcW - cap, 0, cap, srcH);

    final dstLeft = Rect.fromLTWH(0, 0, cap, size.height);
    final dstRight = Rect.fromLTWH(size.width - cap, 0, cap, size.height);
    final dstCenter = Rect.fromLTWH(cap, 0, size.width - 2 * cap, size.height);

    final paint = Paint()..filterQuality = FilterQuality.high;

    canvas.drawImageRect(image, srcLeft, dstLeft, paint);
    canvas.drawImageRect(image, srcRight, dstRight, paint);

    if (dstCenter.width <= 0) return;

    canvas.drawImageRect(image, srcCenter, dstCenter, paint);
  }

  @override
  bool shouldRepaint(covariant _ThreeSlicePainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.capWidth != capWidth;
  }
}
