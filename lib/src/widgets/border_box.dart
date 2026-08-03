import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Renders [asset] as a 9-slice (or, with a zero top/bottom inset, a
/// horizontal 3-slice) frame around [child].
///
/// This is the package's shared image-frame primitive: pass
/// `sliceInsets: EdgeInsets.only(left: capWidth, right: capWidth)` to get a
/// horizontal-only cap/stretch/cap layout (used by [WarcraftInput] and
/// [WarcraftTextarea]), or full insets on every side for a true 9-slice
/// panel (used by [WarcraftCard], [WarcraftButton], etc.).
class WarcraftBorderBox extends StatefulWidget {
  const WarcraftBorderBox({
    super.key,
    required this.asset,
    required this.sliceInsets,
    required this.child,
    this.padding,
    this.borderRadius,
    this.boxShadow,
    this.alignment,
    this.tileCenter = false,
    this.tileCenterInsets = EdgeInsets.zero,
  });

  final String asset;
  final EdgeInsets sliceInsets;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final AlignmentGeometry? alignment;
  final bool tileCenter;
  final EdgeInsets tileCenterInsets;

  @override
  State<WarcraftBorderBox> createState() => _WarcraftBorderBoxState();
}

class _WarcraftBorderBoxState extends State<WarcraftBorderBox> {
  ui.Image? _image;
  ImageStream? _stream;
  ImageStreamListener? _listener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void didUpdateWidget(covariant WarcraftBorderBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset != widget.asset) {
      _resolveImage();
    }
  }

  @override
  void dispose() {
    _removeListener();
    _image?.dispose();
    super.dispose();
  }

  void _resolveImage() {
    final provider =
        AssetImage(widget.asset, package: 'warcraft_flutter_components');
    final stream = provider.resolve(const ImageConfiguration());

    // The stream key is stable for an unchanged asset/configuration, so
    // dependency changes that don't actually affect asset resolution (e.g.
    // an unrelated InheritedWidget rebuild) are a cheap no-op instead of
    // tearing down and re-subscribing a fresh listener every time.
    if (_stream?.key == stream.key) {
      return;
    }

    _removeListener();
    _listener = ImageStreamListener(
      (info, _) {
        if (!mounted) {
          info.image.dispose();
          return;
        }
        final previous = _image;
        setState(() {
          _image = info.image;
        });
        if (previous != null) {
          SchedulerBinding.instance
              .addPostFrameCallback((_) => previous.dispose());
        }
      },
      onError: (exception, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: exception,
            stack: stackTrace,
            library: 'warcraft_flutter_components',
            context: ErrorDescription(
                'resolving WarcraftBorderBox asset ${widget.asset}'),
          ),
        );
        if (mounted) {
          setState(() => _image = null);
        }
      },
    );
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
    // Only wrap in `Align` when the caller actually asks for alignment.
    // `Align` sizes itself to fill any *bounded* incoming constraint (even
    // a merely-loose one), regardless of the alignment value — so an
    // unconditional `Align` here would force every frame to expand to fill
    // whatever ambient bounded space it's placed in (e.g. a full Scaffold
    // body) instead of shrink-wrapping its own content.
    final alignment = widget.alignment;
    final content = Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: alignment == null
          ? widget.child
          : Align(alignment: alignment, child: widget.child),
    );

    final painter = _image == null
        ? null
        : _NineSlicePainter(
            image: _image!,
            sliceInsets: widget.sliceInsets,
            tileCenter: widget.tileCenter,
            tileCenterInsets: widget.tileCenterInsets,
          );

    final painted = CustomPaint(
      painter: painter,
      child: content,
    );

    final decorated = widget.boxShadow == null
        ? painted
        : DecoratedBox(
            decoration: BoxDecoration(boxShadow: widget.boxShadow),
            child: painted,
          );

    if (widget.borderRadius == null) {
      return decorated;
    }

    return ClipRRect(
      borderRadius: widget.borderRadius!,
      child: decorated,
    );
  }
}

class _NineSlicePainter extends CustomPainter {
  _NineSlicePainter({
    required this.image,
    required this.sliceInsets,
    required this.tileCenter,
    required this.tileCenterInsets,
  });

  final ui.Image image;
  final EdgeInsets sliceInsets;
  final bool tileCenter;
  final EdgeInsets tileCenterInsets;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final left = sliceInsets.left;
    final top = sliceInsets.top;
    final right = sliceInsets.right;
    final bottom = sliceInsets.bottom;

    final srcWidth = image.width.toDouble();
    final srcHeight = image.height.toDouble();

    final centerWidth = (srcWidth - left - right).clamp(1.0, srcWidth);
    final centerHeight = (srcHeight - top - bottom).clamp(1.0, srcHeight);

    final srcCenter = Rect.fromLTWH(left, top, centerWidth, centerHeight);
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);

    // First, draw a normal 9-slice so edges are preserved and center is stretched.
    canvas.drawImageNine(
      image,
      srcCenter,
      dst,
      Paint()..filterQuality = FilterQuality.high,
    );

    if (!tileCenter) {
      return;
    }

    final paint = Paint()..filterQuality = FilterQuality.high;

    final dstCenter = Rect.fromLTWH(
      left,
      top,
      size.width - left - right,
      size.height - top - bottom,
    );

    if (dstCenter.width <= 1 || dstCenter.height <= 1) return;

    // Inner center to tile (avoid tiling near left/right/top/bottom edges).
    final innerLeft = tileCenterInsets.left;
    final innerTop = tileCenterInsets.top;
    final innerRight = tileCenterInsets.right;
    final innerBottom = tileCenterInsets.bottom;

    final tileSrcWidth =
        (centerWidth - innerLeft - innerRight).clamp(1.0, centerWidth);
    final tileSrcHeight =
        (centerHeight - innerTop - innerBottom).clamp(1.0, centerHeight);

    final srcTile = Rect.fromLTWH(
      srcCenter.left + innerLeft,
      srcCenter.top + innerTop,
      tileSrcWidth,
      tileSrcHeight,
    );

    final dstTile = Rect.fromLTWH(
      dstCenter.left + innerLeft,
      dstCenter.top + innerTop,
      (dstCenter.width - innerLeft - innerRight).clamp(1.0, dstCenter.width),
      (dstCenter.height - innerTop - innerBottom).clamp(1.0, dstCenter.height),
    );

    if (dstTile.width <= 1 || dstTile.height <= 1) return;

    final tileW = srcTile.width;
    final tileH = srcTile.height;

    for (double y = dstTile.top; y < dstTile.bottom; y += tileH) {
      for (double x = dstTile.left; x < dstTile.right; x += tileW) {
        final w = (x + tileW <= dstTile.right) ? tileW : (dstTile.right - x);
        final h = (y + tileH <= dstTile.bottom) ? tileH : (dstTile.bottom - y);
        final src = Rect.fromLTWH(srcTile.left, srcTile.top, w, h);
        final dstRect = Rect.fromLTWH(x, y, w, h);
        canvas.drawImageRect(image, src, dstRect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NineSlicePainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.sliceInsets != sliceInsets ||
        oldDelegate.tileCenter != tileCenter ||
        oldDelegate.tileCenterInsets != tileCenterInsets;
  }
}
