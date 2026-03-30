import 'package:cab_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;
 
  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.radius = 8,
  });
 
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base      = isDark ? AppColors.darkCard    : AppColors.lightBorder;
    final highlight = isDark ? AppColors.darkSurface : AppColors.lightBg2;
 
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
 
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(height: 16, width: double.infinity, radius: 6),
            const SizedBox(height: 8),
            SkeletonBox(height: 13, width: 200, radius: 6),
            const SizedBox(height: 8),
            SkeletonBox(height: 13, width: 140, radius: 6),
          ],
        ),
      ),
    );
  }
}