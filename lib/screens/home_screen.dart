import 'package:flutter/material.dart';
import '../services/news_verification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/verification_result_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  bool _isLoading = false;
  VerificationResult? _result;
  String? _error;
  
  // Gemini API Key - Replace with your own key
  static const String _apiKey = 'AIzaSyCXAPywCi8HsErHALRMYjHRi_CRQtKjGYY';

  late final NewsVerificationService _verificationService;

  @override
  void initState() {
    super.initState();
    _verificationService = NewsVerificationService(apiKey: _apiKey);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _verifyNews() async {
    final input = _inputController.text.trim();
    
    if (input.isEmpty) {
      _showErrorDialog('Please enter a news article title or URL');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final result = await _verificationService.verifyNews(input);
      
      if (mounted) {
        setState(() {
          _result = result;
          _isLoading = false;
        });
        
        // Show result dialog
        _showResultDialog(result);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
        _showErrorDialog(_error!);
      }
    }
  }

  void _showResultDialog(VerificationResult result) {
    showDialog(
      context: context,
      builder: (context) => _ResultDialog(result: result),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.pastelRed,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.pastelRedDark,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Error',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              
              // Logo and title
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.pastelPurple,
                            AppColors.pastelBlue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.pastelPurpleDark.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.fact_check_rounded,
                        size: 40,
                        color: AppColors.pastelPurpleDark,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Legit',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'AI-Powered News Verification',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Input section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Enter news to verify',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Paste a URL or type a news headline to check its authenticity',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Text input
                    TextField(
                      controller: _inputController,
                      focusNode: _focusNode,
                      maxLines: 3,
                      minLines: 1,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _verifyNews(),
                      decoration: InputDecoration(
                        hintText: 'https://example.com/news-article or "Breaking: Major event..."',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 8),
                          child: Icon(
                            Icons.search_rounded,
                            color: AppColors.textMuted,
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 48,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Verify button
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyNews,
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.verified_user_rounded, size: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    'Verify News',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Results section
              if (_result != null) ...[
                VerificationResultCard(result: _result!),
                const SizedBox(height: 24),
              ],
              
              // Info cards
              if (_result == null && !_isLoading) ...[
                _buildInfoCard(
                  icon: Icons.link_rounded,
                  iconColor: AppColors.pastelBlueDark,
                  backgroundColor: AppColors.pastelBlue,
                  title: 'URL Analysis',
                  description: 'Paste a link to any news article and we\'ll fetch and analyze its content.',
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.title_rounded,
                  iconColor: AppColors.pastelPurpleDark,
                  backgroundColor: AppColors.pastelPurple,
                  title: 'Headline Check',
                  description: 'Enter a news headline or claim to verify its authenticity.',
                ),
              ],
              
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
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

class _ResultDialog extends StatelessWidget {
  final VerificationResult result;

  const _ResultDialog({required this.result});

  Color get _backgroundColor {
    switch (result.status) {
      case VerificationStatus.genuine:
        return AppColors.genuine;
      case VerificationStatus.fake:
        return AppColors.fake;
      case VerificationStatus.uncertain:
        return AppColors.uncertain;
    }
  }

  Color get _accentColor {
    switch (result.status) {
      case VerificationStatus.genuine:
        return AppColors.pastelGreenDark;
      case VerificationStatus.fake:
        return AppColors.pastelRedDark;
      case VerificationStatus.uncertain:
        return AppColors.pastelYellowDark;
    }
  }

  IconData get _statusIcon {
    switch (result.status) {
      case VerificationStatus.genuine:
        return Icons.verified_rounded;
      case VerificationStatus.fake:
        return Icons.dangerous_rounded;
      case VerificationStatus.uncertain:
        return Icons.help_outline_rounded;
    }
  }

  String get _statusText {
    switch (result.status) {
      case VerificationStatus.genuine:
        return 'Likely Genuine';
      case VerificationStatus.fake:
        return 'Likely Fake';
      case VerificationStatus.uncertain:
        return 'Uncertain';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _statusIcon,
                      color: _accentColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _statusText,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _accentColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${result.confidenceScore.toInt()}% confidence',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _accentColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.summary,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('View Full Analysis'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
