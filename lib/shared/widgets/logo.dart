import 'package:cab_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
 
// ─────────────────────────────────────────────────────────────────────────────
//  CAB Logo Word Mark
// ─────────────────────────────────────────────────────────────────────────────
class CabLogo extends StatelessWidget {
  final double size;

  const CabLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logocab.png',
      height: size,
      fit: BoxFit.contain,
    );
  }
}