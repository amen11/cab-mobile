import 'package:cab_app/shared/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const CabLogo(size: 26),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(height: 0.5, color: t.dividerColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App header card ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.shield, color: AppColors.black, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CAB App',
                          style: TextStyle(
                            fontFamily: 'Rajdhani', fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        const Text(
                          'Club Athlétique Bizertin',
                          style: TextStyle(
                            fontFamily: 'Inter', fontSize: 12,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'v1.0.0',
                            style: TextStyle(
                              fontFamily: 'Inter', fontSize: 10,
                              color: AppColors.black, fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Appearance ─────────────────────────────────────────
            _SettingsSection(
              title: 'Appearance',
              children: [
                _SettingsThemeTile(
                  isDark: themeProvider.isDark,
                  onToggle: themeProvider.toggleTheme,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Notifications ──────────────────────────────────────
            _SettingsSection(
              title: 'Notifications',
              children: [
                _SettingsSwitchTile(
                  icon: Icons.sports_soccer_outlined,
                  label: 'Match updates',
                  subtitle: 'Score, lineup & gate changes',
                  value: true,
                  onChanged: (_) {},
                ),
                _SettingsSwitchTile(
                  icon: Icons.confirmation_number_outlined,
                  label: 'Ticket availability',
                  subtitle: 'Get notified when tickets go on sale',
                  value: true,
                  onChanged: (_) {},
                ),
                _SettingsSwitchTile(
                  icon: Icons.storefront_outlined,
                  label: 'New products',
                  subtitle: 'Shop announcements and offers',
                  value: false,
                  onChanged: (_) {},
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ── About ──────────────────────────────────────────────
            _SettingsSection(
              title: 'About',
              children: [
                _SettingsNavTile(
                  icon: Icons.info_outline,
                  label: 'About CAB',
                  onTap: () => _showAbout(context),
                ),
                _SettingsNavTile(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Privacy Policy',
                  onTap: () {},
                ),
                _SettingsNavTile(
                  icon: Icons.description_outlined,
                  label: 'Terms of Service',
                  onTap: () {},
                ),
                _SettingsNavTile(
                  icon: Icons.star_outline_rounded,
                  label: 'Rate the App',
                  onTap: () {},
                ),
                _SettingsNavTile(
                  icon: Icons.mail_outline,
                  label: 'Contact Us',
                  onTap: () {},
                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Footer
            Center(
              child: Column(
                children: [
                  const Text(
                    'CAB App',
                    style: TextStyle(
                      fontFamily: 'Rajdhani', fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkTextSec,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Made with passion for CAB fans',
                    style: t.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '© 2024 Club Athlétique Bizertin',
                    style: t.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AboutSheet(),
    );
  }
}

// ─── Section container ────────────────────────────────────────────────────
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Inter', fontSize: 11,
              fontWeight: FontWeight.w600,
              color: t.colorScheme.onSurface.withOpacity(0.45),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: t.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: t.dividerColor, width: 0.5),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

// ─── Theme Tile ───────────────────────────────────────────────────────────
class _SettingsThemeTile extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const _SettingsThemeTile({required this.isDark, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF242424)
                  : const Color(0xFFFFF9C4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              size: 18,
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dark Mode', style: t.textTheme.titleMedium),
                Text(
                  isDark ? 'Currently dark' : 'Currently light',
                  style: t.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Switch(value: isDark, onChanged: (_) => onToggle()),
        ],
      ),
    );
  }
}

// ─── Switch Tile ──────────────────────────────────────────────────────────
class _SettingsSwitchTile extends StatefulWidget {
  final IconData icon;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon, required this.label, required this.subtitle,
    required this.value, required this.onChanged,
  });

  @override
  State<_SettingsSwitchTile> createState() => _SettingsSwitchTileState();
}

class _SettingsSwitchTileState extends State<_SettingsSwitchTile> {
  late bool _val;

  @override
  void initState() {
    super.initState();
    _val = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: t.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(widget.icon, size: 18, color: t.colorScheme.onSurface),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.label, style: t.textTheme.titleMedium),
                    Text(widget.subtitle, style: t.textTheme.bodySmall),
                  ],
                ),
              ),
              Switch(
                value: _val,
                onChanged: (v) {
                  setState(() => _val = v);
                  widget.onChanged(v);
                },
              ),
            ],
          ),
        ),
        Divider(height: 1, indent: 64, color: t.dividerColor),
      ],
    );
  }
}

// ─── Nav Tile ─────────────────────────────────────────────────────────────
class _SettingsNavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  const _SettingsNavTile({
    required this.icon, required this.label,
    required this.onTap, this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: showDivider
              ? BorderRadius.zero
              : const BorderRadius.vertical(bottom: Radius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: t.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: t.colorScheme.onSurface),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(label, style: t.textTheme.titleMedium)),
                Icon(Icons.chevron_right, size: 18,
                    color: t.colorScheme.onSurface.withOpacity(0.35)),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, indent: 64, color: t.dividerColor),
      ],
    );
  }
}

// ─── About Bottom Sheet ───────────────────────────────────────────────────
class _AboutSheet extends StatelessWidget {
  const _AboutSheet();

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
        children: [
          Container(width: 40, height: 4,
            decoration: BoxDecoration(
              color: t.dividerColor, borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.shield, color: AppColors.black, size: 36),
          ),
          const SizedBox(height: 16),
          Text('Club Athlétique Bizertin',
              style: t.textTheme.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            'Founded in Bizerte, Tunisia, CAB is one of the most historic football clubs in the country with multiple national championship titles.',
            style: t.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatChip(label: 'Founded', value: '1913'),
              _StatChip(label: 'City', value: 'Bizerte'),
              _StatChip(label: 'Stadium', value: 'Stade 15-Oct'),
            ],
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label, value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      children: [
        Text(value, style: TextStyle(
          fontFamily: 'Rajdhani', fontSize: 18, fontWeight: FontWeight.w700,
          color: t.colorScheme.onSurface,
        )),
        Text(label, style: t.textTheme.labelSmall),
      ],
    );
  }
}