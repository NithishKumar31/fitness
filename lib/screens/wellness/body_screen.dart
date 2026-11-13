import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_colors.dart';
import '../live_session_screen.dart';

class BodyScreen extends StatefulWidget {
  const BodyScreen({super.key});

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  String? _overrideAgeGroup;

  void _showActivityDetail({
    required String title,
    required String icon,
    required String duration,
    required List<String> steps,
    required String gentleTip,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkCard
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Estimated time: $duration',
                        style: const TextStyle(fontSize: 13, color: AppColors.primaryGreen, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Simple Steps:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            ...steps.map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Expanded(
                        child: Text(
                          step,
                          style: const TextStyle(fontSize: 14, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.softMint.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Text('💡 ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      gentleTip,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton.icon(
              icon: const Icon(Icons.timer_outlined, size: 20),
              label: Text('Start Live Timer ($duration) ⏱️'),
              onPressed: () {
                Navigator.pop(ctx);
                final int minutes = int.tryParse(duration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 15;
                final isMeditation = title.toLowerCase().contains('stretch') ||
                    title.toLowerCase().contains('breath') ||
                    title.toLowerCase().contains('sleep') ||
                    title.toLowerCase().contains('meditat');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LiveSessionScreen(
                      type: isMeditation ? SessionType.meditation : SessionType.walking,
                      initialMinutes: minutes > 0 ? minutes : 15,
                      title: title,
                      icon: icon,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Awesome job moving your body today! $icon')),
                );
              },
              child: const Text('Log Manually ✓'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final activeAgeGroup = _overrideAgeGroup ?? appState.user.ageGroup;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Body 🫀'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Small movements. Better everyday energy.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
              ),
            ),
            const SizedBox(height: 16),
            // Age Group Selector Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_pin_circle_rounded, size: 20, color: AppColors.primaryGreen),
                      const SizedBox(width: 8),
                      Text(
                        'Your age group: $activeAgeGroup',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Recommendations adapt safely for each chapter of life. Tap to view any group:',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: ['10–17', '18–40', '41–50', '50+'].map((group) {
                      final isSelected = activeAgeGroup == group;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: GestureDetector(
                            onTap: () => setState(() => _overrideAgeGroup = group),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                    : (isDark ? AppColors.darkSurface : AppColors.warmCream),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                group,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? (isDark ? AppColors.darkCanvas : Colors.white)
                                      : (isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Personalized Movement Cards',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            // Dynamic Cards based on Age Group
            ..._buildCardsForAgeGroup(activeAgeGroup),
            const SizedBox(height: 20),
            // Safety reminder banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.warmCream,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.favorite_border_rounded, size: 20, color: AppColors.primaryGreen),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Always choose activities appropriate for your abilities and comfort. Listen to your body and seek professional medical guidance when needed.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCardsForAgeGroup(String age) {
    if (age == '10–17') {
      return [
        _buildActivityTile(
          icon: '🏏',
          title: 'Sports & Play',
          description: 'Cricket, football, badminton, or playground tag with friends.',
          duration: '20 min',
          steps: [
            'Warm up with light jumping jacks and arm circles.',
            'Play a casual game without worrying about winning.',
            'Enjoy the fresh energy and laugh with friends.',
          ],
          tip: 'Movement is about play and joy, never calorie counting or body comparison.',
        ),
        _buildActivityTile(
          icon: '🚶',
          title: 'Exploration Walk',
          description: 'Take a fun stroll around your neighborhood or school park.',
          duration: '15 min',
          steps: [
            'Wear comfortable footwear.',
            'Notice interesting trees, birds, or cloud shapes.',
            'Walk at a steady, enjoyable pace.',
          ],
          tip: 'Walking clears your thoughts after hours of study.',
        ),
        _buildActivityTile(
          icon: '🧘',
          title: 'Simple Stretching',
          description: 'Gentle toe touches and sky reaches to stay limber.',
          duration: '8 min',
          steps: [
            'Reach up to the sky as high as you can.',
            'Gently fold forward toward your knees.',
            'Breathe naturally and do not force any stretch.',
          ],
          tip: 'Keeps growing muscles flexible and relaxed.',
        ),
        _buildActivityTile(
          icon: '🚴',
          title: 'Outdoor Activity',
          description: 'Ride a bicycle or spend time in nature under sunlight.',
          duration: '20 min',
          steps: [
            'Wear a helmet if cycling.',
            'Enjoy the wind and open air.',
          ],
          tip: 'Sunlight and fresh air boost natural circadian rhythms.',
        ),
        _buildActivityTile(
          icon: '😴',
          title: 'Healthy Sleep Routine',
          description: 'Wind down at a predictable hour for healthy growth and energy.',
          duration: 'Bedtime',
          steps: [
            'Turn off screens 30 minutes before sleep.',
            'Keep your room cool and quiet.',
          ],
          tip: 'Quality sleep is when your body and mind refresh and grow.',
        ),
      ];
    } else if (age == '18–40') {
      return [
        _buildActivityTile(
          icon: '🚶',
          title: 'Brisk Walking Reset',
          description: '15-minute walk to recharge your stamina and clear mental fatigue.',
          duration: '15 min',
          steps: [
            'Step away from desk or screens.',
            'Maintain an upright, comfortable posture.',
            'Breathe in rhythm with your footsteps.',
          ],
          tip: 'Even 15 minutes of walking reduces stress and lifts energy.',
        ),
        _buildActivityTile(
          icon: '💪',
          title: 'Everyday Strength',
          description: 'Simple bodyweight squats, wall push-ups, or core stability.',
          duration: '10 min',
          steps: [
            'Do 10 gentle chair squats.',
            'Try 10 easy wall or desk push-ups.',
            'Hold a gentle 20-second plank or torso brace.',
          ],
          tip: 'Builds functional support for daily tasks.',
        ),
        _buildActivityTile(
          icon: '🧘',
          title: 'Hip & Spine Mobility',
          description: 'Relieve sitting stiffness with gentle cat-cow and hip openers.',
          duration: '8 min',
          steps: [
            'Gentle spinal twists while seated or on a mat.',
            'Cat-cow arching to mobilize your back.',
            'Easy hamstring stretch.',
          ],
          tip: 'Perfect for mid-day breaks during work or study.',
        ),
        _buildActivityTile(
          icon: '😴',
          title: 'Consistent Sleep Window',
          description: 'Consistent sleep and wake times to optimize daily vitality.',
          duration: 'Night',
          steps: [
            'Dim overhead lights 45 minutes prior.',
            'Sip warm water or caffeine-free herbal tea.',
          ],
          tip: 'A steady sleep rhythm is the foundation of everyday energy.',
        ),
        _buildActivityTile(
          icon: '💧',
          title: 'Hydration Rhythm',
          description: 'Keep a water bottle nearby and drink steady small sips.',
          duration: 'Daily',
          steps: [
            'Drink one glass upon waking up.',
            'Take a sip every time you complete a task.',
          ],
          tip: 'Hydration helps sustain concentration and joint comfort.',
        ),
      ];
    } else if (age == '41–50') {
      return [
        _buildActivityTile(
          icon: '🚶',
          title: 'Gentle Walking Rhythm',
          description: 'Smooth, unhurried walking to support cardiovascular circulation.',
          duration: '20 min',
          steps: [
            'Walk at a comfortable conversational pace.',
            'Swing arms gently at your sides.',
            'Focus on soft footfalls.',
          ],
          tip: 'Consistent gentle walks protect joint health.',
        ),
        _buildActivityTile(
          icon: '🧘',
          title: 'Joint Mobility & Flow',
          description: 'Shoulder circles, neck releases, and gentle hip rotations.',
          duration: '10 min',
          steps: [
            'Slow neck rolls side to side.',
            'Shoulder rotations forward and backward.',
            'Ankle rolls and knee warm-ups.',
          ],
          tip: 'Preserves range of motion and eases morning stiffness.',
        ),
        _buildActivityTile(
          icon: '💪',
          title: 'Appropriate Strength Care',
          description: 'Low-impact muscle activation to protect bone density.',
          duration: '12 min',
          steps: [
            'Sit-to-stand repetitions from a sturdy chair.',
            'Gentle calf raises holding a counter.',
            'Light resistance band pulls if available.',
          ],
          tip: 'Strong muscles protect tendons and joints.',
        ),
        _buildActivityTile(
          icon: '⚖️',
          title: 'Balance & Stability Practice',
          description: 'Single-leg stands near a table and heel-to-toe walking.',
          duration: '5 min',
          steps: [
            'Stand near a sturdy counter for safety.',
            'Lift one foot slightly off the floor for 15 seconds.',
            'Switch legs and repeat 3 times.',
          ],
          tip: 'Balance training builds lasting confidence in everyday movements.',
        ),
        _buildActivityTile(
          icon: '😴',
          title: 'Restorative Sleep Practice',
          description: 'Quiet wind-down ritual to support deep restorative sleep.',
          duration: 'Bedtime',
          steps: [
            'Gentle leg propping or relaxation breathing.',
            'Keep bedroom quiet and darkened.',
          ],
          tip: 'Allows your nervous system to fully recuperate.',
        ),
      ];
    } else {
      // 50+
      return [
        _buildActivityTile(
          icon: '🚶',
          title: 'Gentle Comfort Walk',
          description: 'Comfortable walking at your own pace on flat, safe surfaces.',
          duration: '15 min',
          steps: [
            'Wear well-cushioned, supportive shoes.',
            'Walk on even pathways with good visibility.',
            'Rest whenever you need to.',
          ],
          tip: 'Walking is one of the kindest gifts you can give your heart and mind.',
        ),
        _buildActivityTile(
          icon: '🧘',
          title: 'Seated Flexibility & Stretching',
          description: 'Comfortable seated stretches to keep muscles soft and supple.',
          duration: '10 min',
          steps: [
            'Sit tall on a secure chair.',
            'Gentle side neck stretches.',
            'Wrist and finger stretches.',
            'Gentle seated torso rotation.',
          ],
          tip: 'Stretching can be done completely comfortably in a chair.',
        ),
        _buildActivityTile(
          icon: '⚖️',
          title: 'Safe Balance Exercises',
          description: 'Supported heel raises and posture holds next to a sturdy rail.',
          duration: '6 min',
          steps: [
            'Hold onto a sturdy table or kitchen counter.',
            'Rise gently onto your toes, then lower smoothly.',
            'Practice standing tall with eyes focused ahead.',
          ],
          tip: 'Safety first: always keep a steady hand support nearby.',
        ),
        _buildActivityTile(
          icon: '💪',
          title: 'Appropriate Strength Movement',
          description: 'Light chair push-ups, knee lifts, and gentle arm extensions.',
          duration: '8 min',
          steps: [
            'Seated knee lifts holding the chair seat.',
            'Gently press hands against your knees for isometric tone.',
          ],
          tip: 'Helps maintain ease when getting up and climbing stairs.',
        ),
        _buildActivityTile(
          icon: '❤️',
          title: 'Social Activity & Walk',
          description: 'Share a gentle walk or garden visit with friends or family.',
          duration: '20 min',
          steps: [
            'Invite a neighbor, child, or friend along.',
            'Combine light movement with enjoyable conversation.',
          ],
          tip: 'Connection and movement together nurture overall wellbeing.',
        ),
      ];
    }
  }

  Widget _buildActivityTile({
    required String icon,
    required String title,
    required String description,
    required String duration,
    required List<String> steps,
    required String tip,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.softCanvasLight,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => _showActivityDetail(
              title: title,
              icon: icon,
              duration: duration,
              steps: steps,
              gentleTip: tip,
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(64, 38),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            child: const Text('Start', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
