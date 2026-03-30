import 'package:cab_app/core/models/news.dart';
import 'package:cab_app/features/news/news_list_card.dart';
import 'package:cab_app/shared/widgets/divider.dart';
import 'package:cab_app/shared/widgets/empty.dart';
import 'package:cab_app/shared/widgets/error_view.dart';
import 'package:cab_app/shared/widgets/logo.dart';
import 'package:cab_app/shared/widgets/network_image.dart';
import 'package:cab_app/shared/widgets/section_header.dart';
import 'package:cab_app/shared/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
 
import '../../core/theme/app_theme.dart';
import '../../core/providers/news_provider.dart';
import '../../core/services/sanity_service.dart';
 
// ═════════════════════════════════════════════════════════════════════════════
//  NEWS LIST SCREEN
// ═════════════════════════════════════════════════════════════════════════════
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});
 
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}
 
class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchNews();
    });
  }
 
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const CabLogo(size: 26),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(height: 0.5, color: t.dividerColor),
        ),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, np, _) {
          if (np.loading) {
            return _buildSkeleton();
          }
          if (np.error != null) {
            return ErrorView(message: np.error!, onRetry: () => np.fetchNews());
          }
          if (np.articles.isEmpty) {
            return const EmptyState(
              icon: Icons.article_outlined,
              title: 'No news yet',
              subtitle: 'Check back soon for the latest updates',
            );
          }
 
          return RefreshIndicator(
            color: AppColors.yellow,
            onRefresh: () => np.fetchNews(),
            child: CustomScrollView(
              slivers: [
                // Featured article (first one)
                if (np.articles.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FeaturedNewsCard(article: np.articles.first),
                          const SizedBox(height: 24),
                          const SectionHeader(title: 'All News'),
                          const SizedBox(height: 4),
                          const YellowAccentDivider(),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),
                // Rest of articles
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final article = np.articles.skip(1).toList()[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: NewsListCard(article: article),
                        );
                      },
                      childCount: np.articles.length - 1,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
 
  Widget _buildSkeleton() => ListView.separated(
    padding: const EdgeInsets.all(16),
    itemCount: 5,
    separatorBuilder: (_, __) => const SizedBox(height: 12),
    itemBuilder: (_, i) {
      if (i == 0) return const SkeletonBox(height: 220, radius: 16);
      return const SkeletonCard();
    },
  );
}
 
// ─── Featured Card (hero) ─────────────────────────────────────────────────
class _FeaturedNewsCard extends StatelessWidget {
  final NewsModel article;
  const _FeaturedNewsCard({required this.article});
 
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return GestureDetector(
      onTap: () => context.push('/news/${article.id}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            color: t.colorScheme.surfaceVariant,
            border: Border.all(color: t.dividerColor, width: 0.5),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (article.imageRef != null)
                CabNetworkImage(
                  url: SanityService.imageUrl(article.imageRef!, width: 800),
                  fit: BoxFit.cover,
                ),
              // Bottom gradient overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                    stops: [0.4, 1.0],
                  ),
                ),
              ),
              // Text content
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.publishedAt != null)
                        Text(
                          DateFormat('d MMM yyyy').format(article.publishedAt!),
                          style: const TextStyle(
                            fontFamily: 'Inter', fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.yellow,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontFamily: 'Rajdhani', fontSize: 20,
                          fontWeight: FontWeight.w700, color: AppColors.white,
                          height: 1.2,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              // FEATURED tag
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'FEATURED',
                    style: TextStyle(
                      fontFamily: 'Rajdhani', fontSize: 11,
                      fontWeight: FontWeight.w700, color: AppColors.black,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}