import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/utils/responsive.dart';

/// Network image with disk/memory cache and a lightweight placeholder.
class CachedAppImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CachedAppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return _placeholder();
    }

    final memWidth = _memCacheWidth(context);

    Widget image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: memWidth,
      placeholder: (_, __) => _placeholder(),
      errorWidget: (_, __, ___) => _placeholder(
        child: const Icon(Icons.broken_image, color: Colors.white54),
      ),
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  /// Picks a safe pixel width for memory cache (avoids Infinity/NaN).
  int? _memCacheWidth(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    double logicalWidth;

    if (width != null && width!.isFinite && width! > 0) {
      logicalWidth = width!;
    } else {
      logicalWidth = Responsive.contentWidth(context);
    }

    final pixels = logicalWidth * dpr;
    if (!pixels.isFinite || pixels <= 0) return null;

    return pixels.round();
  }

  Widget _placeholder({Widget? child}) {
    return Container(
      width: width,
      height: height,
      color: Colors.white10,
      alignment: Alignment.center,
      child: child ??
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
    );
  }
}
