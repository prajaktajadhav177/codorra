import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/threat_model.dart';
import '../services/ai_analysis_service.dart';
import '../widgets/threat_badge.dart';
import '../widgets/indicator_card.dart';
import '../widgets/threat_meter.dart';

class ScanScreen extends StatefulWidget {
  final void Function(ThreatAnalysis) onAnalysisComplete;
  const ScanScreen({super.key, required this.onAnalysisComplete});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  AnalysisType _selectedType = AnalysisType.url;
  bool _isAnalyzing = false;
  ThreatAnalysis? _result;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a URL or message to scan',
            style: GoogleFonts.spaceGrotesk(),
          ),
          backgroundColor: const Color(0xFFFF2D55),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _result = null;
    });

    final analysis = await AIAnalysisService.analyzeText(
      input: input,
      type: _selectedType,
    );

    setState(() {
      _isAnalyzing = false;
      _result = analysis;
    });

    widget.onAnalysisComplete(analysis);
    HapticFeedback.mediumImpact();
  }

  void _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _inputController.text = data!.text!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Threat Scanner',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              'AI-powered phishing detection',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),

            // Type Selector
            _TypeSelector(
              selected: _selectedType,
              onChanged: (type) => setState(() => _selectedType = type),
            ),
            const SizedBox(height: 16),

            // Input Field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isAnalyzing
                      ? const Color(0xFF00FF88).withOpacity(0.5)
                      : const Color(0xFF1E293B),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _inputController,
                    maxLines: 5,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: _selectedType == AnalysisType.url
                          ? 'Paste suspicious URL here...\ne.g. https://amaz0n-login.tk/verify'
                          : 'Paste suspicious SMS or message here...',
                      hintStyle: GoogleFonts.spaceGrotesk(
                        fontSize: 13,
                        color: const Color(0xFF334155),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: const Color(0xFF1E293B),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        TextButton.icon(
                          onPressed: _pasteFromClipboard,
                          icon: const Icon(Icons.content_paste_rounded,
                              size: 16),
                          label: Text(
                            'Paste',
                            style: GoogleFonts.spaceGrotesk(fontSize: 12),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF00D4FF),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _inputController.clear(),
                          icon: const Icon(Icons.clear_rounded, size: 16),
                          label: Text(
                            'Clear',
                            style: GoogleFonts.spaceGrotesk(fontSize: 12),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Analyze Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isAnalyzing ? null : _analyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF88),
                  disabledBackgroundColor:
                      const Color(0xFF00FF88).withOpacity(0.3),
                  foregroundColor: const Color(0xFF0A0E1A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isAnalyzing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _pulseAnim,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnim.value,
                                child: const Icon(Icons.radar_rounded,
                                    color: Color(0xFF00FF88)),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'AI Analyzing...',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00FF88),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.security_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'ANALYZE THREAT',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // Results
            if (_result != null) _ResultPanel(analysis: _result!),
          ],
        ),
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final AnalysisType selected;
  final void Function(AnalysisType) onChanged;

  const _TypeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TypeChip(
          label: 'URL',
          icon: Icons.link_rounded,
          selected: selected == AnalysisType.url,
          onTap: () => onChanged(AnalysisType.url),
        ),
        const SizedBox(width: 8),
        _TypeChip(
          label: 'SMS',
          icon: Icons.sms_rounded,
          selected: selected == AnalysisType.sms,
          onTap: () => onChanged(AnalysisType.sms),
        ),
        const SizedBox(width: 8),
        _TypeChip(
          label: 'Message',
          icon: Icons.chat_rounded,
          selected: selected == AnalysisType.text,
          onTap: () => onChanged(AnalysisType.text),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF00FF88).withOpacity(0.15)
              : const Color(0xFF111827),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? const Color(0xFF00FF88).withOpacity(0.5)
                : const Color(0xFF1E293B),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected
                  ? const Color(0xFF00FF88)
                  : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected
                    ? const Color(0xFF00FF88)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  final ThreatAnalysis analysis;
  const _ResultPanel({required this.analysis});

  Color get _threatColor {
    switch (analysis.level) {
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

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ANALYSIS RESULT',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),

          // Main result card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _threatColor.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: _threatColor.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ThreatBadge(level: analysis.level),
                    const Spacer(),
                    Text(
                      '${(analysis.confidenceScore * 100).round()}% confidence',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ThreatMeter(score: analysis.threatScore, color: _threatColor),
                const SizedBox(height: 16),
                Text(
                  analysis.summary,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _threatColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: _threatColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_rounded,
                          color: _threatColor, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          analysis.recommendation,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            color: _threatColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Threat Indicators
          if (analysis.indicators.isNotEmpty) ...[
            Text(
              'THREAT INDICATORS',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF64748B),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            ...analysis.indicators.map((indicator) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: IndicatorCard(indicator: indicator),
                )),
          ],
        ],
      ),
    );
  }
}