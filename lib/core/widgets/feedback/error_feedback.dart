import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class ErrorFeedback extends StatelessWidget {
  final String message;
  final String? correctAnswer;
  final VoidCallback? onTryAgain;

  const ErrorFeedback({
    required this.message,
    this.correctAnswer,
    this.onTryAgain,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.error.withOpacity(0.95),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.close_rounded,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTextStyles.h1.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            if (correctAnswer != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                correctAnswer!,
                style: AppTextStyles.h2.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
