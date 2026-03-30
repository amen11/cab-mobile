import 'package:cab_app/core/models/match.dart';
import 'package:cab_app/core/providers/match_provider.dart';
import 'package:cab_app/core/theme/app_theme.dart';
import 'package:cab_app/shared/widgets/divider.dart';
import 'package:cab_app/shared/widgets/error_view.dart';
import 'package:cab_app/shared/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MatchDetailScreen extends StatelessWidget {
  final String matchId;
  const MatchDetailScreen({super.key, required this.matchId});
 
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final match = context.read<MatchProvider>().findById(matchId);
 
    if (match == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Match')),
        body: const ErrorView(message: 'Match not found'),
      );
    }
 
    final isFinished = match.status == 'finished';
 
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'CAB vs ${match.opponent}',
          style: t.textTheme.headlineSmall,
        ),
        actions: [
          TextButton(
            onPressed: () => context.go('/tickets'),
            child: const Text('TICKETS'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero score section ───────────────────────────────────
            Container(
              width: double.infinity,
              color: t.colorScheme.surface,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
              child: Column(
                children: [
                  StatusBadge(status: match.status),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // CAB
                      _TeamBlock(
                        name: 'CAB',
                        isHome: match.isHome,
                        isCAB: true,
                      ),
                      const SizedBox(width: 24),
                      // Score
                      if (isFinished && match.scoreCAB != null)
                        Text(
                          '${match.scoreCAB}   –   ${match.scoreOpponent}',
                          style: TextStyle(
                            fontFamily: 'Rajdhani', fontSize: 44,
                            fontWeight: FontWeight.w700,
                            color: t.colorScheme.onSurface,
                          ),
                        )
                      else
                        Column(
                          children: [
                            Text(
                              'VS',
                              style: TextStyle(
                                fontFamily: 'Rajdhani', fontSize: 36,
                                fontWeight: FontWeight.w600,
                                color: t.colorScheme.onSurface.withOpacity(0.25),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(width: 24),
                      // Opponent
                      _TeamBlock(name: match.opponent, isHome: !match.isHome),
                    ],
                  ),
                ],
              ),
            ),
 
            Divider(height: 1, color: t.dividerColor),
 
            // ── Info section ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Match Info', style: t.textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  const YellowAccentDivider(),
                  const SizedBox(height: 16),
                  _InfoRow(icon: Icons.calendar_today_outlined, label: 'Date',
                      value: DateFormat('EEEE, d MMMM yyyy').format(match.date)),
                  _InfoRow(icon: Icons.access_time_outlined, label: 'Kick-off',
                      value: DateFormat('HH:mm').format(match.date)),
                  if (match.stadium != null)
                    _InfoRow(icon: Icons.location_on_outlined, label: 'Stadium',
                        value: match.stadium!),
                  if (match.competition != null)
                    _InfoRow(icon: Icons.emoji_events_outlined, label: 'Competition',
                        value: match.competition!),
                  _InfoRow(
                    icon: Icons.home_outlined,
                    label: 'Venue',
                    value: match.isHome ? 'Home game' : 'Away game',
                  ),
                  const SizedBox(height: 24),
                  if (match.status == 'upcoming')
                    ElevatedButton.icon(
                      onPressed: () => context.go('/tickets'),
                      icon: const Icon(Icons.confirmation_number_outlined, size: 18),
                      label: const Text('BUY TICKETS'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
class _TeamBlock extends StatelessWidget {
  final String name;
  final bool isHome;
  final bool isCAB;
 
  const _TeamBlock({required this.name, required this.isHome, this.isCAB = false});
 
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: isCAB ? AppColors.yellowSurface : t.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCAB ? AppColors.yellow.withOpacity(0.4) : t.dividerColor,
            ),
          ),
          child: Icon(
            isCAB ? Icons.shield : Icons.shield_outlined,
            size: 32,
            color: isCAB ? AppColors.yellow : AppColors.darkTextSec,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            name,
            style: t.textTheme.titleMedium,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(isHome ? 'Home' : 'Away', style: t.textTheme.bodySmall),
      ],
    );
  }
}
 
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
 
  const _InfoRow({required this.icon, required this.label, required this.value});
 
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: t.colorScheme.primary),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(label, style: t.textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(
              value,
              style: t.textTheme.titleSmall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
 
// Extension on MatchProvider
extension MatchProviderX on MatchProvider {
  MatchModel? findById(String id) {
    final all = [...upcoming, ...past];
    try { return all.firstWhere((m) => m.id == id); }
    catch (_) { return null; }
  }
}