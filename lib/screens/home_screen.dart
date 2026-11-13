import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/mood_selector.dart';
import '../widgets/mission_card.dart';
import '../widgets/circular_progress_widget.dart';
import '../widgets/activity_rings_widget.dart';
import 'daily_checkin_screen.dart';
import 'progress_screen.dart';
import 'activity_tracker_screen.dart';
import 'wellness/mind_screen.dart';
import 'wellness/body_screen.dart';
import 'live_session_screen.dart';
import '../widgets/digital_smartwatch_widget.dart';
import '../widgets/digital_hydration_widget.dart';
import '../widgets/weekly_trends_widget.dart';
import '../widgets/digital_bio_scanner_widget.dart';
import '../widgets/digital_compass_widget.dart';
import 'wellness/self_care_screen.dart';
import 'wellness/relationships_screen.dart';
import 'wellness/purpose_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onNavigateToExplore;
  final VoidCallback? onNavigateToAi;

  const HomeScreen({
    super.key,
    this.onNavigateToExplore,
    this.onNavigateToAi,
  });

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top User Section with Avatar & Streak Pill
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${_getTimeBasedGreeting()}, ${appState.user.name}',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text('👋', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Your holistic vitality dashboard",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Streak Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isDark ? AppColors.darkHeroGradient : AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: (isDark ? AppColors.darkMint : AppColors.primaryGreen).withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🔥', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 4),
                        Text(
                          '5 Days',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Hero Vitality Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: isDark ? AppColors.heroGradient : AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '✨ Daily Inspiration',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onNavigateToAi,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🤖', style: TextStyle(fontSize: 12)),
                                SizedBox(width: 4),
                                Text(
                                  'Ask AI Coach',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryGreenDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      '"One mindful breath can reset your entire day."',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LiveSessionScreen(
                                  type: SessionType.meditation,
                                  initialMinutes: 2,
                                  title: '2-Minute Breathwork Reset',
                                  icon: '🌬️',
                                ),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.air_rounded, color: Colors.white, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    '2-Min Breath',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DailyCheckInScreen()),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit_note_rounded, color: AppColors.primaryGreenDark, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'Check In',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryGreenDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Mood Card
              MoodSelectorCard(
                selectedMood: appState.currentMood,
                supportiveMessage: appState.supportiveMessage,
                onMoodSelected: (mood) => appState.selectMood(mood),
              ),
              const SizedBox(height: 22),

              // Digital Smartwatch Live HUD Card
              DigitalSmartwatchWidget(
                steps: appState.activity.steps,
                stepGoal: appState.activity.stepGoal,
                calories: appState.activity.calories,
                distanceKm: appState.activity.distanceKm,
                onStartWorkout: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LiveSessionScreen(
                        type: SessionType.walking,
                        initialMinutes: 15,
                        title: 'Daily Walk',
                        icon: '👟',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 22),

              // Activity & Step Tracker Card
              _buildActivityCard(context, appState, isDark),
              const SizedBox(height: 22),

              // Weekly Activity Trends & Streak Card
              const WeeklyTrendsWidget(),
              const SizedBox(height: 22),

              // Digital ECG Bio-Scanner & HR Zones Card
              const DigitalBioScannerWidget(),
              const SizedBox(height: 22),

              // Digital Hydration Vitality Tracker Card
              const DigitalHydrationWidget(),
              const SizedBox(height: 22),

              // Digital Smartwatch Compass & Altimeter HUD Card
              const DigitalCompassWidget(),
              const SizedBox(height: 22),

              // Today's Mission Card
              MissionCard(
                mission: appState.todayMission,
                onToggleDone: () => appState.toggleTodayMissionDone(),
                onSwap: () => appState.swapMission(),
              ),
              const SizedBox(height: 26),

              // Quick Access to 5 Wellness Areas Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Five Wellbeing Paths',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (onNavigateToExplore != null)
                    GestureDetector(
                      onTap: onNavigateToExplore,
                      child: Text(
                        'View All →',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildPathCard(
                      context,
                      icon: '🧠',
                      title: 'Mind',
                      subtitle: 'Calm & focus',
                      gradient: const [Color(0xFFFF3366), Color(0xFFFF6B00)],
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MindScreen())),
                    ),
                    _buildPathCard(
                      context,
                      icon: '🫀',
                      title: 'Body',
                      subtitle: 'Power & flow',
                      gradient: const [Color(0xFFE11D48), Color(0xFFF97316)],
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BodyScreen())),
                    ),
                    _buildPathCard(
                      context,
                      icon: '✨',
                      title: 'Self-Care',
                      subtitle: 'Rest & warmth',
                      gradient: const [Color(0xFFFF5722), Color(0xFFF59E0B)],
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SelfCareScreen())),
                    ),
                    _buildPathCard(
                      context,
                      icon: '🤝',
                      title: 'Connection',
                      subtitle: 'Kind bonds',
                      gradient: const [Color(0xFFBE123C), Color(0xFFFF4081)],
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RelationshipsScreen())),
                    ),
                    _buildPathCard(
                      context,
                      icon: '🎯',
                      title: 'Purpose',
                      subtitle: 'Joy & spark',
                      gradient: const [Color(0xFFEA580C), Color(0xFFFBBF24)],
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PurposeScreen())),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              // Rejuvenation Progress Card
              CircularProgressCard(
                progress: appState.progress,
                onTapDetails: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProgressScreen()),
                ),
              ),
              const SizedBox(height: 22),

              // Daily Reflection Full Card
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DailyCheckInScreen()),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(24),
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
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCardElevated : AppColors.softMint,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.fact_check_rounded,
                          color: AppColors.primaryGreen,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daily Reflection & Check-In',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '6 gentle steps to renew, align & ground your day',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: isDark ? AppColors.accentMintGradient : AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Start →',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPathCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 136,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.borderLight,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient.first.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(icon, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, AppStateProvider appState, bool isDark) {
    final activity = appState.activity;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : const Color(0xFF0F172A).withValues(alpha: 0.04),
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
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF385C).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🔥', style: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Activity & Movement',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ActivityTrackerScreen()),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ActivityTrackerScreen()),
              );
            },
            child: Row(
              children: [
                ActivityRingsWidget(
                  size: 96,
                  stepProgress: activity.stepProgress,
                  calorieProgress: activity.calorieProgress,
                  activeMinutesProgress: activity.activeMinutesProgress,
                  centerChild: const Text('👟', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${activity.steps}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '/ ${activity.stepGoal} steps',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: activity.stepProgress,
                          minHeight: 6,
                          backgroundColor: isDark ? Colors.white12 : const Color(0xFFF1F5F9),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark ? const Color(0xFFFF5722) : AppColors.primaryGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            '🔥 ${activity.calories} kcal',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            '📍 ${activity.distanceKm} km',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 10),
          // Quick Tap Buttons
          Row(
            children: [
              Text(
                'Quick Log:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                ),
              ),
              const SizedBox(width: 8),
              _buildHomeQuickStepChip(context, appState, '+250', 250, isDark),
              const SizedBox(width: 6),
              _buildHomeQuickStepChip(context, appState, '+500', 500, isDark),
              const SizedBox(width: 6),
              _buildHomeQuickStepChip(context, appState, '+1,000', 1000, isDark),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LiveSessionScreen(
                    type: SessionType.walking,
                    initialMinutes: 15,
                    title: 'Daily Walk',
                    icon: '👟',
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_walk_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Start Real-Time Walk ⏱️',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeQuickStepChip(
    BuildContext context,
    AppStateProvider appState,
    String label,
    int steps,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        appState.addSteps(steps);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label steps added! 👟 Keep moving!'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : AppColors.warmCream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkMint : AppColors.primaryGreenDark,
          ),
        ),
      ),
    );
  }
}

