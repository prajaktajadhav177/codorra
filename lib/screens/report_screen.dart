import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'Phishing URL';
  bool _submitted = false;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Phishing URL',
    'Scam SMS',
    'Fake WhatsApp',
    'Job Scam',
    'Bank Fraud',
    'Romance Scam',
    'Investment Fraud',
    'Other',
  ];

  final List<_RecentReport> _communityReports = [
    _RecentReport(
      type: 'Phishing URL',
      preview: 'hdfc-bank-kyc-update.xyz',
      location: 'Mumbai',
      reports: 142,
      color: const Color(0xFFFF2D55),
    ),
    _RecentReport(
      type: 'Scam SMS',
      preview: 'Your KBC lottery prize of ₹25L...',
      location: 'Delhi',
      reports: 89,
      color: const Color(0xFFFFB300),
    ),
    _RecentReport(
      type: 'Job Scam',
      preview: 'Earn ₹5000/day from home, no...',
      location: 'Bangalore',
      reports: 67,
      color: const Color(0xFFFF6B35),
    ),
    _RecentReport(
      type: 'Bank Fraud',
      preview: 'SBI-secure-login.tk/update',
      location: 'Chennai',
      reports: 55,
      color: const Color(0xFFFF2D55),
    ),
  ];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _isSubmitting = false;
      _submitted = true;
    });
    HapticFeedback.lightImpact();
  }

  void _resetForm() {
    setState(() {
      _submitted = false;
      _inputController.clear();
      _descController.clear();
      _selectedCategory = 'Phishing URL';
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _descController.dispose();
    super.dispose();
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
              'Report a Threat',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              'Help protect the community',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),

            // Success or Form
            _submitted ? _SuccessState(onReset: _resetForm) : _ReportForm(
              formKey: _formKey,
              inputController: _inputController,
              descController: _descController,
              selectedCategory: _selectedCategory,
              categories: _categories,
              isSubmitting: _isSubmitting,
              onCategoryChanged: (v) =>
                  setState(() => _selectedCategory = v ?? _selectedCategory),
              onSubmit: _submit,
            ),

            const SizedBox(height: 32),

            // Community Reports Section
            Row(
              children: [
                Text(
                  'COMMUNITY ALERTS',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                    letterSpacing: 2,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF2D55).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'LIVE',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFF2D55),
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._communityReports
                .map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _CommunityReportTile(report: r),
                    ))
                ,

            const SizedBox(height: 16),
            // Cybercrime helpline banner
            _HelplineBanner(),
          ],
        ),
      ),
    );
  }
}

class _ReportForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController inputController;
  final TextEditingController descController;
  final String selectedCategory;
  final List<String> categories;
  final bool isSubmitting;
  final void Function(String?) onCategoryChanged;
  final VoidCallback onSubmit;

  const _ReportForm({
    required this.formKey,
    required this.inputController,
    required this.descController,
    required this.selectedCategory,
    required this.categories,
    required this.isSubmitting,
    required this.onCategoryChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category dropdown
          Text(
            'THREAT TYPE',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                dropdownColor: const Color(0xFF111827),
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 14, color: Colors.white),
                iconEnabledColor: const Color(0xFF64748B),
                items: categories
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        ))
                    .toList(),
                onChanged: onCategoryChanged,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // URL / Content input
          Text(
            'SUSPICIOUS CONTENT',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: inputController,
            style: GoogleFonts.spaceGrotesk(
                fontSize: 14, color: Colors.white),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Paste the URL, phone number, or message...',
              hintStyle: GoogleFonts.spaceGrotesk(
                  fontSize: 13, color: const Color(0xFF334155)),
              filled: true,
              fillColor: const Color(0xFF111827),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1E293B)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1E293B)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFF00FF88), width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFF2D55)),
              ),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Please enter content to report' : null,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'ADDITIONAL DETAILS (OPTIONAL)',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: descController,
            style: GoogleFonts.spaceGrotesk(
                fontSize: 14, color: Colors.white),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Any extra context about this threat...',
              hintStyle: GoogleFonts.spaceGrotesk(
                  fontSize: 13, color: const Color(0xFF334155)),
              filled: true,
              fillColor: const Color(0xFF111827),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1E293B)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1E293B)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFF00FF88), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF2D55),
                disabledBackgroundColor:
                    const Color(0xFFFF2D55).withOpacity(0.4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.flag_rounded,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'SUBMIT REPORT',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  final VoidCallback onReset;
  const _SuccessState({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF00FF88).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: const Color(0xFF00FF88).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: Color(0xFF00FF88), size: 56),
          const SizedBox(height: 16),
          Text(
            'Report Submitted!',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thank you for helping protect the community. Our AI will verify your report and add it to the threat database.',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              color: const Color(0xFF94A3B8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: onReset,
            child: Text(
              'Submit Another Report',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                color: const Color(0xFF00FF88),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentReport {
  final String type;
  final String preview;
  final String location;
  final int reports;
  final Color color;

  const _RecentReport({
    required this.type,
    required this.preview,
    required this.location,
    required this.reports,
    required this.color,
  });
}

class _CommunityReportTile extends StatelessWidget {
  final _RecentReport report;
  const _CommunityReportTile({required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: report.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.flag_rounded, color: report.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      report.type,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: report.color,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '• ${report.location}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  report.preview,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(
                '${report.reports}',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                'reports',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
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

class _HelplineBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00D4FF).withOpacity(0.1),
            const Color(0xFF00FF88).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFF00D4FF).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.call_rounded,
              color: Color(0xFF00D4FF), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'National Cyber Helpline',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Call 1930 • cybercrime.gov.in',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: const Color(0xFF00D4FF),
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