import 'package:cab_app/core/models/match.dart';
import 'package:cab_app/core/models/news.dart';
import 'package:cab_app/shared/widgets/divider.dart';
import 'package:cab_app/shared/widgets/empty.dart';
import 'package:cab_app/shared/widgets/error_view.dart';
import 'package:cab_app/shared/widgets/logo.dart';
import 'package:cab_app/shared/widgets/network_image.dart';
import 'package:cab_app/shared/widgets/section_header.dart';
import 'package:cab_app/shared/widgets/shimmer.dart';
import 'package:cab_app/shared/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/providers/match_provider.dart';
import '../../core/providers/news_provider.dart';
import '../../core/services/sanity_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchProvider>().fetchMatches();
      context.read<NewsProvider>().fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const CabLogo(size: 26),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(height: 0.5, thickness: 0.5, color: t.dividerColor),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.yellow,
        backgroundColor: t.colorScheme.surface,
        onRefresh: () async {
          await Future.wait([
            context.read<MatchProvider>().fetchMatches(),
            context.read<NewsProvider>().fetchNews(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // ── Next Match Banner ──────────────────────────────────
              const _NextMatchBanner(),
              const SizedBox(height: 28),

              // ── Quick Stats ───────────────────────────────────────
              const _QuickStats(),
              const SizedBox(height: 28),

              // ── Latest News ───────────────────────────────────────
              SectionHeader(
                title: 'Latest News',
                actionLabel: 'See all',
                onAction: () => context.go('/news'),
              ),
              const SizedBox(height: 4),
              const YellowAccentDivider(),
              const SizedBox(height: 14),
              const _HomeNewsList(),
              const SizedBox(height: 28),

              // ── Upcoming Matches ──────────────────────────────────
              SectionHeader(
                title: 'Upcoming Matches',
                actionLabel: 'See all',
                onAction: () => context.go('/matches'),
              ),
              const SizedBox(height: 4),
              const YellowAccentDivider(),
              const SizedBox(height: 14),
              const _HomeMatchList(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Next Match Banner ─────────────────────────────────────────────────────
class _NextMatchBanner extends StatelessWidget {
  const _NextMatchBanner();

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, mp, _) {
        if (mp.loading) {
          return const SkeletonBox(height: 170, radius: 16);
        }
        if (mp.nextMatch == null) {
          return Container(
            height: 130,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor, width: 0.5),
            ),
            child: const Center(
              child: Text('No upcoming matches', style: TextStyle(fontFamily: 'Inter', color: AppColors.darkTextSec)),
            ),
          );
        }

        final match = mp.nextMatch!;
        final daysUntil = match.date.difference(DateTime.now()).inDays;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.yellow,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'NEXT MATCH',
                      style: const TextStyle(
                        fontFamily: 'Rajdhani', fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black, letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  if (daysUntil >= 0)
                    Text(
                      daysUntil == 0 ? 'TODAY' : 'IN $daysUntil DAYS',
                      style: const TextStyle(
                        fontFamily: 'Rajdhani', fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black, letterSpacing: 1,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'CAB vs ${match.opponent}',
                style: const TextStyle(
                  fontFamily: 'Rajdhani', fontSize: 30,
                  fontWeight: FontWeight.w700, color: AppColors.black,
                ),
              ),
              if (match.competition != null) ...[
                const SizedBox(height: 4),
                Text(
                  match.competition!,
                  style: TextStyle(
                    fontFamily: 'Inter', fontSize: 12,
                    color: AppColors.black.withOpacity(0.65),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              const Divider(height: 1, color: Colors.black12),
              const SizedBox(height: 12),
              Row(
                children: [
                  _BannerInfo(
                    icon: Icons.calendar_today_outlined,
                    text: DateFormat('EEE d MMM').format(match.date),
                  ),
                  const SizedBox(width: 16),
                  _BannerInfo(
                    icon: Icons.access_time_outlined,
                    text: DateFormat('HH:mm').format(match.date),
                  ),
                  if (match.stadium != null) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: _BannerInfo(
                        icon: Icons.location_on_outlined,
                        text: match.stadium!,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BannerInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  const _BannerInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: AppColors.black),
      const SizedBox(width: 5),
      Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter', fontSize: 12,
          fontWeight: FontWeight.w500, color: AppColors.black,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

// ─── Quick Stats ──────────────────────────────────────────────────────────
class _QuickStats extends StatelessWidget {
  const _QuickStats();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    final stats = [
      _Stat(label: 'League Pos.', value: '4th'),
      _Stat(label: 'Points', value: '38'),
      _Stat(label: 'Won', value: '11'),
      _Stat(label: 'Drawn', value: '5'),
    ];

    return Row(
      children: stats.map((s) {
        final isLast = s == stats.last;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: isLast ? 0 : 8),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: t.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: t.dividerColor, width: 0.5),
            ),
            child: Column(
              children: [
                Text(
                  s.value,
                  style: TextStyle(
                    fontFamily: 'Rajdhani', fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: t.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  s.label,
                  style: TextStyle(
                    fontFamily: 'Inter', fontSize: 10,
                    color: isDark ? AppColors.darkTextSec : AppColors.lightTextSec,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Stat {
  final String label, value;
  const _Stat({required this.label, required this.value});
}

// ─── Home News List ──────────────────────────────────────────────────────
class _HomeNewsList extends StatelessWidget {
  const _HomeNewsList();

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, np, _) {
        if (np.loading) {
          return Column(
            children: List.generate(3, (_) => const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: SkeletonCard(),
            )),
          );
        }
        if (np.error != null) {
          return ErrorView(message: np.error!, onRetry: () => np.fetchNews());
        }
        if (np.articles.isEmpty) {
          return const EmptyState(icon: Icons.article_outlined, title: 'No news yet');
        }

        return Column(
          children: np.latest.map((article) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _NewsCardCompact(article: article),
          )).toList(),
        );
      },
    );
  }
}

class _NewsCardCompact extends StatelessWidget {
  final NewsModel article;
  const _NewsCardCompact({required this.article});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final hasImage = article.imageRef != null;

    return GestureDetector(
      onTap: () => context.push('/news/${article.id}'),
      child: Card(
        child: Row(
          children: [
            if (hasImage)
              CabNetworkImage(
                url: SanityService.imageUrl(article.imageRef!, width: 160),
                width: 90, height: 90,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              )
            else
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  color: AppColors.yellowSurface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
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

// ─── Home Match List ──────────────────────────────────────────────────────
class _HomeMatchList extends StatelessWidget {
  const _HomeMatchList();

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, mp, _) {
        if (mp.loading) {
          return Column(
            children: List.generate(3, (_) => const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: SkeletonCard(),
            )),
          );
        }
        if (mp.upcoming.isEmpty) {
          return const EmptyState(
            icon: Icons.sports_soccer,
            title: 'No upcoming matches',
          );
        }
        return Column(
          children: mp.upcoming.take(3).map((m) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _MatchRowCard(match: m),
          )).toList(),
        );
      },
    );
  }
}

class _MatchRowCard extends StatelessWidget {
  final MatchModel match;
  const _MatchRowCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return GestureDetector(
      onTap: () => context.push('/matches/${match.id}'),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppColors.yellowSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.sports_soccer, color: AppColors.yellow, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CAB vs ${match.opponent}',
                      style: t.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          DateFormat('EEE d MMM · HH:mm').format(match.date),
                          style: t.textTheme.bodySmall,
                        ),
                        if (match.competition != null) ...[
                          Text(' · ', style: t.textTheme.bodySmall),
                          Text(match.competition!, style: t.textTheme.bodySmall),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(status: match.status),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right, size: 18,
                  color: t.colorScheme.onSurface.withOpacity(0.3)),
            ],
          ),
        ),
      ),
    );
  }
}