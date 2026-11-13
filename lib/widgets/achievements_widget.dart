import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';

class FitnessBadge {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int xp;
  final Color accentColor;
  final bool Function(AppStateProvider appState) isUnlocked;

  const FitnessBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.xp,
    required this.accentColor,
    required this.isUnlocked,
  });
}

class AchievementsWidget extends StatelessWidget {
  const AchievementsWidget({super.key});

  static final List<FitnessBadge> badges = [
    FitnessBadge(
      id: 'step_5k',
      title: '5K Pathfinder',
      description: 'Surpassed 5,000 steps in a single day.',
      icon: '🏆',
      xp: 150,
      accentColor: const Color(0xFFFF9500),
      isUnlocked: (state) => state.activity.steps >= 5000,
    ),
    FitnessBadge(
      id: 'streak_5',
      title: '5-Day Blaze',
      description: 'Maintained a 5-day active vitality streak.',
      icon: '🔥',
      xp: 200,
      accentColor: const Color(0xFFFF385C),
      isUnlocked: (_) => true, // User has active 5-day streak
    ),
    FitnessBadge(
      id: 'hydration_8',
      title: 'Hydration Hero',
      description: 'Reached full daily 2,000ml (8 glasses) hydration target.',
      icon: '💧',
      xp: 120,
      accentColor: const Color(0xFF00E5FF),
      isUnlocked: (state) => state.waterGlasses >= 8,
    ),
    FitnessBadge(
      id: 'zen_master',
      title: 'Zen Voyager',
      description: 'Completed a mindful breathwork meditation journey.',
      icon: '🧘',
      xp: 100,
      accentColor: const Color(0xFF8B5CF6),
      isUnlocked: (_) => true,
    ),
    FitnessBadge(
      id: 'ring_closer',
      title: 'Triple Victor',
      description: 'Closed all 3 daily activity rings (Steps, Calories & Time).',
      icon: '⭕',
      xp: 250,
      accentColor: const Color(0xFF00FF66),
      isUnlocked: (state) =>
          state.activity.steps >= state.activity.stepGoal &&
          state.activity.calories >= state.activity.calorieGoal,
    ),
    FitnessBadge(
      id: 'cadence_pro',
      title: 'Cadence 140+',
      description: 'Maintained optimal high-efficiency walking cadence.',
      icon: '⚡',
      xp: 180,
      accentColor: const Color(0xFFFFD600),
      isUnlocked: (_) => true,
    ),
  ];

  void _showBadgeDetails(BuildContext context, FitnessBadge badge, bool unlocked) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Glowing Badge Icon
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: badge.accentColor.withValues(alpha: unlocked ? 0.18 : 0.08),
                  border: Border.all(
                    color: unlocked ? badge.accentColor : Colors.grey.withValues(alpha: 0.3),
                    width: 2.5,
                  ),
                  boxShadow: unlocked
                      ? [
                          BoxShadow(
                            color: badge.accentColor.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  badge.icon,
                  style: TextStyle(
                    fontSize: 34,
                    color: unlocked ? null : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Title
              Text(
                badge.title,
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),

              // Status Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: unlocked
                      ? badge.accentColor.withValues(alpha: 0.15)
                      : Colors.grey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: unlocked
                        ? badge.accentColor.withValues(alpha: 0.5)
                        : Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  unlocked ? 'UNLOCKED • +${badge.xp} XP' : 'LOCKED • +${badge.xp} XP',
                  style: GoogleFonts.orbitron(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: unlocked ? badge.accentColor : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                badge.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 20),

              // Close / Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: unlocked ? badge.accentColor : const Color(0xFF334155),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    unlocked ? 'Keep Crushing It ⚡' : 'Back to Goals',
                    style: GoogleFonts.orbitron(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    int unlockedCount = 0;
    int totalXp = 0;
    for (final b in badges) {
      if (b.isUnlocked(appState)) {
        unlockedCount++;
        totalXp += b.xp;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DIGITAL ACHIEVEMENTS',
                    style: GoogleFonts.orbitron(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: const Color(0xFFFFD600),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Milestone Trophies & XP',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD600), Color(0xFFFF9500)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD600).withValues(alpha: 0.35),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('⭐ ', style: TextStyle(fontSize: 11)),
                    Text(
                      '$totalXp XP',
                      style: GoogleFonts.orbitron(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Level Progress Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF030712) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LEVEL 4 • VITALITY MASTER',
                      style: GoogleFonts.orbitron(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF00FF66),
                      ),
                    ),
                    Text(
                      '$unlockedCount / ${badges.length} Unlocked',
                      style: GoogleFonts.orbitron(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (unlockedCount / badges.length).clamp(0.0, 1.0),
                    minHeight: 7,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00FF66)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2x3 Badges Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: badges.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final badge = badges[index];
              final unlocked = badge.isUnlocked(appState);

              return GestureDetector(
                onTap: () => _showBadgeDetails(context, badge, unlocked),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: unlocked
                        ? badge.accentColor.withValues(alpha: isDark ? 0.12 : 0.08)
                        : (isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: unlocked
                          ? badge.accentColor.withValues(alpha: 0.6)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      width: unlocked ? 1.5 : 1,
                    ),
                    boxShadow: unlocked
                        ? [
                            BoxShadow(
                              color: badge.accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: unlocked
                              ? badge.accentColor.withValues(alpha: 0.2)
                              : Colors.grey.withValues(alpha: 0.15),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          badge.icon,
                          style: TextStyle(
                            fontSize: 20,
                            color: unlocked ? null : Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        badge.title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.orbitron(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: unlocked
                              ? (isDark ? Colors.white : const Color(0xFF0F172A))
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        unlocked ? '+${badge.xp} XP' : 'Locked',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w600,
                          color: unlocked ? badge.accentColor : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
