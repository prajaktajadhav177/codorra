# 🛡️ CyberShield AI
### Real-Time Phishing & Scam Detector for India

> Built for **Codorra 2026 Hackathon** — Tracks: Mobile + AI + Cybersecurity

🌐 **Live Demo:** https://codorra-mauve.vercel.app

---

## 🚨 The Problem

India loses **₹7,000+ crore annually** to cyber fraud. Cyber attacks are increasing **38% year-over-year**.

Common people — students, parents, the elderly — **cannot tell** if a URL, SMS, or WhatsApp message is a scam. There is no simple, accessible tool that gives a plain-language verdict instantly.

---

## ✅ The Solution

**CyberShield AI** lets anyone scan any suspicious URL, SMS, or message and get an **AI-powered threat verdict in seconds** — no technical knowledge needed.

Paste it. Scan it. Know instantly. ✅

---

## 📱 Screenshots

| Dashboard | Scanner | Result — Critical | Tips |
|-----------|---------|-------------------|------|
| Stats, recent scans, threat status | URL / SMS / Message input | Threat score, indicators | Phishing awareness education |

---

## 🔍 What It Detects

| Threat Type | Example |
|-------------|---------|
| 🔡 Homoglyph Attack | `faceb00k1.com`, `googIe.com`, `paypa1.com` |
| ✏️ Typosquatting | `amzon.in`, `gooogle.com`, `netfix.com` |
| 🎭 Brand Impersonation | SBI, HDFC, ICICI, Paytm, Google, Amazon |
| 💸 Advance Fee Fraud | "Pay entry fee to claim your prize" |
| 📱 UPI Payment Scam | Fake payment links, QR codes |
| 🔑 Credential Harvesting | OTP, CVV, Aadhaar, PIN requests |
| 💼 Job Scam | "Earn ₹5000/day, work from home" |
| ⏰ Urgency Manipulation | "Account suspended, verify now" |
| 🌐 Suspicious TLD | `.xyz`, `.tk`, `.click`, `.loan` |
| 🕸️ Subdomain Abuse | `sbi.com.verify.evil.xyz` |
| 💰 Lottery / Prize Scam | "Congratulations, you have won" |
| 🖥️ Raw IP Address | `http://192.168.1.1/login` |
| 📋 Data Collection | "Fill the form, share your details" |

---

## ✨ Features

- **Instant Threat Verdict** — SAFE / SUSPICIOUS / DANGEROUS / CRITICAL
- **Threat Score 0–100** — animated meter with visual breakdown
- **13-Layer Offline Heuristic Engine** — works with zero internet
- **Google Gemini AI** — deep context-aware analysis when key is set
- **Threat Indicators** — explains exactly WHY something was flagged
- **Scan History** — log of all past scans with timestamps
- **Community Reporting** — submit & view crowd-sourced threat reports
- **Security Tips** — phishing, scam awareness, best practices education
- **Settings** — sensitivity control, offline mode, API key management
- **Encrypted Key Storage** — API key saved using `flutter_secure_storage`, never in code
- **India-Specific** — covers SBI, HDFC, ICICI, Paytm, PhonePe, IRCTC, UIDAI, UPI scams

---

## 🏗️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart) — cross-platform iOS & Android |
| AI Engine | Google Gemini 2.0 Flash API (free tier) |
| Offline Engine | Custom 13-layer heuristic analyser |
| Secure Storage | `flutter_secure_storage` — AES encrypted |
| UI | Material 3 + Google Fonts (Space Grotesk) |
| Deployment | Vercel (Flutter Web) |

---

## 📁 Project Structure

```
lib/
├── main.dart                        # App entry, theme config
├── models/
│   └── threat_model.dart            # ThreatAnalysis, ThreatLevel, ThreatIndicator
├── services/
│   ├── ai_analysis_service.dart     # Gemini API + heuristic engine
│   └── key_storage_service.dart     # Encrypted API key storage
├── screens/
│   ├── splash_screen.dart           # Animated boot screen
│   ├── home_screen.dart             # Dashboard + navigation
│   ├── scan_screen.dart             # Main scanner UI + results
│   ├── history_screen.dart          # Past scan log
│   ├── tips_screen.dart             # Security education
│   ├── report_screen.dart           # Community threat reports
│   └── settings_screen.dart        # App configuration
└── widgets/
    ├── threat_badge.dart            # Safe/Suspicious/Dangerous/Critical chip
    ├── threat_meter.dart            # Animated 0–100 score bar
    ├── indicator_card.dart          # Threat indicator row
    └── stats_card.dart              # Dashboard stat tile
```

---

## 🚀 Run Locally

```bash
# 1. Clone the repo
git clone https://github.com/YOURUSERNAME/cybershield-ai.git
cd cybershield-ai

# 2. Install dependencies
flutter pub get

# 3. Run on device or emulator
flutter run

# 4. Build for web
flutter build web
```

### Optional: Enable AI Analysis
1. Go to **aistudio.google.com**
2. Sign in with Google account (free, no card needed)
3. Click **"Get API Key"** → **"Create API Key"**
4. Open the app → **Settings** → **Gemini API Key** → paste and save
5. Key is encrypted on your device — never stored in code

> The app works fully **without** an API key using the offline heuristic engine.

---

## 🔐 Security Design

A key design decision: **no API keys are hardcoded anywhere in the codebase.**

- User provides their own Gemini API key via Settings
- Key is saved using `flutter_secure_storage` (AES-256 encrypted, Android Keystore / iOS Keychain)
- Zero user data is collected or transmitted
- Offline heuristic engine works entirely on-device

This was a deliberate choice to demonstrate security awareness — a cybersecurity app should itself be secure.

---

## 🧪 Test Cases

| Input | Expected Result |
|-------|----------------|
| `facebook.com` | ✅ SAFE |
| `faceb00k1.com` | 🔴 CRITICAL — Homoglyph Attack |
| `googIe.com` | 🔴 CRITICAL — Typosquatting |
| `hdfc-kyc-verify.xyz` | 🔴 CRITICAL — Brand + TLD |
| `congratualations, pay entry fee` | 🔴 CRITICAL — Advance Fee Fraud |
| `Your OTP is required to unblock` | 🟠 DANGEROUS — Credential Harvesting |
| `Earn ₹5000/day, work from home` | 🟠 DANGEROUS — Job Scam |
| `Your account will expire, verify now` | 🟡 SUSPICIOUS — Urgency Manipulation |

---

## 👨‍💻 Team

Built solo at **Codorra 2026 Hackathon** in 48 hours.

---

## 📄 License

MIT License — free to use, modify, and distribute.

---

<p align="center">
  Built with ❤️ for a safer digital India 🇮🇳
</p>