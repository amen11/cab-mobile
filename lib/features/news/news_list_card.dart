import 'package:cab_app/core/models/news.dart';
import 'package:cab_app/core/providers/news_provider.dart';
import 'package:cab_app/core/services/sanity_service.dart';
import 'package:cab_app/core/theme/app_theme.dart';
import 'package:cab_app/shared/widgets/error_view.dart';
import 'package:cab_app/shared/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewsListCard extends StatelessWidget {
  final NewsModel article;
  const NewsListCard({required this.article});
 
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return GestureDetector(
      onTap: () => context.push('/news/${article.id}'),
      child: Card(
        child: Row(
          children: [
            if (article.imageRef != null)
              CabNetworkImage(
                url: SanityService.imageUrl(article.imageRef!, width: 200),
                width: 96, height: 96,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              )
            else
              Container(
                width: 96, height: 96,
                color: AppColors.yellowSurface,
                child: const Icon(Icons.article, color: AppColors.yellow, size: 28),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article.publishedAt != null)
                      Text(
                        DateFormat('d MMM yyyy').format(article.publishedAt!),
                        style: TextStyle(
                          fontFamily: 'Inter', fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: t.colorScheme.primary,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      article.title,
                      style: t.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (article.summary != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        article.summary!,
                        style: t.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right, size: 18, color: AppColors.darkTextSec),
            ),
          ],
        ),
      ),
    );
  }
}
 
// ═════════════════════════════════════════════════════════════════════════════
//  NEWS DETAIL SCREEN
// ═════════════════════════════════════════════════════════════════════════════
class NewsDetailScreen extends StatelessWidget {
  final String newsId;
  const NewsDetailScreen({super.key, required this.newsId});
 
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final article = context.read<NewsProvider>().articles
        .where((a) => a.id == newsId)
        .firstOrNull;
 
    if (article == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const ErrorView(message: 'Article not found'),
      );
    }
 
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Sliver App Bar with image ──────────────────────────────
          SliverAppBar(
            expandedHeight: article.imageRef != null ? 280 : 120,
            pinned: true,
            backgroundColor: t.scaffoldBackgroundColor,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white, size: 20),
                onPressed: () => context.pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: article.imageRef != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        CabNetworkImage(
                          url: SanityService.imageUrl(article.imageRef!, width: 1000),
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                              stops: [0.5, 1.0],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(color: t.colorScheme.surfaceVariant),
            ),
          ),
 
          // ── Article content ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.publishedAt != null) ...[
                    Row(
                      children: [
                        Container(
                          width: 3, height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('EEEE, d MMMM yyyy').format(article.publishedAt!),
                          style: TextStyle(
                            fontFamily: 'Inter', fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: t.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],
                  Text(article.title, style: t.textTheme.headlineLarge),
                  if (article.summary != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      article.summary!,
                      style: t.textTheme.bodyLarge?.copyWith(
                        color: t.colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Divider(color: t.dividerColor),
                  const SizedBox(height: 20),
                  // Portable text / body content
                  if (article.content != null)
                    _PortableTextRenderer(blocks: article.content!)
                  else
                    Text(
                      'Full article content coming soon.',
                      style: t.textTheme.bodyLarge,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 
// Simple Portable Text renderer (Sanity block content)
class _PortableTextRenderer extends StatelessWidget {
  final List<dynamic> blocks;
  const _PortableTextRenderer({required this.blocks});
 
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map<Widget>((block) {
        if (block['_type'] != 'block') return const SizedBox.shrink();
 
        final style = block['style'] as String? ?? 'normal';
        final spans = (block['children'] as List<dynamic>? ?? []);
        final text = spans.map((s) => s['text'] as String? ?? '').join();
 
        TextStyle? textStyle;
        EdgeInsets? padding;
 
        switch (style) {
          case 'h1':
            textStyle = t.textTheme.headlineLarge;
            padding = const EdgeInsets.only(top: 20, bottom: 8);
            break;
          case 'h2':
            textStyle = t.textTheme.headlineMedium;
            padding = const EdgeInsets.only(top: 16, bottom: 6);
            break;
          case 'h3':
            textStyle = t.textTheme.headlineSmall;
            padding = const EdgeInsets.only(top: 12, bottom: 6);
            break;
          case 'blockquote':
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppColors.yellow, width: 3),
                  ),
                  color: AppColors.yellowSurface,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  text,
                  style: t.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            );
          default:
            textStyle = t.textTheme.bodyLarge;
            padding = const EdgeInsets.only(bottom: 12);
        }
 
        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Text(text, style: textStyle),
        );
      }).toList(),
    );
  }
}