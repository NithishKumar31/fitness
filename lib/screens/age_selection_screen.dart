import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_colors.dart';
import 'auth_screen.dart';
import 'main_navigation_screen.dart';
import 'onboarding_screen.dart';

class AgeSelectionScreen extends StatefulWidget {
  const AgeSelectionScreen({super.key});

  @override
  State<AgeSelectionScreen> createState() => _AgeSelectionScreenState();
}

class _AgeSelectionScreenState extends State<AgeSelectionScreen> {
  String _selectedAge = '18–40';

  final List<Map<String, dynamic>> _ageOptions = [
    {
      'range': '10–17',
      'icon': '🧒',
      'title': 'Youth & Growth',
      'tag': 'Agility & Habit',
      'description': 'Dynamic movement, joyful play, and healthy daily rhythm',
      'highlight': 'Active youth routines',
      'accent': Color(0xFF3B82F6),
    },
    {
      'range': '18–40',
      'icon': '⚡',
      'title': 'Active Life',
      'tag': 'Peak Vitality',
      'description': 'Energy boost, functional fitness, and balanced stamina',
      'highlight': 'High-energy momentum',
      'accent': Color(0xFFE11D48),
    },
    {
      'range': '41–50',
      'icon': '🌿',
      'title': 'Steady Vitality',
      'tag': 'Strength & Core',
      'description': 'Joint mobility, core resilience, strength, and mindful care',
      'highlight': 'Balanced longevity',
      'accent': Color(0xFFF97316),
    },
    {
      'range': '50+',
      'icon': '✨',
      'title': 'Graceful Living',
      'tag': 'Joint & Motion',
      'description': 'Low-impact motion, posture, flexibility, and daily balance',
      'highlight': 'Gentle restorative pace',
      'accent': Color(0xFF10B981),
    },
  ];

  void _onBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  void _onContinue() {
    final appState = context.read<AppStateProvider>();
    appState.setAgeGroup(_selectedAge);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  void _skipToHome() {
    final appState = context.read<AppStateProvider>();
    appState.setAgeGroup(_selectedAge);
    appState.storage.setOnboardingCompleted(true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.softCanvasLight,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Navigation & Step Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: _onBack,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withValues(alpha: 0.2)
                                    : const Color(0xFF0F172A).withValues(alpha: 0.04),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 13,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Back',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Step Pill & Progress Tag
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDark
                                    ? [
                                        AppColors.primaryGreen.withValues(alpha: 0.2),
                                        AppColors.mintAccent.withValues(alpha: 0.2),
                                      ]
                                    : [
                                        AppColors.primaryGreen.withValues(alpha: 0.1),
                                        AppColors.mintAccent.withValues(alpha: 0.1),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                    .withValues(alpha: 0.3),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'STEP 1 OF 2',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCard : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bolt_rounded,
                                  size: 13,
                                  color: isDark ? AppColors.darkMint : AppColors.mintAccent,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '50%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _skipToHome,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkCard : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Skip',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    size: 15,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Dual Segment Progress Bar
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                            gradient: isDark
                                ? AppColors.accentMintGradient
                                : AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                    .withValues(alpha: 0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Header Title & Subtitle
                  Text(
                    "Let's personalize Rejuvenate",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.6,
                          height: 1.2,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Which age group are you in? We will tailor safe rhythms to your body.',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Age Options List
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _ageOptions.length,
                      itemBuilder: (context, index) {
                        final item = _ageOptions[index];
                        final isSelected = _selectedAge == item['range'];
                        final Color accentColor = item['accent'] as Color;

                        return GestureDetector(
                          onTap: () => setState(() => _selectedAge = item['range']!),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: isDark
                                          ? [
                                              AppColors.darkCardElevated,
                                              AppColors.darkCard,
                                            ]
                                          : [
                                              Colors.white,
                                              const Color(0xFFFFF5F5),
                                            ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: isSelected
                                  ? null
                                  : (isDark ? AppColors.darkCard : Colors.white),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                    : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                                width: isSelected ? 2.0 : 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                          .withValues(alpha: 0.16)
                                      : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                                  blurRadius: isSelected ? 16 : 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Left Icon Badge with Ambient Halo
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: isDark ? 0.18 : 0.10),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: accentColor.withValues(alpha: isSelected ? 0.45 : 0.2),
                                      width: 1.2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    item['icon']!,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),

                                const SizedBox(width: 14),

                                // Central Text Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Range + Title + Lifestyle Tag Pill
                                      Row(
                                        children: [
                                          Text(
                                            item['range']!,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: -0.3,
                                              color: isDark
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.textDark,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              item['title']!,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: isDark
                                                    ? AppColors.darkTextSecondary
                                                    : AppColors.textDark,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: accentColor.withValues(
                                                  alpha: isDark ? 0.22 : 0.12),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              item['tag']!,
                                              style: TextStyle(
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w800,
                                                color: accentColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 3),

                                      // Description Subtitle
                                      Text(
                                        item['description']!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.textMutedLight,
                                          height: 1.35,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      // Highlight bullet
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline_rounded,
                                            size: 12,
                                            color: isSelected
                                                ? (isDark
                                                    ? AppColors.darkMint
                                                    : AppColors.primaryGreen)
                                                : (isDark
                                                    ? AppColors.darkTextSecondary
                                                    : AppColors.textMutedLight),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item['highlight']!,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? (isDark
                                                      ? AppColors.darkMint
                                                      : AppColors.primaryGreenDark)
                                                  : (isDark
                                                      ? AppColors.darkTextSecondary
                                                      : AppColors.textMutedLight),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // Custom Glowing Radio / Checkmark
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: isSelected
                                        ? (isDark
                                            ? AppColors.accentMintGradient
                                            : AppColors.primaryGradient)
                                        : null,
                                    color: isSelected ? null : Colors.transparent,
                                    border: isSelected
                                        ? null
                                        : Border.all(
                                            color: isDark
                                                ? AppColors.darkBorder
                                                : const Color(0xFFCBD5E1),
                                            width: 1.8,
                                          ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: (isDark
                                                      ? AppColors.darkMint
                                                      : AppColors.primaryGreen)
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  alignment: Alignment.center,
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check_rounded,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Inclusive Friendly Privacy Notice
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.warmCream,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.15)
                              : const Color(0xFF0F172A).withValues(alpha: 0.02),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.favorite_rounded,
                            size: 15,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mindful & Inclusive Care',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Your age group is only used to suggest safe movement rhythms. We never judge, score, or compare your body.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textMutedLight,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Continue Glowing CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: isDark
                            ? AppColors.accentMintGradient
                            : AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                .withValues(alpha: 0.38),
                            blurRadius: 16,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: _onContinue,
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue to Step 2',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
