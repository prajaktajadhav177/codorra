import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThreatMeter extends StatefulWidget {
  final int score; // 0–100
  final Color color;

  const ThreatMeter({super.key, required this.score, required this.color});

  @override
  State<ThreatMeter> createState() => _ThreatMeterState();
}

class _ThreatMeterState extends State<ThreatMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _anim = Tween<double>(begin: 0, end: widget.score / 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(ThreatMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _anim = Tween<double>(
              begin: _anim.value, end: widget.score / 100)
          .animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final pct = _anim.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'THREAT SCORE',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  '${(pct * 100).round()} / 100',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: widget.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                // Track
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                // Fill
                FractionallySizedBox(
                  widthFactor: pct.clamp(0.0, 1.0),
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF00FF88),
                          widget.color,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Scale labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Safe',
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 10, color: const Color(0xFF00FF88))),
                Text('Low',
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 10, color: const Color(0xFF64748B))),
                Text('High',
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 10, color: const Color(0xFFFF6B35))),
                Text('Critical',
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 10, color: const Color(0xFFFF2D55))),
              ],
            ),
          ],
        );
      },
    );
  }
}