import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/threat_model.dart';
import '../widgets/stats_card.dart';
import '../widgets/threat_badge.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'tips_screen.dart';
import 'report_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<ThreatAnalysis> _history = [];

  void _addToHistory(ThreatAnalysis analysis) {
    setState(() {
      _history.insert(0, analysis);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _DashboardPage(history: _history, onScanTap: () => setState(() => _selectedIndex = 1)),
      ScanScreen(onAnalysisComplete: _addToHistory),
      HistoryScreen(history: _history),
      const TipsScreen(),
      const ReportScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: _buildNavBar(),
      // Settings accessible via AppBar action on dashboard
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        border: Border(top: BorderSide(color: Color(0xFF1E293B), width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.dashboard_rounded,
                label: 'Home',
                selected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _NavItem(
                icon: Icons.radar_rounded,
                label: 'Scan',
                selected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
                isPrimary: true,
              ),
              _NavItem(
                icon: Icons.history_rounded,
                label: 'History',
                selected: _selectedIndex == 2,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
              _NavItem(
                icon: Icons.lightbulb_rounded,
                label: 'Tips',
                selected: _selectedIndex == 3,
                onTap: () => setState(() => _selectedIndex = 3),
              ),
              _NavItem(
                icon: Icons.flag_rounded,
                label: 'Report',
                selected: _selectedIndex == 4,
                onTap: () => setState(() => _selectedIndex = 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isPrimary;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF00FF88)
                : const Color(0xFF00FF88).withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: const Color(0xFF00FF88).withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected ? const Color(0xFF0A0E1A) : const Color(0xFF00FF88),
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected ? const Color(0xFF0A0E1A) : const Color(0xFF00FF88),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selected ? const Color(0xFF00FF88) : const Color(0xFF475569),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              color: selected ? const Color(0xFF00FF88) : const Color(0xFF475569),
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  final List<ThreatAnalysis> history;
  final VoidCallback onScanTap;

  const _DashboardPage({required this.history, required this.onScanTap});

  @override
  Widget build(BuildContext context) {
    final stats = ScanHistory(analyses: history);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      const Icon(Icons.security_rounded,
                          color: Color(0xFF00FF88), size: 28),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CyberShield AI',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Your digital threat guardian',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00FF88).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFF00FF88).withOpacity(0.3)),
                            ),
                            child: const Icon(Icons.notifications_none_rounded,
                                color: Color(0xFF00FF88), size: 20),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const SettingsScreen())),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.settings_rounded,
                                  color: Color(0xFF64748B), size: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Threat Status Banner
                  _ThreatStatusBanner(history: history),

                  const SizedBox(height: 24),

                  // Stats Grid
                  Text(
                    'SCAN STATISTICS',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      StatsCard(
                        label: 'Total Scans',
                        value: stats.totalScans.toString(),
                        icon: Icons.radar_rounded,
                        color: const Color(0xFF00D4FF),
                      ),
                      StatsCard(
                        label: 'Threats Blocked',
                        value: stats.threatsBlocked.toString(),
                        icon: Icons.block_rounded,
                        color: const Color(0xFFFF2D55),
                      ),
                      StatsCard(
                        label: 'Suspicious',
                        value: stats.suspiciousCount.toString(),
                        icon: Icons.warning_amber_rounded,
                        color: const Color(0xFFFFB300),
                      ),
                      StatsCard(
                        label: 'Safe',
                        value: stats.safeCount.toString(),
                        icon: Icons.check_circle_rounded,
                        color: const Color(0xFF00FF88),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Quick Scan Button
                  GestureDetector(
                    onTap: onScanTap,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00FF88), Color(0xFF00D4FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00FF88).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded,
                              color: Color(0xFF0A0E1A), size: 28),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start New Scan',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0A0E1A),
                                ),
                              ),
                              Text(
                                'Analyze URL, SMS, or message',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 12,
                                  color: const Color(0xFF0A0E1A).withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_rounded,
                              color: Color(0xFF0A0E1A)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Recent Threats
                  if (history.isNotEmpty) ...[
                    Text(
                      'RECENT SCANS',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...history.take(3).map((a) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _RecentScanTile(analysis: a),
                        )),
                  ] else ...[
                    _EmptyState(onScanTap: onScanTap),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreatStatusBanner extends StatelessWidget {
  final List<ThreatAnalysis> history;
  const _ThreatStatusBanner({required this.history});

  @override
  Widget build(BuildContext context) {
    final hasThreats = history.any((a) =>
        a.level == ThreatLevel.dangerous || a.level == ThreatLevel.critical);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasThreats
            ? const Color(0xFFFF2D55).withOpacity(0.1)
            : const Color(0xFF00FF88).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasThreats
              ? const Color(0xFFFF2D55).withOpacity(0.3)
              : const Color(0xFF00FF88).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            hasThreats ? Icons.warning_rounded : Icons.verified_user_rounded,
            color: hasThreats ? const Color(0xFFFF2D55) : const Color(0xFF00FF88),
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasThreats ? 'Threats Detected' : 'You\'re Protected',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: hasThreats
                        ? const Color(0xFFFF2D55)
                        : const Color(0xFF00FF88),
                  ),
                ),
                Text(
                  hasThreats
                      ? 'Review your recent scan results'
                      : 'No active threats in recent scans',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentScanTile extends StatelessWidget {
  final ThreatAnalysis analysis;
  const _RecentScanTile({required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(12),
         border: Border.all(
    color: const Color(0xFF1E293B),
  ),
      ),
      child: Row(
        children: [
          ThreatBadge(level: analysis.level, compact: true),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  analysis.input.length > 40
                      ? '${analysis.input.substring(0, 40)}...'
                      : analysis.input,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  analysis.summary,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onScanTap;
  const _EmptyState({required this.onScanTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(
              Icons.shield_outlined,
              size: 64,
              color: const Color(0xFF1E293B),
            ),
            const SizedBox(height: 16),
            Text(
              'No scans yet',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                color: const Color(0xFF475569),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start by scanning a suspicious URL or message',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                color: const Color(0xFF334155),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}