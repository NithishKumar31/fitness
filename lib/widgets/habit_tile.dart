import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../theme/app_colors.dart';

class HabitTile extends StatelessWidget {
  final HabitModel habit;
  final VoidCallback onToggle;

  const HabitTile({
    super.key,
    required this.habit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: habit.isCompletedToday
              ? (isDark ? AppColors.darkMint : AppColors.primaryGreen).withValues(alpha: 0.4)
              : (isDark ? AppColors.darkBorder : AppColors.borderLight),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: habit.isCompletedToday
                ? (isDark ? AppColors.darkMint : AppColors.primaryGreen).withValues(alpha: 0.08)
                : (isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.03)),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardElevated : AppColors.softMint.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.borderLight,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              habit.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      habit.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        decoration: habit.isCompletedToday ? TextDecoration.lineThrough : null,
                        color: habit.isCompletedToday
                            ? (isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight)
                            : (isDark ? AppColors.darkTextPrimary : AppColors.textDark),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardElevated : AppColors.warmCream,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${habit.completedDaysThisWeek}/7d',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkMint : AppColors.primaryGreenDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 7-day mini indicator dots
                Row(
                  children: List.generate(7, (index) {
                    final isFilled = index < habit.completedDaysThisWeek;
                    return Container(
                      margin: const EdgeInsets.only(right: 6),
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isFilled
                            ? (isDark ? AppColors.accentMintGradient : AppColors.primaryGradient)
                            : null,
                        color: isFilled ? null : (isDark ? AppColors.darkCardElevated : const Color(0xFFE2E8F0)),
                        boxShadow: isFilled
                            ? [
                                BoxShadow(
                                  color: (isDark ? AppColors.darkMint : AppColors.primaryGreen).withValues(alpha: 0.3),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: habit.isCompletedToday
                    ? (isDark ? AppColors.accentMintGradient : AppColors.primaryGradient)
                    : null,
                color: habit.isCompletedToday
                    ? null
                    : (isDark ? AppColors.darkCardElevated : Colors.white),
                border: Border.all(
                  color: habit.isCompletedToday
                      ? Colors.transparent
                      : (isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1)),
                  width: 1.5,
                ),
                boxShadow: habit.isCompletedToday
                    ? [
                        BoxShadow(
                          color: (isDark ? AppColors.darkMint : AppColors.primaryGreen).withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: habit.isCompletedToday
                  ? const Icon(Icons.check, size: 20, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

