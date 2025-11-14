import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/cards/module_card.dart';
import '../../../core/routing/route_paths.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matematik Ustası'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hoş Geldin! 👋',
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Bir modül seç ve pratik yapmaya başla',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  children: [
                    ModuleCard(
                      title: 'Toplama',
                      icon: Icons.add,
                      color: AppColors.additionColor,
                      onTap: () {
                        // TODO: Navigate to addition menu
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Toplama modülü yakında!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    ModuleCard(
                      title: 'Çıkarma',
                      icon: Icons.remove,
                      color: AppColors.subtractionColor,
                      onTap: () {
                        // TODO: Navigate to subtraction menu
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Çıkarma modülü yakında!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    ModuleCard(
                      title: 'Çarpma',
                      icon: Icons.close,
                      color: AppColors.multiplicationColor,
                      onTap: () {
                        // TODO: Navigate to multiplication menu
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Çarpma modülü yakında!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    ModuleCard(
                      title: 'Bölme',
                      icon: Icons.percent,
                      color: AppColors.divisionColor,
                      onTap: () {
                        // TODO: Navigate to division menu
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bölme modülü yakında!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
