import 'package:cab_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class YellowAccentDivider extends StatelessWidget {
  final double width;
  const YellowAccentDivider({super.key, this.width = 32});
 
  @override
  Widget build(BuildContext context) => Container(
    width: width, height: 3,
    decoration: BoxDecoration(
      color: AppColors.yellow,
      borderRadius: BorderRadius.circular(2),
    ),
  );
}