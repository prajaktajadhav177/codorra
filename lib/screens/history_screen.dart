import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/threat_model.dart';
import '../widgets/threat_badge.dart';

class HistoryScreen extends StatelessWidget {
  final List<ThreatAnalysis> history;
  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scan History',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${history.length} total scans',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: history.isEmpty
                ? _EmptyHistory()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: history.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return _HistoryTile(analysis: history[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final ThreatAnalysis analysis;
  const _HistoryTile({required this.analysis});

  Color get _borderColor {
    switch (analysis.level) {
      case ThreatLevel.safe:
        return const Color(0xFF00FF88).withOpacity(0.3);
      case ThreatLevel.suspicious:
        return const Color(0xFFFFB300).withOpacity(0.3);
      case ThreatLevel.dangerous:
        return const Color(0xFFFF6B35).withOpacity(0.3);
      case ThreatLevel.critical:
        return const Color(0xFFFF2D55).withOpacity(0.3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ThreatBadge(level: analysis.level, compact: true),
              const Spacer(),
              Text(
                DateFormat('MMM dd, HH:mm').format(analysis.analyzedAt),
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            analysis.input.length > 60
                ? '${analysis.input.substring(0, 60)}...'
                : analysis.input,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              color: const Color(0xFFCBD5E1),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            analysis.summary,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _TypeChip(type: analysis.type),
              const Spacer(),
              Text(
                'Score: ${analysis.threatScore}/100',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final AnalysisType type;
  const _TypeChip({required this.type});

  String get label {
    switch (type) {
      case AnalysisType.url:
        return 'URL';
      case AnalysisType.sms:
        return 'SMS';
      case AnalysisType.text:
        return 'Message';
      case AnalysisType.screenshot:
        return 'Screenshot';
    }
  }

  IconData get icon {
    switch (type) {
      case AnalysisType.url:
        return Icons.link_rounded;
      case AnalysisType.sms:
        return Icons.sms_rounded;
      case AnalysisType.text:
        return Icons.chat_rounded;
      case AnalysisType.screenshot:
        return Icons.screenshot_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF64748B)),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history_rounded,
              size: 64, color: Color(0xFF1E293B)),
          const SizedBox(height: 16),
          Text(
            'No scan history yet',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              color: const Color(0xFF475569),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your past scans will appear here',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              color: const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}