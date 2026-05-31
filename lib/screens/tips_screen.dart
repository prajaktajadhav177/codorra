import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Security Tips',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Stay safe in the digital world',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 20),
                // Tab bar
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: const Color(0xFF00FF88),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelColor: const Color(0xFF0A0E1A),
                    unselectedLabelColor: const Color(0xFF64748B),
                    labelStyle: GoogleFonts.spaceGrotesk(
                        fontSize: 12, fontWeight: FontWeight.w700),
                    unselectedLabelStyle:
                        GoogleFonts.spaceGrotesk(fontSize: 12),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Phishing'),
                      Tab(text: 'Scams'),
                      Tab(text: 'Best Practices'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _PhishingTips(),
                _ScamsTips(),
                _BestPracticesTips(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Phishing Tips ────────────────────────────────────────────────────────────
class _PhishingTips extends StatelessWidget {
  const _PhishingTips();

  @override
  Widget build(BuildContext context) {
    final tips = [
      _TipData(
        icon: '🔗',
        title: 'Check the URL carefully',
        body:
            'Phishers use lookalike domains like "paypa1.com" or "amazon-login.tk". Always verify the exact domain before clicking.',
        color: const Color(0xFFFF2D55),
        tag: 'URL SAFETY',
      ),
      _TipData(
        icon: '🔒',
        title: 'HTTPS is not enough',
        body:
            'A padlock icon only means the connection is encrypted — not that the site is legitimate. Scammers use HTTPS too.',
        color: const Color(0xFFFFB300),
        tag: 'COMMON MYTH',
      ),
      _TipData(
        icon: '📧',
        title: 'Hover before you click',
        body:
            'On desktop, hover over links to see the real URL in the status bar. On mobile, long-press to preview the link destination.',
        color: const Color(0xFF00D4FF),
        tag: 'PRO TIP',
      ),
      _TipData(
        icon: '⏰',
        title: 'Urgency is a red flag',
        body:
            '"Your account will be suspended in 24 hours!" — real companies rarely create this kind of pressure. Slow down and verify.',
        color: const Color(0xFFFF6B35),
        tag: 'PSYCHOLOGY',
      ),
      _TipData(
        icon: '🏦',
        title: 'Banks never ask for OTP',
        body:
            'No legitimate bank, UPI app, or government service will ever ask for your OTP, PIN, or full password over phone or SMS.',
        color: const Color(0xFF00FF88),
        tag: 'INDIA SPECIFIC',
      ),
    ];

    return _TipsList(tips: tips);
  }
}

// ─── Scams Tips ───────────────────────────────────────────────────────────────
class _ScamsTips extends StatelessWidget {
  const _ScamsTips();

  @override
  Widget build(BuildContext context) {
    final tips = [
      _TipData(
        icon: '🎁',
        title: 'You didn\'t win anything',
        body:
            'If you receive a message saying you\'ve won a lottery or prize you never entered, it\'s a scam 100% of the time.',
        color: const Color(0xFFFF2D55),
        tag: 'PRIZE SCAM',
      ),
      _TipData(
        icon: '💼',
        title: 'Too-good-to-be-true jobs',
        body:
            'Work-from-home jobs offering ₹50,000/day for minimal effort are recruitment scams designed to steal your identity or money.',
        color: const Color(0xFFFFB300),
        tag: 'JOB SCAM',
      ),
      _TipData(
        icon: '💸',
        title: 'Advance fee fraud',
        body:
            'If you\'re asked to pay a small fee to unlock a large reward, it\'s a classic advance fee scam. Stop all contact immediately.',
        color: const Color(0xFFFF6B35),
        tag: '419 SCAM',
      ),
      _TipData(
        icon: '📱',
        title: 'Fake customer support',
        body:
            'Scammers pose as Amazon, Flipkart, or bank support. Always call the official number on the company\'s website, never one in a message.',
        color: const Color(0xFF00D4FF),
        tag: 'IMPERSONATION',
      ),
      _TipData(
        icon: '❤️',
        title: 'Romance scams are rising',
        body:
            'Online strangers who quickly profess love and then ask for money are almost always scammers. Never send money to someone you haven\'t met.',
        color: const Color(0xFFFF2D55),
        tag: 'SOCIAL ENG',
      ),
    ];

    return _TipsList(tips: tips);
  }
}

// ─── Best Practices ───────────────────────────────────────────────────────────
class _BestPracticesTips extends StatelessWidget {
  const _BestPracticesTips();

  @override
  Widget build(BuildContext context) {
    final tips = [
      _TipData(
        icon: '🔐',
        title: 'Use a password manager',
        body:
            'Strong, unique passwords for every account stop credential stuffing attacks. Use Bitwarden or similar to manage them safely.',
        color: const Color(0xFF00FF88),
        tag: 'PASSWORDS',
      ),
      _TipData(
        icon: '📲',
        title: 'Enable 2FA everywhere',
        body:
            'Two-factor authentication blocks 99.9% of automated attacks. Use an authenticator app (not SMS) for critical accounts.',
        color: const Color(0xFF00D4FF),
        tag: '2FA',
      ),
      _TipData(
        icon: '🔄',
        title: 'Keep software updated',
        body:
            'Most cyber attacks exploit known vulnerabilities. Keeping your OS, apps, and browser updated patches the holes attackers use.',
        color: const Color(0xFFFFB300),
        tag: 'UPDATES',
      ),
      _TipData(
        icon: '📋',
        title: 'Report scams in India',
        body:
            'Report cyber crimes at cybercrime.gov.in or call the national helpline 1930. Your report helps protect others.',
        color: const Color(0xFFFF6B35),
        tag: 'INDIA HELPLINE',
      ),
      _TipData(
        icon: '🧠',
        title: 'Think before you click',
        body:
            'Pause for 10 seconds before clicking any link in an email, SMS, or WhatsApp. Ask: "Was I expecting this? Does this make sense?"',
        color: const Color(0xFF00FF88),
        tag: 'HABIT',
      ),
    ];

    return _TipsList(tips: tips);
  }
}

// ─── Shared Components ────────────────────────────────────────────────────────
class _TipData {
  final String icon;
  final String title;
  final String body;
  final Color color;
  final String tag;

  const _TipData({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
    required this.tag,
  });
}

class _TipsList extends StatelessWidget {
  final List<_TipData> tips;
  const _TipsList({required this.tips});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      itemCount: tips.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _TipCard(tip: tips[i]),
    );
  }
}

class _TipCard extends StatefulWidget {
  final _TipData tip;
  const _TipCard({required this.tip});

  @override
  State<_TipCard> createState() => _TipCardState();
}

class _TipCardState extends State<_TipCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _expanded
                ? widget.tip.color.withOpacity(0.5)
                : const Color(0xFF1E293B),
          ),
          boxShadow: _expanded
              ? [
                  BoxShadow(
                    color: widget.tip.color.withOpacity(0.08),
                    blurRadius: 16,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: widget.tip.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                    child: Text(widget.tip.icon,
                        style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: widget.tip.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          widget.tip.tag,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: widget.tip.color,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.tip.title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF64748B),
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 12),
              Container(
                height: 1,
                color: const Color(0xFF1E293B),
              ),
              const SizedBox(height: 12),
              Text(
                widget.tip.body,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
                  height: 1.6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}