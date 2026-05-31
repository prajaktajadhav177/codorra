import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _smsMonitor = false;
  bool _autoScan = true;
  bool _notifications = true;
  bool _shareAnonymous = true;
  bool _offlineMode = false;
  String _sensitivity = 'Balanced';

  final List<String> _sensitivityOptions = ['Low', 'Balanced', 'High', 'Paranoid'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configure your protection',
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 13, color: const Color(0xFF64748B)),
            ),
            const SizedBox(height: 28),

            // Protection Settings
            _SectionHeader(title: 'PROTECTION'),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _ToggleTile(
                  icon: Icons.sms_rounded,
                  iconColor: const Color(0xFF00D4FF),
                  title: 'SMS Monitor',
                  subtitle: 'Scan incoming SMS for threats in real-time',
                  value: _smsMonitor,
                  onChanged: (v) => setState(() => _smsMonitor = v),
                ),
                _Divider(),
                _ToggleTile(
                  icon: Icons.auto_awesome_rounded,
                  iconColor: const Color(0xFF00FF88),
                  title: 'Auto-Scan URLs',
                  subtitle: 'Automatically scan links when copied',
                  value: _autoScan,
                  onChanged: (v) => setState(() => _autoScan = v),
                ),
                _Divider(),
                _ToggleTile(
                  icon: Icons.wifi_off_rounded,
                  iconColor: const Color(0xFFFFB300),
                  title: 'Offline Mode',
                  subtitle: 'Use on-device model only (no API calls)',
                  value: _offlineMode,
                  onChanged: (v) => setState(() => _offlineMode = v),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Sensitivity
            _SectionHeader(title: 'DETECTION SENSITIVITY'),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sensitivity Level',
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFF00FF88).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: const Color(0xFF00FF88)
                                      .withOpacity(0.4)),
                            ),
                            child: Text(
                              _sensitivity,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF00FF88),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _sensitivityOptions.map((opt) {
                          final selected = _sensitivity == opt;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _sensitivity = opt),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFF00FF88)
                                    : const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                opt,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? const Color(0xFF0A0E1A)
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _getSensitivityDesc(_sensitivity),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Notifications
            _SectionHeader(title: 'NOTIFICATIONS'),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _ToggleTile(
                  icon: Icons.notifications_rounded,
                  iconColor: const Color(0xFFFF6B35),
                  title: 'Push Notifications',
                  subtitle: 'Alert on new threats and community reports',
                  value: _notifications,
                  onChanged: (v) => setState(() => _notifications = v),
                ),
                _Divider(),
                _ToggleTile(
                  icon: Icons.group_rounded,
                  iconColor: const Color(0xFF00D4FF),
                  title: 'Share Anonymous Data',
                  subtitle: 'Help improve threat detection for everyone',
                  value: _shareAnonymous,
                  onChanged: (v) => setState(() => _shareAnonymous = v),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // API Key
            _SectionHeader(title: 'AI ENGINE'),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _ActionTile(
                  icon: Icons.key_rounded,
                  iconColor: const Color(0xFFFFB300),
                  title: 'Anthropic API Key',
                  subtitle: 'Configure for enhanced AI analysis',
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFF475569)),
                  onTap: () => _showApiKeyDialog(context),
                ),
                _Divider(),
                _ActionTile(
                  icon: Icons.info_outline_rounded,
                  iconColor: const Color(0xFF64748B),
                  title: 'Model: Claude Sonnet 4',
                  subtitle: 'Current AI model for threat analysis',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FF88).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'ACTIVE',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF00FF88),
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            // About
            _SectionHeader(title: 'ABOUT'),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _ActionTile(
                  icon: Icons.security_rounded,
                  iconColor: const Color(0xFF00FF88),
                  title: 'CyberShield AI',
                  subtitle: 'Version 1.0.0 • Codorra Hackathon 2026',
                  trailing: const SizedBox.shrink(),
                  onTap: () {},
                ),
                _Divider(),
                _ActionTile(
                  icon: Icons.privacy_tip_rounded,
                  iconColor: const Color(0xFF00D4FF),
                  title: 'Privacy Policy',
                  subtitle: 'How we handle your data',
                  trailing: const Icon(Icons.open_in_new_rounded,
                      color: Color(0xFF475569), size: 16),
                  onTap: () {},
                ),
                _Divider(),
                _ActionTile(
                  icon: Icons.delete_outline_rounded,
                  iconColor: const Color(0xFFFF2D55),
                  title: 'Clear Scan History',
                  subtitle: 'Remove all stored scan results',
                  trailing: const SizedBox.shrink(),
                  onTap: () => _showClearDialog(context),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _getSensitivityDesc(String level) {
    switch (level) {
      case 'Low':
        return 'Only flags confirmed, high-confidence threats. Fewer false positives.';
      case 'Balanced':
        return 'Recommended. Balanced detection with moderate false positives.';
      case 'High':
        return 'Flags suspicious content aggressively. More false positives possible.';
      case 'Paranoid':
        return 'Maximum protection. Treats almost everything as suspicious.';
      default:
        return '';
    }
  }

  void _showApiKeyDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Anthropic API Key',
          style: GoogleFonts.spaceGrotesk(
              color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your API key for full Claude AI-powered analysis.',
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 13, color: const Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              style: GoogleFonts.spaceGrotesk(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'sk-ant-...',
                hintStyle:
                    GoogleFonts.spaceGrotesk(color: const Color(0xFF475569)),
                filled: true,
                fillColor: const Color(0xFF0A0E1A),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFF1E293B))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFF1E293B))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Color(0xFF00FF88), width: 1.5)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.spaceGrotesk(
                    color: const Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FF88),
              foregroundColor: const Color(0xFF0A0E1A),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child:
                Text('Save', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Clear History?',
          style: GoogleFonts.spaceGrotesk(
              color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'All scan history will be permanently deleted.',
          style: GoogleFonts.spaceGrotesk(
              fontSize: 13, color: const Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.spaceGrotesk(
                    color: const Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF2D55),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Delete',
                style: GoogleFonts.spaceGrotesk(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─── Shared Settings Widgets ──────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF64748B),
        letterSpacing: 2,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: const Color(0xFF1E293B));
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final void Function(bool) onChanged;

  const _ToggleTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                Text(subtitle,
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 11, color: const Color(0xFF64748B))),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF00FF88),
            activeTrackColor:
                const Color(0xFF00FF88).withOpacity(0.3),
            inactiveThumbColor: const Color(0xFF475569),
            inactiveTrackColor: const Color(0xFF1E293B),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  Text(subtitle,
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 11,
                          color: const Color(0xFF64748B))),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}