import 'package:cab_app/core/models/match.dart';
import 'package:cab_app/core/models/ticket.dart';
import 'package:cab_app/shared/widgets/divider.dart';
import 'package:cab_app/shared/widgets/empty.dart';
import 'package:cab_app/shared/widgets/error_view.dart';
import 'package:cab_app/shared/widgets/logo.dart';
import 'package:cab_app/shared/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/providers/ticket_provider.dart';
import '../../core/providers/match_provider.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketProvider>().fetchTickets();
      context.read<MatchProvider>().fetchMatches();
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
      body: Consumer2<TicketProvider, MatchProvider>(
        builder: (context, tp, mp, _) {
          if (tp.loading || mp.loading) {
            return _buildSkeleton();
          }
          if (tp.error != null) {
            return ErrorView(message: tp.error!, onRetry: () => tp.fetchTickets());
          }

          // Group tickets by match
          final upcomingWithTickets = mp.upcoming
              .where((m) => tp.ticketsForMatch(m.id).isNotEmpty)
              .toList();

          if (upcomingWithTickets.isEmpty) {
            return const EmptyState(
              icon: Icons.confirmation_number_outlined,
              title: 'No tickets available',
              subtitle: 'Tickets will appear here when they go on sale',
            );
          }

          return RefreshIndicator(
            color: AppColors.yellow,
            onRefresh: () async {
              await Future.wait([
                tp.fetchTickets(),
                mp.fetchMatches(),
              ]);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: upcomingWithTickets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (_, i) {
                final match = upcomingWithTickets[i];
                final tickets = tp.ticketsForMatch(match.id);
                return _MatchTicketSection(match: match, tickets: tickets);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeleton() => ListView.separated(
    padding: const EdgeInsets.all(16),
    itemCount: 2,
    separatorBuilder: (_, __) => const SizedBox(height: 20),
    itemBuilder: (_, __) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SkeletonBox(height: 20, width: 200),
        const SizedBox(height: 12),
        ...List.generate(3, (_) => const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: SkeletonBox(height: 110),
        )),
      ],
    ),
  );
}

// ─── Match Ticket Section ─────────────────────────────────────────────────
class _MatchTicketSection extends StatelessWidget {
  final MatchModel match;
  final List<TicketModel> tickets;

  const _MatchTicketSection({required this.match, required this.tickets});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Match Header
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: t.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: t.dividerColor, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.yellowSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.sports_soccer, color: AppColors.yellow, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CAB vs ${match.opponent}',
                      style: t.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          DateFormat('EEE d MMM · HH:mm').format(match.date),
                          style: t.textTheme.bodySmall,
                        ),
                        if (match.stadium != null) ...[
                          Text(' · ', style: t.textTheme.bodySmall),
                          Expanded(
                            child: Text(
                              match.stadium!,
                              style: t.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Ticket cards
        ...tickets.asMap().entries.map((entry) {
          final idx = entry.key;
          final ticket = entry.value;
          final isLast = idx == tickets.length - 1;
          return _TicketCard(ticket: ticket, isLast: isLast, match: match);
        }),
      ],
    );
  }
}

