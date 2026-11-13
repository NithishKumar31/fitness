import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/mission_card.dart';
import '../widgets/habit_tile.dart';

class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Week days status (Simulated realistic Mon-Sun habit completion)
    final daysOfWeek = [
      {'day': 'Mon', 'done': true},
      {'day': 'Tue', 'done': true},
      {'day': 'Wed', 'done': true},
      {'day': 'Thu', 'done': false},
      {'day': 'Fri', 'done': appState.todayMission.completed},
      {'day': 'Sat', 'done': false},
      {'day': 'Sun', 'done': false},
    ];

    final completedDaysCount = daysOfWeek.where((d) => d['done'] as bool).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Missions & Streaks 🎯'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level & XP Bar Card
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
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
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Text('🏆', style: TextStyle(fontSize: 16)),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Level 4 • Mindful Pioneer',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              Text(
                                '480 / 600 XP to Level 5',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          '+30 XP Today',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryGreenDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 480 / 600,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Today's Mission
            MissionCard(
              mission: appState.todayMission,
              onToggleDone: () => appState.toggleTodayMissionDone(),
              onSwap: () => appState.swapMission(),
            ),
            const SizedBox(height: 24),

            // Weekly Calendar Card
            Container(
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
                    color: isDark ? Colors.black.withValues(alpha: 0.25) : const Color(0xFF0F172A).withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
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
                            child: const Icon(Icons.date_range_rounded, color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Weekly Rhythm',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCardElevated : AppColors.softMint,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '$completedDaysCount of 7 Days Active',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkMint : AppColors.primaryGreenDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: daysOfWeek.map((d) {
                      final isDone = d['done'] as bool;
                      final isToday = d['day'] == 'Fri';

                      return Column(
                        children: [
                          Text(
                            d['day'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                              color: isToday
                                  ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: isDone
                                  ? (isDark ? AppColors.accentMintGradient : AppColors.primaryGradient)
                                  : null,
                              color: isDone
                                  ? null
                                  : (isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9)),
                              border: Border.all(
                                color: isToday
                                    ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: isDone
                                  ? [
                                      BoxShadow(
                                        color: (isDark ? AppColors.darkMint : AppColors.primaryGreen).withValues(alpha: 0.35),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: isDone
                                ? const Icon(Icons.check, size: 18, color: Colors.white)
                                : Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1),
                                    ),
                                  ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardElevated.withValues(alpha: 0.5) : AppColors.warmCream,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Text('🌱', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '“Consistency is just taking one small step at a time, without rushing.”',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Daily Habit Tracker
            Text(
              'Habit Routines',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 14),
            ...appState.habits.map((habit) {
              return HabitTile(
                habit: habit,
                onToggle: () => appState.toggleHabit(habit.id),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

