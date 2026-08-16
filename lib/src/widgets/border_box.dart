import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Called when a [WarcraftBorderBox] frame asset cannot be resolved.
typedef WarcraftAssetErrorCallback =
    void Function(Object error, StackTrace? stackTrace);

/// Renders [asset] as a 9-slice (or, with a zero top/bottom inset, a
/// horizontal 3-slice) frame around [child].
///
/// This is the package's shared image-frame primitive: pass
/// `sliceInsets: EdgeInsets.symmetric(horizontal: capWidth, vertical:
/// capHeight)`, matched to the source artwork's real corner/edge thickness
/// in pixels, to get a true 9-slice panel (used by [WarcraftInput],
/// [WarcraftTextarea], [WarcraftCard], [WarcraftButton], etc.) — a zero
/// inset on an axis instead stretches that whole axis uniformly, which
/// only looks right if the artwork has no border decoration to preserve
/// along it.
class WarcraftBorderBox extends StatefulWidget {
  /// Creates a 9-slice (or 3-slice) frame around [child] using [asset],
  /// sliced according to [sliceInsets].
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
    this.package = 'warcraft_flutter_components',
    this.filterQuality = FilterQuality.high,
    this.fallbackDecoration,
    this.onAssetError,
  }) : assert(asset.length > 0, 'asset cannot be empty');

  /// The package asset path of the frame image to slice and paint.
  final String asset;

  /// The edge insets (in source-image pixels) that define the fixed
  /// corner/edge caps versus the stretchable center of [asset].
  final EdgeInsets sliceInsets;

  /// The content rendered inside the frame.
  final Widget child;

  /// Padding applied between the frame and [child].
  final EdgeInsetsGeometry? padding;

  /// If set, clips the entire painted frame to this radius.
  final BorderRadius? borderRadius;

  /// If set, draws a [BoxDecoration] shadow behind the painted frame.
  final List<BoxShadow>? boxShadow;

  /// If set, aligns [child] within the padded content area instead of
  /// letting it fill the available space.
  final AlignmentGeometry? alignment;

  /// Whether the center slice is tiled at native resolution instead of
  /// being stretched to fill the available space.
  final bool tileCenter;

  /// Extra insets (in source-image pixels), applied on top of
  /// [sliceInsets], that shrink the region of the center slice used as the
  /// tile source and destination. Only takes effect when [tileCenter] is
  /// true; it lets the tiled pattern avoid bleeding into pixels near the
  /// stretched center's own edges.
  final EdgeInsets tileCenterInsets;

  /// Asset package containing [asset]. The default resolves this package's
  /// bundled frames; pass `null` to use an asset from the consuming app.
  final String? package;

  /// Sampling quality used while painting stretched and tiled slices.
  final FilterQuality filterQuality;

  /// Decoration shown behind [child] while the frame is loading or when a
  /// handled asset error leaves no image available.
  final Decoration? fallbackDecoration;

  /// Optional asset error handler. When absent, failures are reported through
  /// [FlutterError.reportError].
  final WarcraftAssetErrorCallback? onAssetError;

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
    if (oldWidget.asset != widget.asset ||
        oldWidget.package != widget.package) {
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
    final provider = AssetImage(widget.asset, package: widget.package);
    final stream = provider.resolve(createLocalImageConfiguration(context));

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
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => previous.dispose(),
          );
        }
      },
      onError: (exception, stackTrace) {
        final onAssetError = widget.onAssetError;
        if (onAssetError != null) {
          onAssetError(exception, stackTrace);
        } else {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: exception,
              stack: stackTrace,
              library: 'warcraft_flutter_components',
              context: ErrorDescription(
                'resolving WarcraftBorderBox asset ${widget.asset}',
              ),
            ),
          );
        }
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
    assert(_debugInsetsAreValid());
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
            filterQuality: widget.filterQuality,
          );

    final Widget painted = painter == null && widget.fallbackDecoration != null
        ? DecoratedBox(decoration: widget.fallbackDecoration!, child: content)
        : CustomPaint(painter: painter, child: content);

    final borderRadius = widget.borderRadius;
    final clipped = borderRadius == null
        ? painted
        : ClipRRect(borderRadius: borderRadius, child: painted);
    final boxShadow = widget.boxShadow;
    if (boxShadow == null) return clipped;

    // Keep elevation outside ClipRRect. Clipping the decorated shadow along
    // with the artwork would cut it off exactly at the frame boundary.
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: clipped,
    );
  }

  bool _debugInsetsAreValid() {
    assert(
      widget.sliceInsets.left >= 0 &&
          widget.sliceInsets.top >= 0 &&
          widget.sliceInsets.right >= 0 &&
          widget.sliceInsets.bottom >= 0,
      'sliceInsets cannot contain negative values',
    );
    assert(
      widget.tileCenterInsets.left >= 0 &&
          widget.tileCenterInsets.top >= 0 &&
          widget.tileCenterInsets.right >= 0 &&
          widget.tileCenterInsets.bottom >= 0,
      'tileCenterInsets cannot contain negative values',
    );
    return true;
  }
}

class _NineSlicePainter extends CustomPainter {
  _NineSlicePainter({
    required this.image,
    required this.sliceInsets,
    required this.tileCenter,
    required this.tileCenterInsets,
    required this.filterQuality,
  });

  final ui.Image image;
  final EdgeInsets sliceInsets;
  final bool tileCenter;
  final EdgeInsets tileCenterInsets;
  final FilterQuality filterQuality;

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
      Paint()..filterQuality = filterQuality,
    );

    if (!tileCenter) {
      return;
    }

    final paint = Paint()..filterQuality = filterQuality;

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

    final tileSrcWidth = (centerWidth - innerLeft - innerRight).clamp(
      1.0,
      centerWidth,
    );
    final tileSrcHeight = (centerHeight - innerTop - innerBottom).clamp(
      1.0,
      centerHeight,
    );

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
        oldDelegate.tileCenterInsets != tileCenterInsets ||
        oldDelegate.filterQuality != filterQuality;
  }
}
