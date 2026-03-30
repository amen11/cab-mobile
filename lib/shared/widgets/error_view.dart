import 'package:cab_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
 
  const ErrorView({super.key, required this.message, this.onRetry});
 
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48,
                color: t.colorScheme.onSurface.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('Something went wrong', style: t.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(message, style: t.textTheme.bodySmall, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: 140,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(140, 44)),
                  child: const Text('Retry'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}