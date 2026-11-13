import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_colors.dart';
import 'age_selection_screen.dart';
import 'main_navigation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      emoji: '🧘',
      tag: 'MIND SANCTUARY & BREATH',
      title: 'Harmonize Your Mind & Energy',
      description:
          'Release daily tension with gentle 2-minute breathwork, mood tracking, and mindful pauses designed for your rhythm.',
      badge1: '🌬️ 4-7-8 Breathwork',
      badge2: '✨ Daily Calm',
      badge3: '💚 Stress Relief',
      gradient: const [Color(0xFFFF3366), Color(0xFFFF6B00)],
      auraColor: const Color(0xFFFF385C),
    ),
    OnboardingSlideData(
      emoji: '🏃‍♂️',
      tag: 'DAILY MOVEMENT & RINGS',
      title: 'Joyful Movement, Every Day',
      description:
          'Close your triple activity rings, monitor active calorie burn, and build sustainable fitness habits without burnout.',
      badge1: '🔥 10,000 Step Target',
      badge2: '⚡ 342 kcal Burn',
      badge3: '📍 Activity Rings',
      gradient: const [Color(0xFFE11D48), Color(0xFFF97316)],
      auraColor: const Color(0xFFFF6B00),
    ),
    OnboardingSlideData(
      emoji: '🤖',
      tag: 'PERSONAL COMPANION',
      title: 'Your 24/7 AI Wellness Coach',
      description:
          'Always by your side to answer questions, guide gentle daily missions, celebrate small wins, and support your vitality.',
      badge1: '💬 24/7 AI Companion',
      badge2: '🎯 Micro-Missions',
      badge3: '🌱 Zero Pressure',
      gradient: const [Color(0xFFFF5722), Color(0xFFF59E0B)],
      auraColor: const Color(0xFFFF5722),
    ),
  ];

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _navigateToAgeSelection();
    }
  }

  void _onPrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _navigateToAgeSelection() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AgeSelectionScreen()),
    );
  }

  void _skipToHome() {
    final appState = context.read<AppStateProvider>();
    appState.storage.setOnboardingCompleted(true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Column(
                children: [
                  // 1. Sleek Brand Header with Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button or Brand Logo
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _currentPage > 0
                            ? GestureDetector(
                                key: const ValueKey('back_btn'),
                                onTap: _onPrevious,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                                        blurRadius: 8,
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
                              )
                            : Row(
                                key: const ValueKey('brand_logo'),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      gradient: isDark
                                          ? AppColors.accentMintGradient
                                          : AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryGreen.withValues(alpha: 0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text('✨', style: TextStyle(fontSize: 16)),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Rejuvenate',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -0.4,
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                                        ),
                                      ),
                                      Text(
                                        'VITALITY & WELLNESS',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.0,
                                          color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),

                      // Skip Button
                      if (_currentPage < _slides.length - 1)
                        GestureDetector(
                          onTap: _skipToHome,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Skip',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 16,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // 2. Interactive Page Carousel
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (idx) => setState(() => _currentPage = idx),
                      itemCount: _slides.length,
                      itemBuilder: (context, index) {
                        final slide = _slides[index];
                        return _buildSlideCard(slide, isDark);
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 3. Smooth Indicator & Primary Action Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (index) {
                      final isSelected = index == _currentPage;
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isSelected ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? (isDark ? AppColors.accentMintGradient : AppColors.primaryGradient)
                                : null,
                            color: isSelected
                                ? null
                                : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                          .withValues(alpha: 0.35),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 18),

                  // 4. Large Glowing Primary CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: isDark ? AppColors.accentMintGradient : AppColors.primaryGradient,
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
                          onTap: _onNext,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentPage == _slides.length - 1
                                      ? 'Begin Your Journey ✨'
                                      : 'Continue →',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlideCard(OnboardingSlideData slide, bool isDark) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Visual Stage with Layered Glow & Floating Badges
              SizedBox(
                width: 300,
                height: 185,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Outer Ambient Radial Aura
                    Container(
                      width: 185,
                      height: 185,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            slide.auraColor.withValues(alpha: isDark ? 0.28 : 0.20),
                            slide.auraColor.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),

                    // Decorative Concentric Ring
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: slide.auraColor.withValues(alpha: isDark ? 0.25 : 0.18),
                          width: 1.5,
                        ),
                      ),
                    ),

                    // Central Showcase Orb
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: slide.gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: slide.auraColor.withValues(alpha: 0.40),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        slide.emoji,
                        style: const TextStyle(fontSize: 50),
                      ),
                    ),

                    // Floating Orbit Badge 1 (Top-Left)
                    Positioned(
                      top: 6,
                      left: 2,
                      child: _buildFloatingOrbitBadge(slide.badge1, isDark),
                    ),

                    // Floating Orbit Badge 2 (Top-Right)
                    Positioned(
                      top: 16,
                      right: 2,
                      child: _buildFloatingOrbitBadge(slide.badge2, isDark),
                    ),

                    // Floating Orbit Badge 3 (Bottom-Center)
                    Positioned(
                      bottom: 4,
                      child: _buildFloatingOrbitBadge(slide.badge3, isDark),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Category Tag Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.warmCream,
                  borderRadius: BorderRadius.circular(20),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: slide.auraColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      slide.tag,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: isDark ? AppColors.darkMint : AppColors.primaryGreenDark,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Headline
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        height: 1.22,
                      ),
                ),
              ),

              const SizedBox(height: 10),

              // Description Body Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  slide.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingOrbitBadge(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardElevated : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFF0F172A).withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
        ),
      ),
    );
  }
}

class OnboardingSlideData {
  final String emoji;
  final String tag;
  final String title;
  final String description;
  final String badge1;
  final String badge2;
  final String badge3;
  final List<Color> gradient;
  final Color auraColor;

  const OnboardingSlideData({
    required this.emoji,
    required this.tag,
    required this.title,
    required this.description,
    required this.badge1,
    required this.badge2,
    required this.badge3,
    required this.gradient,
    required this.auraColor,
  });
}
