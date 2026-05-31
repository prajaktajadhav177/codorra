import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/threat_model.dart';

class IndicatorCard extends StatelessWidget {
  final ThreatIndicator indicator;

  const IndicatorCard({super.key, required this.indicator});

  Color get _severityColor {
    switch (indicator.severity) {
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

  String get _severityLabel {
    switch (indicator.severity) {
      case ThreatLevel.safe:
        return 'CLEAR';
      case ThreatLevel.suspicious:
        return 'WARN';
      case ThreatLevel.dangerous:
        return 'HIGH';
      case ThreatLevel.critical:
        return 'CRIT';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _severityColor.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _severityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                indicator.icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        indicator.category,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _severityColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(color: _severityColor.withOpacity(0.4)),
                      ),
                      child: Text(
                        _severityLabel,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: _severityColor,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  indicator.description,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                    height: 1.4,
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