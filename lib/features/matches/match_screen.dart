import 'package:cab_app/core/models/match.dart';
import 'package:cab_app/core/services/sanity_service.dart';
import 'package:cab_app/shared/widgets/empty.dart';
import 'package:cab_app/shared/widgets/error_view.dart';
import 'package:cab_app/shared/widgets/logo.dart';
import 'package:cab_app/shared/widgets/network_image.dart';
import 'package:cab_app/shared/widgets/shimmer.dart';
import 'package:cab_app/shared/widgets/status_badge.dart';
import 'package:cab_app/shared/widgets/yellow_tag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
 
import '../../core/theme/app_theme.dart';
import '../../core/providers/match_provider.dart';
 
// ═════════════════════════════════════════════════════════════════════════════
//  MATCHES SCREEN
// ═════════════════════════════════════════════════════════════════════════════
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});
 
  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}
 
class _MatchesScreenState extends State<MatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
 
  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchProvider>().fetchMatches();
    });
  }
 
  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const CabLogo(size: 26),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Column(
            children: [
              Divider(height: 0.5, thickness: 0.5, color: t.dividerColor),
              TabBar(
                controller: _tab,
                labelStyle: const TextStyle(
                  fontFamily: 'Rajdhani', fontSize: 14,
                  fontWeight: FontWeight.w700, letterSpacing: 0.5,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Rajdhani', fontSize: 14, fontWeight: FontWeight.w400,
                ),
                labelColor: t.colorScheme.primary,
                unselectedLabelColor: t.colorScheme.onSurface.withOpacity(0.5),
                indicatorColor: t.colorScheme.primary,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'UPCOMING'),
                  Tab(text: 'RESULTS'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Consumer<MatchProvider>(
        builder: (context, mp, _) {
          if (mp.loading) {
            return _buildSkeleton();
          }
          if (mp.error != null) {
            return ErrorView(message: mp.error!, onRetry: () => mp.fetchMatches());
          }
          return TabBarView(
            controller: _tab,
            children: [
              _MatchList(matches: mp.upcoming, emptyMessage: 'No upcoming matches scheduled'),
              _MatchList(matches: mp.past.reversed.toList(), emptyMessage: 'No results yet'),
            ],
          );
        },
      ),
    );
  }
 
  Widget _buildSkeleton() => ListView.separated(
    padding: const EdgeInsets.all(16),
    itemCount: 5,
    separatorBuilder: (_, __) => const SizedBox(height: 10),
    itemBuilder: (_, __) => const SkeletonBox(height: 90, radius: 12),
  );
}
 
class _MatchList extends StatelessWidget {
  final List<MatchModel> matches;
  final String emptyMessage;
 
  const _MatchList({required this.matches, required this.emptyMessage});
 
  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return EmptyState(
        icon: Icons.sports_soccer,
        title: emptyMessage,
        subtitle: 'Check back soon',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _MatchCard(match: matches[i]),
    );
  }
}
 
class _MatchCard extends StatelessWidget {
  final MatchModel match;
  const _MatchCard({required this.match});
 
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isFinished = match.status == 'finished';
 
    return GestureDetector(
      onTap: () => context.push('/matches/${match.id}'),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (match.competition != null)
                    YellowTag(text: match.competition!)
                  else
                    const SizedBox.shrink(),
                  StatusBadge(status: match.status),
                ],
              ),
              const SizedBox(height: 14),
              // Teams + Score row
              Row(
                children: [
                  // CAB side
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CabLogo(),
                        const SizedBox(height: 6),
                        Text('CAB', style: t.textTheme.titleLarge),
                        Text(match.isHome ? 'Home' : 'Away',
                            style: t.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  // Score / VS
                  Column(
                    children: [
                      if (isFinished && match.scoreCAB != null)
                        Text(
                          '${match.scoreCAB}  –  ${match.scoreOpponent}',
                          style: TextStyle(
                            fontFamily: 'Rajdhani', fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: t.colorScheme.onSurface,
                          ),
                        )
                      else
                        Text(
                          'VS',
                          style: TextStyle(
                            fontFamily: 'Rajdhani', fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: t.colorScheme.onSurface.withOpacity(0.35),
                          ),
                        ),
                    ],
                  ),
                  // Opponent side
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                       CabNetworkImage(url: SanityService.imageUrl(match.opponentLogoRef?? '', width: 80),
                          width: 60, height: 60, fit: BoxFit.contain),
                        const SizedBox(height: 6),
                        Text(match.opponent, style: t.textTheme.titleLarge,
                            textAlign: TextAlign.end, maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(match.isHome ? 'Away' : 'Home',
                            style: t.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(height: 1, color: t.dividerColor),
              const SizedBox(height: 10),
              // Date + Stadium
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 12,
                      color: t.colorScheme.onSurface.withOpacity(0.45)),
                  const SizedBox(width: 5),
                  Text(
                    DateFormat('EEE d MMM yyyy · HH:mm').format(match.date),
                    style: t.textTheme.bodySmall,
                  ),
                  if (match.stadium != null) ...[
                    Text('  ·  ', style: t.textTheme.bodySmall),
                    Icon(Icons.location_on_outlined, size: 12,
                        color: t.colorScheme.onSurface.withOpacity(0.45)),
                    const SizedBox(width: 4),
                    Text(match.stadium!, style: t.textTheme.bodySmall),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}