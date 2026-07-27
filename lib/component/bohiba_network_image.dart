import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/extensions/bohiba_extension.dart';
import '/theme/bohiba_theme.dart';

/// A drop-in [CachedNetworkImage] wrapper that:
/// - Shows a shimmer-colored placeholder while loading.
/// - On any error (404, network, null URL), falls back to the first letters
///   of [fallbackText] via String.shortCode (e.g. "John Doe" → "JD").
/// - Clips to a circle when [shape] == [BoxShape.circle], otherwise clips
///   with [borderRadius].
///
/// Callers never need to write errorWidget/placeholder logic again.
class BohibaNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  /// Text whose initials are shown when the image is absent or fails.
  final String? fallbackText;
  final bool applyShortCode;

  final BoxShape shape;
  final BorderRadius borderRadius;

  const BohibaNetworkImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.fallbackText,
    this.applyShortCode = true,
    this.shape = BoxShape.rectangle,
    this.borderRadius = BorderRadius.zero,
  });

  /// Convenience constructor for circular avatars.
  const BohibaNetworkImage.circle({
    super.key,
    required this.imageUrl,
    required double size,
    this.fallbackText,
    this.applyShortCode = true,
    this.fit = BoxFit.cover,
  })  : width = size,
        height = size,
        shape = BoxShape.circle,
        borderRadius = BorderRadius.zero;

  /// Convenience constructor for rounded-rectangle images.
  // ignore: prefer_const_constructors_in_immutables
  BohibaNetworkImage.rounded({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    double radius = 8,
    this.fallbackText,
    this.applyShortCode = true,
    this.fit = BoxFit.cover,
  })  : shape = BoxShape.rectangle,
        borderRadius = BorderRadius.all(Radius.circular(radius));

  bool get _hasUrl => imageUrl != null && imageUrl!.isNotEmpty;

  Widget _fallback(BoxConstraints? c) {
    final String? code =
        applyShortCode == true ? fallbackText?.shortCode : fallbackText;
    final sz = (c != null ? c.maxWidth : width);
    final fontSize = (sz * 0.20).clamp(10.0, 36.0);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bohibaTheme.canvasColor,
        shape: shape,
        border: Border.all(width: 1.0, color: bohibaTheme.dividerColor),
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        code ?? '',
        textAlign: TextAlign.center,
        maxLines: 1,
        style: TextStyle(
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w600,
          color: bohibaTheme.textTheme.bodySmall?.color,
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bohibaTheme.cardColor,
        shape: shape,
        border: Border.all(width: 1.0, color: bohibaTheme.dividerColor),
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasUrl) return _fallback(null);

    Widget image = DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => _placeholder(),
        errorWidget: (_, __, ___) => _fallback(null),
      ),
    );

    if (shape == BoxShape.circle) {
      return ClipOval(child: image);
    }
    if (borderRadius != BorderRadius.zero) {
      return ClipRRect(borderRadius: borderRadius, child: image);
    }
    return image;
  }
}
