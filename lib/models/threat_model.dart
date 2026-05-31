enum ThreatLevel { safe, suspicious, dangerous, critical }

class ThreatAnalysis {
  final String id;
  final String input;
  final ThreatLevel level;
  final double confidenceScore; // 0.0 to 1.0
  final List<ThreatIndicator> indicators;
  final String summary;
  final String recommendation;
  final DateTime analyzedAt;
  final AnalysisType type;

  const ThreatAnalysis({
    required this.id,
    required this.input,
    required this.level,
    required this.confidenceScore,
    required this.indicators,
    required this.summary,
    required this.recommendation,
    required this.analyzedAt,
    required this.type,
  });

  String get threatLevelLabel {
    switch (level) {
      case ThreatLevel.safe:
        return 'SAFE';
      case ThreatLevel.suspicious:
        return 'SUSPICIOUS';
      case ThreatLevel.dangerous:
        return 'DANGEROUS';
      case ThreatLevel.critical:
        return 'CRITICAL THREAT';
    }
  }

  int get threatScore {
    switch (level) {
      case ThreatLevel.safe:
        return (confidenceScore * 10).round();
      case ThreatLevel.suspicious:
        return (30 + confidenceScore * 20).round();
      case ThreatLevel.dangerous:
        return (60 + confidenceScore * 20).round();
      case ThreatLevel.critical:
        return (85 + confidenceScore * 15).round();
    }
  }
}

class ThreatIndicator {
  final String category;
  final String description;
  final ThreatLevel severity;
  final String icon;

  const ThreatIndicator({
    required this.category,
    required this.description,
    required this.severity,
    required this.icon,
  });
}

enum AnalysisType { url, text, screenshot, sms }

class ScanHistory {
  final List<ThreatAnalysis> analyses;

  const ScanHistory({required this.analyses});

  int get totalScans => analyses.length;
  int get threatsBlocked =>
      analyses.where((a) => a.level == ThreatLevel.dangerous || a.level == ThreatLevel.critical).length;
  int get suspiciousCount =>
      analyses.where((a) => a.level == ThreatLevel.suspicious).length;
  int get safeCount =>
      analyses.where((a) => a.level == ThreatLevel.safe).length;
}