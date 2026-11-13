import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'wellness/mind_screen.dart';
import 'wellness/body_screen.dart';
import 'wellness/self_care_screen.dart';
import 'wellness/relationships_screen.dart';
import 'wellness/purpose_screen.dart';
import 'activity_tracker_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore & Renew ✨'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Curated experiences to rejuvenate your mind & body.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
              ),
            ),
            const SizedBox(height: 18),

            // Daily Spotlight Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.25),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('⭐', style: TextStyle(fontSize: 12)),
                            SizedBox(width: 4),
                            Text(
                              'Featured Spotlight',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          '3 Mins',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Full-Body Tension Release',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Melt away spinal and neck tightness with 4 gentle stretches.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BodyScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow_rounded, color: AppColors.primaryGreenDark, size: 20),
                          SizedBox(width: 6),
                          Text(
                            'Begin Session',
                            style: TextStyle(
                              fontSize: 13,
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
            const SizedBox(height: 24),

            // 5 Large Category Cards
            Text(
              'Wellness Dimensions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 14),

            _buildLargeExploreCard(
              context,
              emoji: '🧠',
              title: 'Mind Sanctuary',
              description: 'Calm mental chatter, breathe with rhythm, and gain clarity.',
              gradient: const [Color(0xFFFF3366), Color(0xFFFF6B00)],
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MindScreen())),
            ),
            _buildLargeExploreCard(
              context,
              emoji: '🫀',
              title: 'Body Vitality',
              description: 'Gentle mobility, joyful movement, and everyday energy.',
              gradient: const [Color(0xFFE11D48), Color(0xFFF97316)],
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BodyScreen())),
            ),
            _buildLargeExploreCard(
              context,
              emoji: '🔥',
              title: 'Step & Calorie Burn Tracker',
              description: 'Activity rings, live steps, active calorie burn, distance, and streak.',
              gradient: const [Color(0xFFFF385C), Color(0xFFFF7A00)],
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityTrackerScreen())),
            ),
            _buildLargeExploreCard(
              context,
              emoji: '✨',
              title: 'Radiant Self-Care',
              description: 'Restorative sleep hygiene, nourishing foods, and comfort.',
              gradient: const [Color(0xFFFF5722), Color(0xFFF59E0B)],
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SelfCareScreen())),
            ),
            _buildLargeExploreCard(
              context,
              emoji: '🤝',
              title: 'Soulful Connection',
              description: 'Deepen bonds with friends, practice appreciation and kindness.',
              gradient: const [Color(0xFFBE123C), Color(0xFFFF4081)],
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RelationshipsScreen())),
            ),
            _buildLargeExploreCard(
              context,
              emoji: '🎯',
              title: 'Life Purpose & Joy',
              description: 'Ignite creative spark, curiosity, gratitude, and daily meaning.',
              gradient: const [Color(0xFFEA580C), Color(0xFFFBBF24)],
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PurposeScreen())),
            ),

            const SizedBox(height: 24),
            // Quick 2-Minute Reset section
            Text(
              'Instant Micro-Resets',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMiniReset(
                    context,
                    icon: '🌬️',
                    title: 'Deep Breath',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Take one slow deep breath right now... 🌬️')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMiniReset(
                    context,
                    icon: '💧',
                    title: 'Drink Water',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Take a refreshing sip of water 💧')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMiniReset(
                    context,
                    icon: '🧍',
                    title: 'Release Jaw',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Drop your shoulders down and gently unclench your jaw 🧘')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeExploreCard(
    BuildContext context, {
    required String emoji,
    required String title,
    required String description,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(26),
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
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: gradient.first.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCardElevated : AppColors.warmCream,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniReset(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.borderLight,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
