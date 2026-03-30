import 'package:cab_app/core/theme/app_theme.dart';
import 'package:cab_app/shared/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class CabNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
 
  const CabNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });
 
  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => SkeletonBox(
        width: width,
        height: height ?? 120,
        radius: 0,
      ),
      errorWidget: (context, url, err) => Container(
        width: width,
        height: height ?? 120,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: const Icon(Icons.broken_image_outlined, color: AppColors.darkTextSec),
      ),
    );
 
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}