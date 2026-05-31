import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/threat_model.dart';

class AIAnalysisService {
  // ── FREE Google Gemini API ──────────────────────────────────────────────
  // Get your FREE key at: https://aistudio.google.com
  // 1. Sign in with Google account
  // 2. Click "Get API Key" → "Create API Key"
  // 3. Copy and paste it below — NO bank/card needed!
  static const String _geminiApiKey = 'YOUR_GEMINI_API_KEY';
  static const String _geminiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  static const _uuid = Uuid();

  // ─────────────────────────────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────────────────────────────

  static Future<ThreatAnalysis> analyzeText({
    required String input,
    required AnalysisType type,
  }) async {
    // Always run heuristic first for instant result
    final heuristic = _heuristicAnalysis(input, type);

    // If API key is set, enhance with Gemini AI
    if (_geminiApiKey != 'YOUR_GEMINI_API_KEY') {
      try {
        final aiResult = await _analyzeWithGemini(input, type);
        if (aiResult != null) return aiResult;
      } catch (_) {}
    }

    return heuristic;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // GEMINI API CALL
  // ─────────────────────────────────────────────────────────────────────────

  static Future<ThreatAnalysis?> _analyzeWithGemini(
      String input, AnalysisType type) async {
    final prompt = _buildPrompt(input, type);

    final response = await http.post(
      Uri.parse('$_geminiUrl?key=$_geminiApiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.1,
          'maxOutputTokens': 1000,
        },
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
      return _parseAnalysis(input, text, type);
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PROMPT
  // ─────────────────────────────────────────────────────────────────────────

  static String _buildPrompt(String input, AnalysisType type) {
    final typeLabel = type == AnalysisType.url
        ? 'URL'
        : type == AnalysisType.sms
            ? 'SMS message'
            : 'text message';

    return '''You are CyberShield AI, an expert cybersecurity analyst for India specializing in phishing, social engineering, UPI fraud, and online scam detection.

Analyze this $typeLabel for threats:
"""
$input
"""

Respond ONLY in this exact JSON format (no markdown, no extra text):
{
  "threat_level": "safe|suspicious|dangerous|critical",
  "confidence": 0.0-1.0,
  "summary": "One sentence summary",
  "recommendation": "Specific action for the user",
  "indicators": [
    {
      "category": "category name",
      "description": "what was found and why it is dangerous",
      "severity": "safe|suspicious|dangerous|critical",
      "icon": "single emoji"
    }
  ]
}

Threat levels:
- safe: No threats detected
- suspicious: Some red flags, not confirmed malicious
- dangerous: High confidence phishing/scam
- critical: Active attack, immediate action needed

Check for: homoglyph/lookalike domains, urgency manipulation, OTP/PIN/CVV requests, brand impersonation, advance fee fraud, job scams, UPI fraud, KYC scams, lottery/prize scams, grammar issues typical of mass scam messages.''';
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PARSE GEMINI RESPONSE
  // ─────────────────────────────────────────────────────────────────────────

  static ThreatAnalysis? _parseAnalysis(
      String input, String jsonText, AnalysisType type) {
    try {
      final cleanJson = jsonText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      final Map<String, dynamic> data = jsonDecode(cleanJson);
      final threatLevel = _parseThreatLevel(data['threat_level'] as String);
      final indicators = (data['indicators'] as List<dynamic>)
          .map((i) => ThreatIndicator(
                category: i['category'] as String,
                description: i['description'] as String,
                severity: _parseThreatLevel(i['severity'] as String),
                icon: i['icon'] as String? ?? '⚠️',
              ))
          .toList();
      return ThreatAnalysis(
        id: _uuid.v4(),
        input: input,
        level: threatLevel,
        confidenceScore: (data['confidence'] as num).toDouble(),
        indicators: indicators,
        summary: data['summary'] as String,
        recommendation: data['recommendation'] as String,
        analyzedAt: DateTime.now(),
        type: type,
      );
    } catch (_) {
      return null;
    }
  }

  static ThreatLevel _parseThreatLevel(String level) {
    switch (level.toLowerCase()) {
      case 'critical':   return ThreatLevel.critical;
      case 'dangerous':  return ThreatLevel.dangerous;
      case 'suspicious': return ThreatLevel.suspicious;
      default:           return ThreatLevel.safe;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HOMOGLYPH NORMALISER
  // ─────────────────────────────────────────────────────────────────────────
  static String _normalise(String s) {
    final buf = StringBuffer();
    for (final ch in s.toLowerCase().split('')) {
      switch (ch) {
        case '0': buf.write('o'); break;
        case '1': buf.write('l'); break;
        case '3': buf.write('e'); break;
        case '4': buf.write('a'); break;
        case '5': buf.write('s'); break;
        default:  buf.write(ch);
      }
    }
    return buf.toString()
        .replaceAll('vv', 'w')
        .replaceAll('rn', 'm');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // EXTRACT HOSTNAME
  // ─────────────────────────────────────────────────────────────────────────
  static String _extractHost(String input) {
    final trimmed = input.trim();
    Uri? uri = Uri.tryParse(trimmed);
    if (uri != null && uri.host.isNotEmpty) return uri.host.toLowerCase();
    uri = Uri.tryParse('https://$trimmed');
    if (uri != null && uri.host.isNotEmpty) return uri.host.toLowerCase();
    final match = RegExp(r'(?:https?://)?([^/\s?#]+)').firstMatch(trimmed);
    return match?.group(1)?.toLowerCase() ?? trimmed.toLowerCase();
  }

  static bool _isLegitDomain(String host, String legitHost) {
    return host == legitHost
        || host == 'www.$legitHost'
        || host.endsWith('.$legitHost');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HEURISTIC ENGINE (works 100% offline, no API key needed)
  // ─────────────────────────────────────────────────────────────────────────
  static ThreatAnalysis _heuristicAnalysis(String input, AnalysisType type) {
    final rawLower   = input.toLowerCase().trim();
    final host       = _extractHost(input);
    final normHost   = _normalise(host);
    final indicators = <ThreatIndicator>[];
    int riskScore    = 0;

    // ── 1. BRAND TABLE ───────────────────────────────────────────────────
    const Map<String, String> brandDomains = {
      'facebook'  : 'facebook.com',
      'instagram' : 'instagram.com',
      'whatsapp'  : 'whatsapp.com',
      'google'    : 'google.com',
      'gmail'     : 'gmail.com',
      'youtube'   : 'youtube.com',
      'amazon'    : 'amazon.in',
      'flipkart'  : 'flipkart.com',
      'paypal'    : 'paypal.com',
      'microsoft' : 'microsoft.com',
      'apple'     : 'apple.com',
      'netflix'   : 'netflix.com',
      'twitter'   : 'twitter.com',
      'linkedin'  : 'linkedin.com',
      'sbi'       : 'onlinesbi.sbi',
      'hdfc'      : 'hdfcbank.com',
      'icici'     : 'icicibank.com',
      'axis'      : 'axisbank.com',
      'kotak'     : 'kotak.com',
      'paytm'     : 'paytm.com',
      'phonepe'   : 'phonepe.com',
      'irctc'     : 'irctc.co.in',
      'uidai'     : 'uidai.gov.in',
      'incometax' : 'incometax.gov.in',
    };

    // ── 2. HOMOGLYPH / LOOKALIKE DOMAIN ─────────────────────────────────
    for (final entry in brandDomains.entries) {
      final brand     = entry.key;
      final legitHost = entry.value;

      if (!normHost.contains(brand)) continue;
      if (_isLegitDomain(host, legitHost) || _isLegitDomain(normHost, legitHost)) continue;

      final isHomoglyph = !host.contains(brand) && normHost.contains(brand);
      riskScore += isHomoglyph ? 70 : 55;
      indicators.add(ThreatIndicator(
        category: isHomoglyph ? 'Homoglyph Attack' : 'Brand Impersonation',
        description: isHomoglyph
            ? 'Uses look-alike characters to mimic "$brand" (e.g. 0→o, 1→l). Official: $legitHost'
            : 'Pretends to be "$brand" but is NOT the official domain ($legitHost)',
        severity: ThreatLevel.critical,
        icon: isHomoglyph ? '🔡' : '🎭',
      ));
      break;
    }

    // ── 3. TYPOSQUATTING ─────────────────────────────────────────────────
    if (indicators.isEmpty) {
      const typoMap = {
        'googie'   : 'google.com',
        'gogle'    : 'google.com',
        'gooogle'  : 'google.com',
        'goggle'   : 'google.com',
        'g00gle'   : 'google.com',
        'facebok'  : 'facebook.com',
        'facbook'  : 'facebook.com',
        'facebbok' : 'facebook.com',
        'faebook'  : 'facebook.com',
        'amazoon'  : 'amazon.in',
        'amaz0n'   : 'amazon.in',
        'amzon'    : 'amazon.in',
        'paypa'    : 'paypal.com',
        'paypai'   : 'paypal.com',
        'paypol'   : 'paypal.com',
        'mircosoft': 'microsoft.com',
        'microsft' : 'microsoft.com',
        'netfliix' : 'netflix.com',
        'netfix'   : 'netflix.com',
        'netlfix'  : 'netflix.com',
        'instagran': 'instagram.com',
        'instagrm' : 'instagram.com',
        'whatsap'  : 'whatsapp.com',
        'whatsaap' : 'whatsapp.com',
        'sbionline': 'onlinesbi.sbi',
        'hdfcbank-': 'hdfcbank.com',
      };
      for (final entry in typoMap.entries) {
        if (normHost.contains(entry.key) || host.contains(entry.key)) {
          riskScore += 65;
          indicators.add(ThreatIndicator(
            category: 'Typosquatting',
            description: '"$host" is a deliberate typo/lookalike of "${entry.value}"',
            severity: ThreatLevel.critical,
            icon: '✏️',
          ));
          break;
        }
      }
    }

    // ── 4. SUSPICIOUS TLD ────────────────────────────────────────────────
    const badTLDs = [
      '.xyz', '.tk', '.ml', '.ga', '.cf', '.gq', '.pw',
      '.top', '.click', '.link', '.live', '.online',
      '.site', '.work', '.party', '.loan', '.win', '.bid',
      '.info', '.buzz', '.rest', '.uno',
    ];
    for (final tld in badTLDs) {
      if (host.endsWith(tld)) {
        riskScore += 30;
        indicators.add(ThreatIndicator(
          category: 'Suspicious TLD',
          description: '"$tld" is free/cheap and heavily abused for phishing',
          severity: ThreatLevel.dangerous,
          icon: '🌐',
        ));
        break;
      }
    }

    // ── 5. PHISHING KEYWORDS IN DOMAIN ───────────────────────────────────
    const phishingKeywords = [
      'login', 'signin', 'verify', 'secure', 'update',
      'account', 'confirm', 'kyc', 'alert', 'support',
      'helpdesk', 'customer', 'banking', 'wallet', 'unlock',
    ];
    int kwHits = 0;
    for (final kw in phishingKeywords) {
      if (host.contains(kw)) kwHits++;
    }
    if (kwHits >= 1) {
      riskScore += kwHits * 15;
      indicators.add(ThreatIndicator(
        category: 'Deceptive Domain Keywords',
        description: 'Domain contains $kwHits security/banking keyword(s) to appear legitimate',
        severity: kwHits >= 2 ? ThreatLevel.dangerous : ThreatLevel.suspicious,
        icon: '🔍',
      ));
    }

    // ── 6. SUBDOMAIN ABUSE ───────────────────────────────────────────────
    if (host.split('.').length >= 4) {
      riskScore += 25;
      indicators.add(const ThreatIndicator(
        category: 'Subdomain Abuse',
        description: 'Deep subdomains hide the real malicious root domain',
        severity: ThreatLevel.dangerous,
        icon: '🕸️',
      ));
    }

    // ── 7. CREDENTIAL HARVESTING ─────────────────────────────────────────
    const credWords = [
      'password', 'otp', 'one time password', 'pin', 'cvv',
      'account number', 'aadhaar', 'pan number', 'ifsc',
      'debit card', 'credit card', 'netbanking', 'upi pin',
    ];
    for (final word in credWords) {
      if (rawLower.contains(word)) {
        riskScore += 40;
        indicators.add(ThreatIndicator(
          category: 'Credential Harvesting',
          description: 'Requests "$word" — no legitimate service ever asks for this',
          severity: ThreatLevel.dangerous,
          icon: '🔑',
        ));
        break;
      }
    }

    // ── 8. URGENCY MANIPULATION ──────────────────────────────────────────
    const urgencyWords = [
      'urgent', 'immediately', 'expire', 'suspended', 'blocked',
      'verify now', 'act now', 'limited time', 'last chance',
      'within 24', 'within 48', 'account will be', 'तुरंत', 'अभी',
    ];
    for (final word in urgencyWords) {
      if (rawLower.contains(word)) {
        riskScore += 20;
        indicators.add(const ThreatIndicator(
          category: 'Urgency Manipulation',
          description: 'Creates artificial time pressure to bypass critical thinking',
          severity: ThreatLevel.suspicious,
          icon: '⏰',
        ));
        break;
      }
    }

    // ── 9. PRIZE / LOTTERY SCAM ──────────────────────────────────────────
    final congratsPattern = RegExp(r'congrat[a-z]{0,8}s?', caseSensitive: false);
    final hasCongrats = congratsPattern.hasMatch(rawLower);
    const prizeWords = [
      'you have won', 'you won', 'winner', 'prize', 'lottery',
      'lucky draw', 'selected for', 'you are selected',
      'you have been chosen', 'crore', 'lakh', 'kbc',
      'free iphone', 'free gift', 'claim your',
    ];
    bool hasPrizeTrigger = hasCongrats;
    for (final word in prizeWords) {
      if (rawLower.contains(word)) { hasPrizeTrigger = true; break; }
    }
    if (hasPrizeTrigger) {
      riskScore += 25;
      indicators.add(ThreatIndicator(
        category: 'Prize / Lottery Scam',
        description: hasCongrats && !rawLower.contains('congratulations')
            ? 'Misspelled "congratulations" — hallmark of mass scam messages'
            : 'Prize/lottery claims are classic social engineering tactics',
        severity: ThreatLevel.suspicious,
        icon: '💰',
      ));
    }

    // ── 10. ADVANCE FEE FRAUD ────────────────────────────────────────────
    final advanceFeeRegex = RegExp(
      r'(pay|send|transfer|deposit).{0,30}(fee|charge|amount|money|rs\.?|inr|₹)',
      caseSensitive: false,
    );
    const feeKeywords = [
      'entry fee', 'registration fee', 'processing fee',
      'activation fee', 'delivery charge', 'handling fee',
      'admin fee', 'tax fee', 'customs fee', 'release fee',
      'pay to claim', 'pay to receive', 'fill the form',
      'form attached', 'fill form',
    ];
    bool hasAdvanceFee = advanceFeeRegex.hasMatch(rawLower);
    String feeMatchedWord = '';
    for (final kw in feeKeywords) {
      if (rawLower.contains(kw)) {
        hasAdvanceFee = true;
        feeMatchedWord = kw;
        break;
      }
    }
    if (hasAdvanceFee) {
      riskScore += 45;
      indicators.add(ThreatIndicator(
        category: 'Advance Fee Fraud',
        description: feeMatchedWord.isNotEmpty
            ? '"$feeMatchedWord" — paying a fee to claim a prize is always a scam'
            : 'Requests upfront payment to unlock a reward — 100% scam pattern',
        severity: ThreatLevel.critical,
        icon: '💸',
      ));
    }
    if (hasPrizeTrigger && hasAdvanceFee) riskScore += 30;

    // ── 11. RAW IP ADDRESS ───────────────────────────────────────────────
    if (RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}').hasMatch(host)) {
      riskScore += 40;
      indicators.add(const ThreatIndicator(
        category: 'Raw IP Address',
        description: 'Legitimate services never use bare IP addresses as URLs',
        severity: ThreatLevel.dangerous,
        icon: '🖥️',
      ));
    }

    // ── 12. JOB SCAM ─────────────────────────────────────────────────────
    const jobScamWords = [
      'work from home', 'earn per day', 'earn daily', 'part time job',
      'data entry job', 'typing job', 'earn money online',
      'no experience needed', 'घर बैठे', 'per day earning',
    ];
    for (final word in jobScamWords) {
      if (rawLower.contains(word)) {
        riskScore += 30;
        indicators.add(ThreatIndicator(
          category: 'Job / Income Scam',
          description: '"$word" — fake job offers steal data or demand advance payments',
          severity: ThreatLevel.dangerous,
          icon: '💼',
        ));
        break;
      }
    }

    // ── 13. UPI / PAYMENT SCAM (India specific) ──────────────────────────
    const upiScamWords = [
      'upi id', 'send money', 'gpay', 'phonepe link',
      'paytm link', 'scan qr', 'transfer to', 'payment link',
      'cashback on upi', 'upi reward',
    ];
    for (final word in upiScamWords) {
      if (rawLower.contains(word)) {
        riskScore += 30;
        indicators.add(ThreatIndicator(
          category: 'UPI Payment Scam',
          description: '"$word" — scammers send fake payment requests or QR codes',
          severity: ThreatLevel.dangerous,
          icon: '📱',
        ));
        break;
      }
    }

    // ── DETERMINE FINAL LEVEL ────────────────────────────────────────────
    ThreatLevel level;
    double confidence;
    if (riskScore == 0) {
      level      = ThreatLevel.safe;
      confidence = 0.85;
      indicators.add(const ThreatIndicator(
        category: 'No Threats Detected',
        description: 'Content passed all heuristic checks',
        severity: ThreatLevel.safe,
        icon: '✅',
      ));
    } else if (riskScore < 25) {
      level      = ThreatLevel.suspicious;
      confidence = 0.60;
    } else if (riskScore < 55) {
      level      = ThreatLevel.dangerous;
      confidence = 0.78;
    } else {
      level      = ThreatLevel.critical;
      confidence = 0.93;
    }

    return ThreatAnalysis(
      id: _uuid.v4(),
      input: input,
      level: level,
      confidenceScore: confidence,
      indicators: indicators,
      summary: _getSummary(level),
      recommendation: _getRecommendation(level),
      analyzedAt: DateTime.now(),
      type: type,
    );
  }

  static String _getSummary(ThreatLevel level) {
    switch (level) {
      case ThreatLevel.safe:       return 'No phishing or social engineering patterns detected.';
      case ThreatLevel.suspicious: return 'Some suspicious patterns found. Exercise caution.';
      case ThreatLevel.dangerous:  return 'High-risk phishing attempt detected. Do not engage.';
      case ThreatLevel.critical:   return 'Active attack vector detected. Immediate action required.';
    }
  }

  static String _getRecommendation(ThreatLevel level) {
    switch (level) {
      case ThreatLevel.safe:       return 'Content appears safe to interact with.';
      case ThreatLevel.suspicious: return 'Verify the sender through official channels before responding.';
      case ThreatLevel.dangerous:  return 'Do NOT click any links or provide any information. Report as phishing.';
      case ThreatLevel.critical:   return 'STOP immediately. Do not share data. Report to cybercrime.gov.in and block the sender.';
    }
  }
}