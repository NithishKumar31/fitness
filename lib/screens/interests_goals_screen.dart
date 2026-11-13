import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_colors.dart';
import 'auth_screen.dart';
import 'main_navigation_screen.dart';

class InterestsGoalsScreen extends StatefulWidget {
  const InterestsGoalsScreen({super.key});

  @override
  State<InterestsGoalsScreen> createState() => _InterestsGoalsScreenState();
}

class _InterestsGoalsScreenState extends State<InterestsGoalsScreen> {
  final List<String> _allInterests = [
    'Learning 📚',
    'Music 🎵',
    'Sports 🏏',
    'Creativity 🎨',
    'Coding 💻',
    'Gardening 🌱',
    'Reading 📖',
    'Helping Others ❤️',
    'Meditation 🧘',
    'Nature & Walks 🌲',
  ];

  final List<Map<String, dynamic>> _allHabits = [
    {
      'title': 'Daily Calm & Breathing 🧘',
      'label': 'Daily Calm & Breathing',
      'subtitle': '5-min gentle breathwork & mental reset',
      'icon': '🧘',
      'accent': Color(0xFF8B5CF6),
    },
    {
      'title': 'Gentle Movement 🚶',
      'label': 'Gentle Movement',
      'subtitle': 'Daily steps, mobility & mindful walks',
      'icon': '🚶',
      'accent': Color(0xFFE11D48),
    },
    {
      'title': 'Consistent Sleep 😴',
      'label': 'Consistent Sleep',
      'subtitle': 'Restorative bedtime rhythms & sleep hygiene',
      'icon': '😴',
      'accent': Color(0xFF3B82F6),
    },
    {
      'title': 'Healthy Hydration 💧',
      'label': 'Healthy Hydration',
      'subtitle': 'Mindful water intake & daily hydration goals',
      'icon': '💧',
      'accent': Color(0xFF06B6D4),
    },
    {
      'title': 'Staying Connected 🤝',
      'label': 'Staying Connected',
      'subtitle': 'Warm conversations & quality relationship time',
      'icon': '🤝',
      'accent': Color(0xFFF97316),
    },
    {
      'title': 'Meaningful Hobbies 🎯',
      'label': 'Meaningful Hobbies',
      'subtitle': 'Joyful creative projects & daily passions',
      'icon': '🎯',
      'accent': Color(0xFF10B981),
    },
  ];

  final Set<String> _selectedInterests = {'Reading 📖', 'Music 🎵', 'Gardening 🌱'};
  final Set<String> _selectedGoals = {'Daily Calm & Breathing 🧘', 'Gentle Movement 🚶'};

  void _onBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  void _onSaveAndContinue() {
    final appState = context.read<AppStateProvider>();
    appState.updateUserProfile(
      interests: _selectedInterests.toList(),
      goals: _selectedGoals.toList(),
    );
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Navigation Bar & Progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                  'STEP 2 OF 2',
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
                                const Text('✨', style: TextStyle(fontSize: 12)),
                                const SizedBox(width: 4),
                                Text(
                                  'Final Step',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Dual Segment Progress Bar (100% Completed)
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
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Header Title & Subtitle
                  Text(
                    'What brings you joy?',
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
                    'Select topics and habits you would like to include in your small steps.',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Section 1: Interests & Hobbies
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Interests & Hobbies',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: isDark ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_selectedInterests.length} selected',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkMint : AppColors.primaryGreenDark,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Interactive Interests Wrap
                  Wrap(
                    spacing: 8,
                    runSpacing: 9,
                    children: _allInterests.map((interest) {
                      final isSelected = _selectedInterests.contains(interest);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              if (_selectedInterests.length > 1) {
                                _selectedInterests.remove(interest);
                              }
                            } else {
                              _selectedInterests.add(interest);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
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
                                            const Color(0xFFFFF1F2),
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: isSelected ? null : (isDark ? AppColors.darkCard : Colors.white),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                  : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                              width: isSelected ? 1.8 : 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                        .withValues(alpha: 0.18)
                                    : Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
                                blurRadius: isSelected ? 10 : 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected) ...[
                                Icon(
                                  Icons.check_rounded,
                                  size: 14,
                                  color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                                ),
                                const SizedBox(width: 5),
                              ],
                              Text(
                                interest,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  color: isSelected
                                      ? (isDark ? AppColors.darkTextPrimary : AppColors.textDark)
                                      : (isDark ? AppColors.darkTextSecondary : AppColors.textDark),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 26),

                  // Section 2: Everyday Habits
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Everyday Habits to Nurture',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: isDark ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_selectedGoals.length} active',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkMint : AppColors.primaryGreenDark,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Habit Cards List
                  Column(
                    children: _allHabits.map((habit) {
                      final titleKey = habit['title'] as String;
                      final isSelected = _selectedGoals.contains(titleKey);
                      final Color accentColor = habit['accent'] as Color;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              if (_selectedGoals.length > 1) {
                                _selectedGoals.remove(titleKey);
                              }
                            } else {
                              _selectedGoals.add(titleKey);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.only(bottom: 11),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                            color: isSelected ? null : (isDark ? AppColors.darkCard : Colors.white),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                  : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                              width: isSelected ? 1.8 : 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                        .withValues(alpha: 0.16)
                                    : Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
                                blurRadius: isSelected ? 12 : 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Icon with Ambient Accent Halo
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: isDark ? 0.20 : 0.10),
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(
                                    color: accentColor.withValues(alpha: isSelected ? 0.45 : 0.18),
                                    width: 1.2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  habit['icon'] as String,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Text Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      habit['label'] as String,
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.2,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      habit['subtitle'] as String,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w500,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textMutedLight,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Glowing Checkmark Indicator
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 24,
                                height: 24,
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
                                                .withValues(alpha: 0.35),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: isSelected
                                    ? const Icon(
                                        Icons.check_rounded,
                                        size: 15,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Inclusivity & Pressure-Free Reassurance
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.warmCream,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text('🌱', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Flexible & Pressure-Free • You can pause, adjust, or switch habits anytime.',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Primary Enter Rejuvenate CTA Button
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
                          onTap: _onSaveAndContinue,
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Enter Rejuvenate ✨',
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

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
