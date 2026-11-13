import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/checkin_model.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_colors.dart';

class DailyCheckInScreen extends StatefulWidget {
  const DailyCheckInScreen({super.key});

  @override
  State<DailyCheckInScreen> createState() => _DailyCheckInScreenState();
}

class _DailyCheckInScreenState extends State<DailyCheckInScreen> {
  int _currentStep = 1;
  final int _totalSteps = 6;

  // Answers
  String _selectedMood = 'Good';
  double _energyLevel = 3.5;
  double _sleepQuality = 4.0;
  bool _movedToday = true;
  bool _connectedToday = true;
  final TextEditingController _meaningfulController =
      TextEditingController(text: 'Read a book & took a calm walk');

  @override
  void dispose() {
    _meaningfulController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
    } else {
      // Save
      final checkin = DailyCheckInModel(
        id: 'checkin_${DateTime.now().millisecondsSinceEpoch}',
        mood: _selectedMood,
        energy: _energyLevel.round(),
        sleep: _sleepQuality.round(),
        movedBody: _movedToday,
        connected: _connectedToday,
        meaningfulActivity: _meaningfulController.text.trim(),
        date: DateTime.now(),
      );
      context.read<AppStateProvider>().submitDailyCheckIn(checkin);

      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        title: Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text('✨', style: TextStyle(fontSize: 34)),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Reflection Complete 🌱',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Thank you for taking a gentle moment for yourself today. Every small check-in strengthens your everyday vitality and balance.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                height: 1.45,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Container(
              decoration: BoxDecoration(
                gradient: isDark ? AppColors.accentMintGradient : AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                        .withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Text(
                      'Back to Dashboard',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Navigation Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_currentStep > 1) {
                            setState(() => _currentStep--);
                          } else {
                            Navigator.pop(context);
                          }
                        },
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
                                _currentStep > 1 ? 'Back' : 'Close',
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
                                  'STEP $_currentStep OF $_totalSteps',
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
                            child: Text(
                              '${((_currentStep / _totalSteps) * 100).round()}%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Progress Bar with Gradient Glow
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: [
                        Container(
                          height: 5,
                          width: double.infinity,
                          color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                        ),
                        FractionallySizedBox(
                          widthFactor: _currentStep / _totalSteps,
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              gradient: isDark
                                  ? AppColors.accentMintGradient
                                  : AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(4),
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
                  ),

                  const SizedBox(height: 20),

                  // Step Content Area (Scrollable to prevent overflow)
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 240),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: _buildStepContent(isDark),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Bottom Action Buttons
                  Row(
                    children: [
                      if (_currentStep > 1) ...[
                        GestureDetector(
                          onTap: () => setState(() => _currentStep--),
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCard : Colors.white,
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_rounded,
                                  size: 16,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Back',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: isDark
                                  ? AppColors.accentMintGradient
                                  : AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(26),
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
                                borderRadius: BorderRadius.circular(26),
                                onTap: _nextStep,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _currentStep == _totalSteps
                                            ? 'Finish Reflection 🌱'
                                            : 'Continue →',
                                        style: const TextStyle(
                                          fontSize: 15.5,
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
                      ),
                    ],
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

  Widget _buildStepContent(bool isDark) {
    switch (_currentStep) {
      case 1:
        return _buildStep1(isDark);
      case 2:
        return _buildStep2(isDark);
      case 3:
        return _buildStep3(isDark);
      case 4:
        return _buildStep4(isDark);
      case 5:
        return _buildStep5(isDark);
      case 6:
        return _buildStep6(isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  // STEP 1: MOOD SELECTION (3-COLUMN POLISHED GRID)
  Widget _buildStep1(bool isDark) {
    final moods = [
      {'emoji': '😊', 'label': 'Good', 'sub': 'Vibrant', 'accent': Color(0xFFE11D48)},
      {'emoji': '🙂', 'label': 'Okay', 'sub': 'Balanced', 'accent': Color(0xFFF97316)},
      {'emoji': '😐', 'label': 'Neutral', 'sub': 'Steady', 'accent': Color(0xFF3B82F6)},
      {'emoji': '😔', 'label': 'Low', 'sub': 'Gentle Care', 'accent': Color(0xFF8B5CF6)},
      {'emoji': '😰', 'label': 'Stressed', 'sub': 'Need Calm', 'accent': Color(0xFFEC4899)},
      {'emoji': '😴', 'label': 'Tired', 'sub': 'Resting', 'accent': Color(0xFF10B981)},
    ];

    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. How are you feeling?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Check in with your emotional weather today.',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.95,
          ),
          itemCount: moods.length,
          itemBuilder: (context, index) {
            final item = moods[index];
            final isSelected = _selectedMood == item['label'];
            final Color accent = item['accent'] as Color;

            return GestureDetector(
              onTap: () => setState(() => _selectedMood = item['label'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: isDark
                              ? [AppColors.darkCardElevated, AppColors.darkCard]
                              : [Colors.white, const Color(0xFFFFF5F5)],
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
                    width: isSelected ? 2 : 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                              .withValues(alpha: 0.18)
                          : Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
                      blurRadius: isSelected ? 12 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: isDark ? 0.20 : 0.10),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item['emoji'] as String,
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['sub'] as String,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? accent
                            : (isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // STEP 2: ENERGY LEVEL
  Widget _buildStep2(bool isDark) {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2. How is your energy today?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Slide to reflect how high or low your natural stamina feels.',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isDark ? AppColors.accentMintGradient : AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                      .withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              _getEnergyEmoji(_energyLevel),
              style: const TextStyle(fontSize: 48),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            _getEnergyLabel(_energyLevel),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            'Level ${_energyLevel.round()} of 5',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
            ),
          ),
        ),
        const SizedBox(height: 28),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: isDark ? AppColors.darkMint : AppColors.primaryGreen,
            inactiveTrackColor: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
            thumbColor: Colors.white,
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
          ),
          child: Slider(
            value: _energyLevel,
            min: 1.0,
            max: 5.0,
            divisions: 4,
            onChanged: (val) => setState(() => _energyLevel = val),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Gentle rest',
                  style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              Text('High stamina',
                  style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 3: SLEEP QUALITY
  Widget _buildStep3(bool isDark) {
    return Column(
      key: const ValueKey(3),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '3. How was your sleep?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Did you wake up feeling rested, light, or interrupted?',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              _getSleepEmoji(_sleepQuality),
              style: const TextStyle(fontSize: 48),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            _getSleepLabel(_sleepQuality),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            'Score ${_sleepQuality.round()} of 5',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
            ),
          ),
        ),
        const SizedBox(height: 28),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: isDark ? AppColors.darkMint : AppColors.primaryGreen,
            inactiveTrackColor: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
            thumbColor: Colors.white,
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
          ),
          child: Slider(
            value: _sleepQuality,
            min: 1.0,
            max: 5.0,
            divisions: 4,
            onChanged: (val) => setState(() => _sleepQuality = val),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Restless',
                  style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              Text('Deeply Restored',
                  style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 4: BODY MOVEMENT
  Widget _buildStep4(bool isDark) {
    return Column(
      key: const ValueKey(4),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '4. Did you move your body today?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Even a brief stroll, light mobility or gentle stretch counts!',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
          ),
        ),
        const SizedBox(height: 24),
        _buildChoiceCard(
          icon: '🚶',
          title: 'Yes, moved and stretched',
          subtitle: 'Took a walk, exercised, or moved joyfully around',
          tag: 'Active',
          isSelected: _movedToday,
          onTap: () => setState(() => _movedToday = true),
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildChoiceCard(
          icon: '🛋️',
          title: 'Not yet, resting today',
          subtitle: 'Rest is just as valuable and healing as movement',
          tag: 'Recovery',
          isSelected: !_movedToday,
          onTap: () => setState(() => _movedToday = false),
          isDark: isDark,
        ),
      ],
    );
  }

  // STEP 5: SOCIAL CONNECTION
  Widget _buildStep5(bool isDark) {
    return Column(
      key: const ValueKey(5),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '5. Did you connect with someone?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'A call, a kind message, or sharing a warm smile with another person.',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
          ),
        ),
        const SizedBox(height: 24),
        _buildChoiceCard(
          icon: '❤️',
          title: 'Yes, had a warm connection',
          subtitle: 'Shared laughs, talked with friends or family',
          tag: 'Connected',
          isSelected: _connectedToday,
          onTap: () => setState(() => _connectedToday = true),
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildChoiceCard(
          icon: '🕊️',
          title: 'Kept quiet / solo time',
          subtitle: 'Enjoyed peaceful quiet presence and personal reflection',
          tag: 'Solo Peace',
          isSelected: !_connectedToday,
          onTap: () => setState(() => _connectedToday = false),
          isDark: isDark,
        ),
      ],
    );
  }

  // STEP 6: MEANINGFUL ACTIVITY
  Widget _buildStep6(bool isDark) {
    final chips = [
      'Read a book 📖',
      'Watered plants 🌱',
      'Listened to music 🎵',
      'Deep breathing 🧘',
      'Cooked a meal 🍲',
      'Walked outside 🌲',
    ];

    return Column(
      key: const ValueKey(6),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '6. Did you do something meaningful?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'A hobby, learning something new, tending a plant, or simply relaxing.',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.borderLight,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _meaningfulController,
            maxLines: 3,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
            ),
            decoration: InputDecoration(
              hintText: 'What was something small you enjoyed today?',
              hintStyle: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Quick Ideas:',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: chips.map((chip) {
            final isChosen = _meaningfulController.text == chip;
            return GestureDetector(
              onTap: () => setState(() => _meaningfulController.text = chip),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  gradient: isChosen
                      ? (isDark ? AppColors.accentMintGradient : AppColors.primaryGradient)
                      : null,
                  color: isChosen ? null : (isDark ? AppColors.darkCard : Colors.white),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isChosen
                        ? Colors.transparent
                        : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                  ),
                ),
                child: Text(
                  chip,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isChosen ? FontWeight.w800 : FontWeight.w600,
                    color: isChosen
                        ? Colors.white
                        : (isDark ? AppColors.darkTextPrimary : AppColors.textDark),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildChoiceCard({
    required String icon,
    required String title,
    required String subtitle,
    required String tag,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: isDark
                      ? [AppColors.darkCardElevated, AppColors.darkCard]
                      : [Colors.white, const Color(0xFFFFF5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                : (isDark ? AppColors.darkBorder : AppColors.borderLight),
            width: isSelected ? 2 : 1.2,
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
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                    .withValues(alpha: isDark ? 0.18 : 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(icon, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                              .withValues(alpha: isDark ? 0.22 : 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkMint : AppColors.primaryGreenDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected
                    ? (isDark ? AppColors.accentMintGradient : AppColors.primaryGradient)
                    : null,
                color: isSelected ? null : Colors.transparent,
                border: isSelected
                    ? null
                    : Border.all(
                        color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1),
                        width: 1.8,
                      ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                              .withValues(alpha: 0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  String _getEnergyEmoji(double level) {
    if (level <= 1.5) return '🪫';
    if (level <= 2.5) return '☕';
    if (level <= 3.5) return '🌱';
    if (level <= 4.5) return '⚡';
    return '🌟';
  }

  String _getEnergyLabel(double level) {
    if (level <= 1.5) return 'Low & Gentle';
    if (level <= 2.5) return 'Subtle Stamina';
    if (level <= 3.5) return 'Moderate & Steady';
    if (level <= 4.5) return 'Refreshed & Energetic';
    return 'High & Vibrant';
  }

  String _getSleepEmoji(double level) {
    if (level <= 1.5) return '🥱';
    if (level <= 2.5) return '🛌';
    if (level <= 3.5) return '🌙';
    if (level <= 4.5) return '😴';
    return '✨';
  }

  String _getSleepLabel(double level) {
    if (level <= 1.5) return 'Restless Sleep';
    if (level <= 2.5) return 'Light Sleep';
    if (level <= 3.5) return 'Decent Rest';
    if (level <= 4.5) return 'Comfortable Sleep';
    return 'Deep & Restorative';
  }
}
