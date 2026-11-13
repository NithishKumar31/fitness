import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/progress_model.dart';

class CircularProgressCard extends StatelessWidget {
  final ProgressModel progress;
  final VoidCallback? onTapDetails;

  const CircularProgressCard({
    super.key,
    required this.progress,
    this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: isDark ? AppColors.accentMintGradient : AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Vitality & Balance',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              if (onTapDetails != null)
                GestureDetector(
                  onTap: onTapDetails,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardElevated : AppColors.softMint,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (isDark ? AppColors.darkMint : AppColors.primaryGreen).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Insights',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkMint : AppColors.primaryGreenDark,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: isDark ? AppColors.darkMint : AppColors.primaryGreenDark,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Circular Progress Indicator (Wearable / Ring style)
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 104,
                      height: 104,
                      child: CircularProgressIndicator(
                        value: progress.overallProgress,
                        strokeWidth: 10,
                        backgroundColor: isDark
                            ? AppColors.darkCardElevated
                            : AppColors.softMint.withValues(alpha: 0.5),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? AppColors.darkMint : AppColors.primaryGreen,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${progress.overallPercentage}%',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                          ),
                        ),
                        Text(
                          'Score',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Category Progress Bars
              Expanded(
                child: Column(
                  children: [
                    _buildCategoryRow(
                      context,
                      label: '🧠 Mind',
                      percentage: progress.mindPercentage,
                      color: AppColors.softBlue,
                    ),
                    const SizedBox(height: 8),
                    _buildCategoryRow(
                      context,
                      label: '🫀 Body',
                      percentage: progress.bodyPercentage,
                      color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                    ),
                    const SizedBox(height: 8),
                    _buildCategoryRow(
                      context,
                      label: '✨ Self-Care',
                      percentage: progress.selfCarePercentage,
                      color: AppColors.warmCoral,
                    ),
                    const SizedBox(height: 8),
                    _buildCategoryRow(
                      context,
                      label: '🤝 Friends',
                      percentage: progress.relationshipPercentage,
                      color: AppColors.softLavender,
                    ),
                    const SizedBox(height: 8),
                    _buildCategoryRow(
                      context,
                      label: '🎯 Purpose',
                      percentage: progress.purposePercentage,
                      color: AppColors.warmAmber,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Non-medical wellbeing progress label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCardElevated.withValues(alpha: 0.5)
                  : AppColors.warmCream,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.borderLight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_rounded,
                  size: 16,
                  color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Consistent habits compound into extraordinary vitality.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(
    BuildContext context, {
    required String label,
    required int percentage,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        SizedBox(
          width: 95,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percentage / 100.0,
              minHeight: 6,
              backgroundColor: isDark
                  ? AppColors.darkCardElevated
                  : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            '$percentage%',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
            ),
          ),
        ),
      ],
    );
  }
}

