import 'package:flutter/material.dart';
import '../services/news_verification_service.dart';
import '../theme/app_theme.dart';

class VerificationResultCard extends StatelessWidget {
  final VerificationResult result;

  const VerificationResultCard({super.key, required this.result});

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

  Color get _textColor {
    switch (result.status) {
      case VerificationStatus.genuine:
        return AppColors.genuineText;
      case VerificationStatus.fake:
        return AppColors.fakeText;
      case VerificationStatus.uncertain:
        return AppColors.uncertainText;
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _statusIcon,
                    color: _accentColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _statusText,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Confidence: ${result.confidenceScore.toInt()}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _textColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Summary
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.summary,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Reasoning section
                const Text(
                  'Analysis',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    result.reasoning,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Key points section
                const Text(
                  'Key Points',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                ...result.keyPoints.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          point,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