// ─── Ticket Card ──────────────────────────────────────────────────────────
class _TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final bool isLast;
  final MatchModel match;

  const _TicketCard({
    required this.ticket,
    required this.isLast,
    required this.match,
  });

  Color _typeColor() {
    switch (ticket.type) {
      case 'tribune': return AppColors.yellow;
      case 'pelouse': return AppColors.info;
      case 'virage':  return AppColors.success;
      default:        return AppColors.darkTextSec;
    }
  }

  Color _typeSurface() {
    switch (ticket.type) {
      case 'tribune': return AppColors.yellowSurface;
      case 'pelouse': return AppColors.infoSurface;
      case 'virage':  return AppColors.successSurface;
      default:        return const Color(0x1A8A8A8A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: t.colorScheme.surface,
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(12))
            : BorderRadius.zero,
        border: Border(
          left: const BorderSide(color: AppColors.darkBorder, width: 0.5),
          right: const BorderSide(color: AppColors.darkBorder, width: 0.5),
          bottom: BorderSide(
            color: t.dividerColor, width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          // Dashed ticket separator
          Row(
            children: [
              Container(width: 16, height: 16,
                decoration: BoxDecoration(
                  color: t.scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: t.dividerColor, width: 0.5),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final dashes = (constraints.maxWidth / 8).floor();
                    return Row(
                      children: List.generate(dashes, (i) => Expanded(
                        child: Container(
                          height: 1,
                          color: i.isEven ? t.dividerColor : Colors.transparent,
                        ),
                      )),
                    );
                  },
                ),
              ),
              Container(width: 16, height: 16,
                decoration: BoxDecoration(
                  color: t.scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: t.dividerColor, width: 0.5),
                ),
              ),
            ],
          ),
          // Ticket content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _typeSurface(),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _typeColor().withOpacity(0.3)),
                      ),
                      child: Text(
                        ticket.type.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Rajdhani', fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _typeColor(), letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${ticket.price.toStringAsFixed(0)} TND',
                          style: TextStyle(
                            fontFamily: 'Rajdhani', fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: t.colorScheme.onSurface,
                          ),
                        ),
                        Text('per ticket', style: t.textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Gate + instructions
                if (ticket.gate != null || ticket.instructions != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: t.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (ticket.gate != null)
                          Row(
                            children: [
                              const Icon(Icons.door_sliding_outlined,
                                  size: 14, color: AppColors.darkTextSec),
                              const SizedBox(width: 6),
                              Text(
                                'Gate: ${ticket.gate}',
                                style: TextStyle(
                                  fontFamily: 'Inter', fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: t.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        if (ticket.gate != null && ticket.instructions != null)
                          const SizedBox(height: 6),
                        if (ticket.instructions != null)
                          Text(
                            ticket.instructions!,
                            style: t.textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                // CTA
                SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () => _showTicketInfo(context, ticket, match),
                    icon: const Icon(Icons.confirmation_number_outlined, size: 16),
                    label: const Text('GET TICKET INFO'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTicketInfo(BuildContext context, TicketModel ticket, MatchModel match) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TicketInfoSheet(ticket: ticket, match: match),
    );
  }
}

// ─── Ticket Info Bottom Sheet ─────────────────────────────────────────────
class _TicketInfoSheet extends StatelessWidget {
  final TicketModel ticket;
  final MatchModel match;

  const _TicketInfoSheet({required this.ticket, required this.match});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: t.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: t.dividerColor, width: 0.5),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: t.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Ticket Information', style: t.textTheme.headlineSmall),
          const SizedBox(height: 4),
          const YellowAccentDivider(),
          const SizedBox(height: 20),

          // Match
          _SheetRow(label: 'Match', value: 'CAB vs ${match.opponent}'),
          _SheetRow(
            label: 'Date',
            value: DateFormat('EEE d MMM yyyy · HH:mm').format(match.date),
          ),
          _SheetRow(label: 'Type', value: ticket.type.toUpperCase()),
          _SheetRow(label: 'Price', value: '${ticket.price.toStringAsFixed(0)} TND'),
          if (ticket.gate != null)
            _SheetRow(label: 'Gate', value: ticket.gate!),
          if (match.stadium != null)
            _SheetRow(label: 'Stadium', value: match.stadium!),
          if (ticket.instructions != null) ...[
            const SizedBox(height: 16),
            Text('Instructions', style: t.textTheme.titleMedium),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: t.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(ticket.instructions!, style: t.textTheme.bodyMedium),
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  final String label, value;
  const _SheetRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: t.textTheme.bodyMedium),
          Text(value, style: t.textTheme.titleSmall),
        ],
      ),
    );
  }
}