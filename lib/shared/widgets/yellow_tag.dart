import 'package:cab_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class YellowTag extends StatelessWidget {
  final String text;
  const YellowTag({super.key, required this.text});
 
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: AppColors.yellow,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Rajdhani', fontSize: 11,
        fontWeight: FontWeight.w700, color: AppColors.black,
      ),
    ),
  );
}