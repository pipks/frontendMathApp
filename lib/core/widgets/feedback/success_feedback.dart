import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class SuccessFeedback extends StatelessWidget {
  final String message;
  final VoidCallback? onComplete;

  const SuccessFeedback({
    required this.message,
    this.onComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.success.withOpacity(0.95),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTextStyles.h1.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
