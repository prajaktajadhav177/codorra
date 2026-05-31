import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/threat_model.dart';

class ThreatBadge extends StatelessWidget {
  final ThreatLevel level;
  final bool compact;

  const ThreatBadge({super.key, required this.level, this.compact = false});

  Color get _color {
    switch (level) {
      case ThreatLevel.safe:
        return const Color(0xFF00FF88);
      case ThreatLevel.suspicious:
        return const Color(0xFFFFB300);
      case ThreatLevel.dangerous:
        return const Color(0xFFFF6B35);
      case ThreatLevel.critical:
        return const Color(0xFFFF2D55);
    }
  }

  IconData get _icon {
    switch (level) {
      case ThreatLevel.safe:
        return Icons.verified_user_rounded;
      case ThreatLevel.suspicious:
        return Icons.warning_amber_rounded;
      case ThreatLevel.dangerous:
        return Icons.dangerous_rounded;
      case ThreatLevel.critical:
        return Icons.gpp_bad_rounded;
    }
  }

  String get _label {
    switch (level) {
      case ThreatLevel.safe:
        return 'SAFE';
      case ThreatLevel.suspicious:
        return 'SUSPICIOUS';
      case ThreatLevel.dangerous:
        return 'DANGEROUS';
      case ThreatLevel.critical:
        return 'CRITICAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(compact ? 8 : 10),
        border: Border.all(color: _color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: _color, size: compact ? 14 : 18),
          const SizedBox(width: 6),
          Text(
            _label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: compact ? 11 : 13,
              fontWeight: FontWeight.w700,
              color: _color,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}