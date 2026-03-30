import 'package:cab_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
 
// ─────────────────────────────────────────────────────────────────────────────
//  CAB Logo Word Mark
// ─────────────────────────────────────────────────────────────────────────────
class CabLogo extends StatelessWidget {
  final double size;
  const CabLogo({super.key, this.size = 24});
 
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'CAB',
          style: TextStyle(
            fontFamily: 'Rajdhani', fontSize: size,
            fontWeight: FontWeight.w700, color: AppColors.yellow,
            letterSpacing: 0.5,
          ),
        ),
        TextSpan(
          text: ' App',
          style: TextStyle(
            fontFamily: 'Rajdhani', fontSize: size,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.white : AppColors.black,
          ),
        ),
      ]),
    );
  }
}