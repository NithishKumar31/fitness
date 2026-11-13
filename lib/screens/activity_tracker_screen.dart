import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/activity_rings_widget.dart';
import 'ai_chat_screen.dart';
import 'live_session_screen.dart';
import '../widgets/digital_smartwatch_widget.dart';
import '../widgets/weekly_trends_widget.dart';
import '../widgets/digital_hydration_widget.dart';
import '../widgets/digital_bio_scanner_widget.dart';
import '../widgets/digital_compass_widget.dart';

class ActivityTrackerScreen extends StatefulWidget {
  const ActivityTrackerScreen({super.key});

  @override
  State<ActivityTrackerScreen> createState() => _ActivityTrackerScreenState();
}

class _ActivityTrackerScreenState extends State<ActivityTrackerScreen> {
  void _showGoalBottomSheet(BuildContext context, AppStateProvider appState) {
    final currentGoal = appState.activity.stepGoal;
    final options = [6000, 8000, 10000, 12000, 15000];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Customize Daily Step Goal',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose a target that supports your daily vitality and energy rhythm.',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: options.map((goal) {
                  final isSelected = goal == currentGoal;
                  return GestureDetector(
                    onTap: () {
                      appState.setStepGoal(goal);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Daily step target updated to $goal steps! 🎯'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          backgroundColor: AppColors.primaryGreen,
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? (isDark ? AppColors.accentMintGradient : AppColors.primaryGradient)
                            : null,
                        color: isSelected ? null : (isDark ? AppColors.darkCard : AppColors.warmCream),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                        ),
                      ),
                      child: Text(
                        '$goal steps',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.darkTextPrimary : AppColors.textDark),
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
    final activity = appState.activity;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Step & Calorie Burn 🔥',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Customize Step Target',
            onPressed: () => _showGoalBottomSheet(context, appState),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Triple Activity Rings Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.35)
                              : const Color(0xFF0F172A).withValues(alpha: 0.05),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ActivityRingsWidget(
                          size: 146,
                          stepProgress: activity.stepProgress,
                          calorieProgress: activity.calorieProgress,
                          activeMinutesProgress: activity.activeMinutesProgress,
                          centerChild: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('👟', style: TextStyle(fontSize: 22)),
                              const SizedBox(height: 2),
                              Text(
                                '${(activity.stepProgress * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRingStatRow(
                                color: const Color(0xFFFF385C),
                                label: 'Steps',
                                value: '${activity.steps}',
                                target: '/ ${activity.stepGoal}',
                                isDark: isDark,
                              ),
                              const SizedBox(height: 12),
                              _buildRingStatRow(
                                color: const Color(0xFFFF9500),
                                label: 'Active Burn',
                                value: '${activity.calories}',
                                target: '/ ${activity.calorieGoal} kcal',
                                isDark: isDark,
                              ),
                              const SizedBox(height: 12),
                              _buildRingStatRow(
                                color: const Color(0xFF10B981),
                                label: 'Active Time',
                                value: '${activity.activeMinutes}',
                                target: '/ ${activity.activeMinutesGoal}m',
                                isDark: isDark,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 1b. Digital Smartwatch Live HUD Card
                  DigitalSmartwatchWidget(
                    steps: activity.steps,
                    stepGoal: activity.stepGoal,
                    calories: activity.calories,
                    distanceKm: activity.distanceKm,
                    onStartWorkout: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LiveSessionScreen(
                            type: SessionType.walking,
                            initialMinutes: 15,
                            title: 'Walking Workout',
                            icon: '👟',
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Digital ECG Bio-Scanner & Heart Rate Zones
                  const DigitalBioScannerWidget(),

                  const SizedBox(height: 20),

                  // 1b. Real-Time Walking Workout Launcher Card
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LiveSessionScreen(
                            type: SessionType.walking,
                            initialMinutes: 15,
                            title: 'Walking Workout',
                            icon: '👟',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                      decoration: BoxDecoration(
                        gradient: isDark
                            ? AppColors.accentMintGradient
                            : AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                .withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Text('👟', style: TextStyle(fontSize: 20)),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start Real-Time Walk',
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Live continuous seconds, steps & completion alarm',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'Start',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 2. Interactive Quick Add Steps Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quick Step Logging',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '+ Tap to log',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildQuickLogPill(context, appState, '+250', 'Room pacing', 250, isDark),
                        _buildQuickLogPill(context, appState, '+500', 'Coffee walk', 500, isDark),
                        _buildQuickLogPill(context, appState, '+1,000', 'Brisk stroll', 1000, isDark),
                        _buildQuickLogPill(context, appState, '+2,500', 'Outdoor jog', 2500, isDark),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. Key Vitality Metrics 4-Grid
                  Text(
                    "Today's Movement Metrics",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          icon: Icons.straighten_rounded,
                          title: 'Distance',
                          value: '${activity.distanceKm} km',
                          color: const Color(0xFF3B82F6),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildMetricTile(
                          icon: Icons.local_fire_department_rounded,
                          title: 'Total Burn',
                          value: '${activity.calories} kcal',
                          color: const Color(0xFFFF5722),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          icon: Icons.speed_rounded,
                          title: 'Average Pace',
                          value: "14'10\"/km",
                          color: const Color(0xFF10B981),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildMetricTile(
                          icon: Icons.stairs_rounded,
                          title: 'Floors Climbed',
                          value: '${(activity.steps / 800).clamp(1, 40).toInt()} floors',
                          color: const Color(0xFF8B5CF6),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // 4. Hourly Activity Distribution Chart
                  Text(
                    "Today's Hourly Trend",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Peak hour: 6:00 PM (Active evening)',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Total: ${activity.steps} steps',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkMint : AppColors.primaryGreenDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildHourlyBarChart(activity.hourlySteps, activity.steps, isDark),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 5. 7-Day Weekly History & Streak (Digital Smartwatch Analytics)
                  const WeeklyTrendsWidget(),

                  const SizedBox(height: 24),

                  // 5b. Digital Hydration Vitality Tracker
                  const DigitalHydrationWidget(),

                  const SizedBox(height: 24),

                  // 5c. Digital Compass & GPS Telemetry Altimeter
                  const DigitalCompassWidget(),

                  const SizedBox(height: 28),

                  // 6. AI Coach Walking Encouragement Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
                      borderRadius: BorderRadius.circular(28),
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
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Text('✨', style: TextStyle(fontSize: 16)),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'AI Coach Movement Insight',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'You have walked ${activity.distanceKm} km today—that is roughly equal to crossing 6 scenic neighborhood parks! Keep your rhythm gentle and stay hydrated.',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AiChatScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🤖', style: TextStyle(fontSize: 13)),
                                SizedBox(width: 6),
                                Text(
                                  'Ask AI for a Walking Mission',
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRingStatRow({
    required Color color,
    required String label,
    required String value,
    required String target,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 4),
                Text(
                  target,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickLogPill(
    BuildContext context,
    AppStateProvider appState,
    String count,
    String subtitle,
    int steps,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          appState.addSteps(steps);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$count steps logged! Keep moving forward! 👟'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.borderLight,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.15)
                    : const Color(0xFF0F172A).withValues(alpha: 0.03),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
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
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyBarChart(List<int> hourlySteps, int totalSteps, bool isDark) {
    final times = ['6 AM', '9 AM', '12 PM', '3 PM', '6 PM', '9 PM'];
    final maxStep = totalSteps > 0 ? totalSteps.toDouble() : 10000.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(times.length, (i) {
        final val = i < hourlySteps.length ? hourlySteps[i] : (valRatio(i) * totalSteps).toInt();
        final ratio = (val / maxStep).clamp(0.12, 1.0);
        final isPeak = i == 4; // 6 PM

        return Column(
          children: [
            Container(
              width: 22,
              height: (90.0 * ratio).toDouble(),
              decoration: BoxDecoration(
                gradient: isPeak
                    ? (isDark ? AppColors.accentMintGradient : AppColors.primaryGradient)
                    : null,
                color: isPeak ? null : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              times[i],
              style: TextStyle(
                fontSize: 10,
                fontWeight: isPeak ? FontWeight.w800 : FontWeight.w500,
                color: isPeak
                    ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                    : (isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight),
              ),
            ),
          ],
        );
      }),
    );
  }

  double valRatio(int index) {
    const ratios = [0.10, 0.25, 0.45, 0.60, 0.85, 1.0];
    return ratios[index % ratios.length];
  }
}
