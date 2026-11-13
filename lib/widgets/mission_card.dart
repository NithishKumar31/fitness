import 'package:flutter/material.dart';
import '../models/mission_model.dart';
import '../theme/app_colors.dart';

class MissionCard extends StatelessWidget {
  final MissionModel mission;
  final VoidCallback onToggleDone;
  final VoidCallback? onSwap;

  const MissionCard({
    super.key,
    required this.mission,
    required this.onToggleDone,
    this.onSwap,
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
          color: mission.completed
              ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
              : (isDark ? AppColors.darkBorder : AppColors.borderLight),
          width: mission.completed ? 1.6 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: mission.completed
                ? (isDark ? AppColors.darkMint : AppColors.primaryGreen).withValues(alpha: 0.12)
                : (isDark ? Colors.black.withValues(alpha: 0.25) : const Color(0xFF0F172A).withValues(alpha: 0.04)),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: isDark ? AppColors.accentMintGradient : AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('⚡', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 4),
                    Text(
                      "Daily Focus Mission",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardElevated : AppColors.softMint,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '+30 XP',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkMint : AppColors.primaryGreenDark,
                  ),
                ),
              ),
              const Spacer(),
              if (onSwap != null && !mission.completed)
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardElevated : AppColors.warmCream,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    onPressed: onSwap,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    tooltip: 'Swap with another gentle mission',
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    padding: EdgeInsets.zero,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? LinearGradient(
                          colors: [
                            AppColors.darkCardElevated,
                            AppColors.darkCardElevated.withValues(alpha: 0.5),
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            AppColors.softMint.withValues(alpha: 0.8),
                            AppColors.softMint.withValues(alpha: 0.3),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  mission.icon,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        decoration: mission.completed ? TextDecoration.lineThrough : null,
                        color: mission.completed
                            ? (isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mission.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Action Button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: mission.completed
                ? GestureDetector(
                    key: const ValueKey('completed'),
                    onTap: onToggleDone,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardElevated : AppColors.softMint.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 20,
                            color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Completed! Tap to undo',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkMint : AppColors.primaryGreenDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : GestureDetector(
                    key: const ValueKey('uncompleted'),
                    onTap: onToggleDone,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: isDark ? AppColors.accentMintGradient : AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark ? AppColors.darkMint : AppColors.primaryGreen).withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Mark as Done ✓',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

