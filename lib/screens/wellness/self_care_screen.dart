import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/sound_service.dart';
import '../../widgets/animated_breathing_circle.dart';
import '../live_session_screen.dart';

class SelfCareScreen extends StatefulWidget {
  const SelfCareScreen({super.key});

  @override
  State<SelfCareScreen> createState() => _SelfCareScreenState();
}

class _SelfCareScreenState extends State<SelfCareScreen> {
  // Category filter: 0 = All, 1 = Body, 2 = Skin & Glow, 3 = Rest, 4 = Kindness
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    '✨ All Rituals',
    '🧍 Body Alignment',
    '🧴 Skin & Freshness',
    '😴 Rest & Pause',
    '❤️ Self-Kindness',
  ];

  // Daily Quotes
  int _currentQuoteIndex = 0;
  final List<Map<String, String>> _quotes = [
    {
      'quote': 'Self-care is about feeling comfortable and confident, not looking perfect.',
      'author': 'Daily Wisdom',
    },
    {
      'quote': 'Talk to yourself like someone you deeply cherish. You are doing the best you can.',
      'author': 'Gentle Mind',
    },
    {
      'quote': 'Rest is not a reward you earn; it is an essential need your body deserves.',
      'author': 'Wellness Truth',
    },
    {
      'quote': 'True rejuvenation begins when you stop rushing through moments made for living.',
      'author': 'Calm Living',
    },
    {
      'quote': 'Clothes should fit your body, never force your body to fit clothes.',
      'author': 'Self-Compassion',
    },
  ];

  // Hydration glasses logged in skincare modal
  int _waterGlasses = 4;

  // Saved self-love notes
  final List<String> _selfLoveNotes = [
    'I handled a demanding day with patience and grace.',
    'I gave myself permission to step back and take a deep breath.',
  ];
  final TextEditingController _noteController = TextEditingController();

  // Affirmations Deck
  int _currentAffirmationIndex = 0;
  final List<String> _affirmations = [
    'I honor my body with gentle movement, nutritious rest, and kind words.',
    'I release the pressure to be flawless and embrace the joy of being human.',
    'My peace of mind is my priority today; I choose ease over tension.',
    'I am worthy of respect, gentleness, and unapologetic self-care.',
    'I breathe in calm energy and exhale all unnecessary burdens.',
    'Today, I choose to be my own greatest supporter and cheerleader.',
  ];

  // Care Habit Model State
  late List<_CareHabit> _habits;

  @override
  void initState() {
    super.initState();
    _initHabits();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _initHabits() {
    _habits = [
      _CareHabit(
        id: 'posture',
        title: 'Posture Reset',
        subtitle: 'Check in on your neck, spine, and shoulders to release accumulated stiffness.',
        category: '🧍 Body Alignment',
        timeEstimate: '2 min',
        icon: '🧍',
        accentColor: const Color(0xFFF97316), // Warm Orange
        bgLight: const Color(0xFFFFF7ED),
        bgDark: const Color(0xFF2E1B12),
        badgeText: 'Anytime Reset',
        actionLabel: 'Check Posture',
        onTapAction: _showPostureModal,
      ),
      _CareHabit(
        id: 'skincare',
        title: 'Skincare Basics',
        subtitle: 'Gentle cleansing, hydrating moisture, and soothing nourishment for healthy glow.',
        category: '🧴 Skin & Freshness',
        timeEstimate: '3 min',
        icon: '🧴',
        accentColor: const Color(0xFF10B981), // Emerald Mint
        bgLight: const Color(0xFFECFDF5),
        bgDark: const Color(0xFF122E22),
        badgeText: 'Morning / Night',
        actionLabel: 'View Routine',
        onTapAction: _showSkincareModal,
      ),
      _CareHabit(
        id: 'hygiene',
        title: 'Hygiene & Freshness',
        subtitle: 'A warm shower, clean teeth, and feeling light, crisp, and revitalized.',
        category: '🧴 Skin & Freshness',
        timeEstimate: '5 min',
        icon: '🧼',
        accentColor: const Color(0xFF0EA5E9), // Sky Blue
        bgLight: const Color(0xFFF0F9FF),
        bgDark: const Color(0xFF0C2438),
        badgeText: 'Daily Renewal',
        actionLabel: 'Refresh Tips',
        onTapAction: _showHygieneModal,
      ),
      _CareHabit(
        id: 'clothing',
        title: 'Comfortable Clothing',
        subtitle: 'Wear breathable, soft fabrics that honor your ease, freedom, and self-confidence.',
        category: '🧍 Body Alignment',
        timeEstimate: '1 min',
        icon: '👕',
        accentColor: const Color(0xFFEC4899), // Soft Pink
        bgLight: const Color(0xFFFDF2F8),
        bgDark: const Color(0xFF331526),
        badgeText: 'Feel-Good Style',
        actionLabel: 'Comfort Guide',
        onTapAction: _showClothingModal,
      ),
      _CareHabit(
        id: 'rest',
        title: 'Unapologetic Rest',
        subtitle: 'Give yourself permission to pause for 10 minutes without guilt or productivity anxiety.',
        category: '😴 Rest & Pause',
        timeEstimate: '5-10 min',
        icon: '😴',
        accentColor: const Color(0xFF8B5CF6), // Purple / Violet
        bgLight: const Color(0xFFF5F3FF),
        bgDark: const Color(0xFF241538),
        badgeText: 'Mind Recharge',
        actionLabel: 'Pause Now',
        onTapAction: _showRestModal,
      ),
      _CareHabit(
        id: 'kindness',
        title: 'Self-Kindness & Confidence',
        subtitle: 'Speak to yourself today the way you would to a dear, cherished friend.',
        category: '❤️ Self-Kindness',
        timeEstimate: '2 min',
        icon: '❤️',
        accentColor: const Color(0xFFE11D48), // Crimson Flame
        bgLight: const Color(0xFFFFF1F2),
        bgDark: const Color(0xFF32121A),
        badgeText: 'Heart & Soul',
        actionLabel: 'Affirmations',
        onTapAction: _showKindnessModal,
      ),
    ];
  }

  void _toggleHabit(int index) {
    setState(() {
      _habits[index].isCompleted = !_habits[index].isCompleted;
    });

    final habit = _habits[index];
    if (habit.isCompleted) {
      SoundService.playMeditationBell();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text('${habit.icon} ', style: const TextStyle(fontSize: 18)),
              Expanded(
                child: Text('${habit.title} marked complete! Feel that ease & grace 🌱'),
              ),
            ],
          ),
          backgroundColor: AppColors.primaryGreen,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  int get _completedCount => _habits.where((h) => h.isCompleted).length;
  double get _completionPercent => _habits.isEmpty ? 0 : _completedCount / _habits.length;

  List<_CareHabit> get _filteredHabits {
    if (_selectedCategoryIndex == 0) return _habits;
    final categoryName = _categories[_selectedCategoryIndex];
    return _habits.where((h) => h.category == categoryName).toList();
  }

  void _cycleQuote() {
    setState(() {
      _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length;
    });
  }

  // ==========================================
  // MODAL 1: POSTURE RESET MODAL
  // ==========================================
  void _showPostureModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text('🧍', style: TextStyle(fontSize: 28)),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '30-Second Posture Reset',
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Release neck tension & spine pressure',
                                style: TextStyle(fontSize: 13, color: AppColors.textMutedLight),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : const Color(0xFFFDE68A),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Color(0xFFD97706), size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Gentle check: Good posture is dynamic and relaxed, never stiff or forced.',
                              style: TextStyle(fontSize: 13, height: 1.35),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Interactive Alignment Steps:',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    _buildModalCheckItem(
                      step: '1',
                      title: 'Shoulder Drop',
                      desc: 'Roll your shoulders gently up toward your ears, roll them back, and let them melt downward.',
                      isDark: isDark,
                    ),
                    _buildModalCheckItem(
                      step: '2',
                      title: 'Spine Lengthening',
                      desc: 'Imagine a helium string lifting the crown of your head softly toward the ceiling.',
                      isDark: isDark,
                    ),
                    _buildModalCheckItem(
                      step: '3',
                      title: 'Jaw & Face Softening',
                      desc: 'Unclench your jaw. Let your tongue rest lightly against the roof of your mouth.',
                      isDark: isDark,
                    ),
                    _buildModalCheckItem(
                      step: '4',
                      title: 'Deep Diaphragm Breath',
                      desc: 'Take one slow, deep breath in for 4 seconds, feeling your ribs expand, then sigh it out.',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle, size: 20),
                        label: const Text('I Feel Taller and Lighter ✓', style: TextStyle(fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF97316),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _markHabitDone('posture');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // MODAL 2: SKINCARE BASICS MODAL
  // ==========================================
  void _showSkincareModal() {
    int activeRoutineTab = 0; // 0 = Morning, 1 = Night
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text('🧴', style: TextStyle(fontSize: 28)),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Skincare & Hydration Ritual',
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Comfort, barrier protection & moisture',
                                style: TextStyle(fontSize: 13, color: AppColors.textMutedLight),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Morning vs Night Routine Toggle
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setModalState(() => activeRoutineTab = 0),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: activeRoutineTab == 0
                                      ? (isDark ? AppColors.darkCardElevated : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: activeRoutineTab == 0
                                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                                      : [],
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('☀️ ', style: TextStyle(fontSize: 16)),
                                    Text(
                                      'Morning Shield',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: activeRoutineTab == 0 ? FontWeight.w700 : FontWeight.w500,
                                        color: activeRoutineTab == 0 ? const Color(0xFF10B981) : AppColors.textMutedLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setModalState(() => activeRoutineTab = 1),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: activeRoutineTab == 1
                                      ? (isDark ? AppColors.darkCardElevated : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: activeRoutineTab == 1
                                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                                      : [],
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('🌙 ', style: TextStyle(fontSize: 16)),
                                    Text(
                                      'Night Restore',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: activeRoutineTab == 1 ? FontWeight.w700 : FontWeight.w500,
                                        color: activeRoutineTab == 1 ? const Color(0xFF8B5CF6) : AppColors.textMutedLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (activeRoutineTab == 0) ...[
                      _buildRoutineStep(context, '1. Gentle Splash', 'Rinse face with lukewarm water or a mild, non-stripping cleanser.'),
                      _buildRoutineStep(context, '2. Hydration Base', 'Pat face gently (leave slightly damp) and apply hyaluronic or thermal water.'),
                      _buildRoutineStep(context, '3. Barrier Moisturizer', 'Smooth a lightweight moisturizer with ceramides to seal hydration.'),
                      _buildRoutineStep(context, '4. Daily SPF Defense', 'Apply broad-spectrum sunscreen (SPF 30+) to protect your skin barrier.'),
                    ] else ...[
                      _buildRoutineStep(context, '1. Purify & Cleanse', 'Wash away sunscreen and urban dust with a calming cleansing milk/gel.'),
                      _buildRoutineStep(context, '2. Nourishing Essence', 'Soothe tired skin with a nourishing chamomile, peptide, or rose tonic.'),
                      _buildRoutineStep(context, '3. Rich Night Cream', 'Apply a richer, comforting night moisturizer or squalane oil.'),
                      _buildRoutineStep(context, '4. Hydrated Lips', 'Finish with nourishing balm to wake up with soft, comfortable lips.'),
                    ],
                    const SizedBox(height: 16),
                    // Quick Hydration Glasses Log
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : const Color(0xFFBBF7D0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '💧 Internal Glow (Water Tracker)',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '$_waterGlasses / 8 Glasses',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF059669)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(8, (i) {
                              final isFilled = i < _waterGlasses;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _waterGlasses = i + 1;
                                  });
                                  setModalState(() {});
                                },
                                child: Container(
                                  width: 32,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isFilled
                                        ? const Color(0xFF0EA5E9)
                                        : (isDark ? AppColors.darkCardElevated : Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    isFilled ? Icons.water_drop : Icons.water_drop_outlined,
                                    size: 18,
                                    color: isFilled ? Colors.white : Colors.grey,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check, size: 20),
                        label: const Text('Mark Routine Completed ✨', style: TextStyle(fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _markHabitDone('skincare');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // MODAL 3: HYGIENE & FRESHNESS MODAL
  // ==========================================
  void _showHygieneModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('🧼', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'The Freshness Reset Ritual',
                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Reset your body temperature and sensory state',
                          style: TextStyle(fontSize: 13, color: AppColors.textMutedLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildModalCheckItem(
                step: '🚿',
                title: 'Temperature Transition',
                desc: 'A warm shower relaxes tight muscles, followed by 15 seconds of cool water to wake up vitality.',
                isDark: isDark,
              ),
              _buildModalCheckItem(
                step: '🪥',
                title: 'Clean Mouth & Breath',
                desc: 'Thorough brushing, flossing, and a refreshing mint rinse brings instant mental clarity.',
                isDark: isDark,
              ),
              _buildModalCheckItem(
                step: '🌿',
                title: 'Aromatherapy Cue',
                desc: 'Spritz a touch of lavender, eucalyptus, or citrus room mist to signal cleanliness to your brain.',
                isDark: isDark,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check, size: 20),
                  label: const Text('I Feel Fresh & Renewed 🧼', style: TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _markHabitDone('hygiene');
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // MODAL 4: COMFORTABLE CLOTHING MODAL
  // ==========================================
  void _showClothingModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF2F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('👕', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comfort & Confidence Guide',
                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Honor how your body feels throughout the day',
                          style: TextStyle(fontSize: 13, color: AppColors.textMutedLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : const Color(0xFFFECDD3),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✨ The Golden Comfort Rule:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFE11D48)),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '“Clothes exist to serve your body with comfort and ease — never force your body to suffer for clothing.”',
                      style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildModalCheckItem(
                step: '🪶',
                title: 'Breathable Fibers',
                desc: 'Prioritize natural soft cotton, breathable bamboo, loose linen, or cozy knits.',
                isDark: isDark,
              ),
              _buildModalCheckItem(
                step: '🌬️',
                title: 'The Belly-Breath Test',
                desc: 'If your waistband pinches when you take a relaxed belly breath, loosen or change into cozy wear.',
                isDark: isDark,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check, size: 20),
                  label: const Text('I Honor My Body Comfort ✨', style: TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC4899),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _markHabitDone('clothing');
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // MODAL 5: UNAPOLOGETIC REST & TIMER MODAL
  // ==========================================
  void _showRestModal() {
    int restSeconds = 300; // 5 minutes default
    bool isRestTimerRunning = false;
    Timer? restTimer;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final minutes = (restSeconds ~/ 60).toString().padLeft(2, '0');
            final seconds = (restSeconds % 60).toString().padLeft(2, '0');

            return Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text('😴', style: TextStyle(fontSize: 28)),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unapologetic Rest Sanctuary',
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Pause with zero guilt or productivity anxiety',
                                style: TextStyle(fontSize: 13, color: AppColors.textMutedLight),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Breathing visualization & timer
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [const Color(0xFF2E1A47), const Color(0xFF1E1130)]
                              : [const Color(0xFFF5F3FF), const Color(0xFFECE7FE)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : const Color(0xFFDDD6FE),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Gentle 5-Minute Decompression',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF8B5CF6)),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '$minutes:$seconds',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Close your eyes, lower your shoulders, and just BE.',
                            style: TextStyle(fontSize: 13, color: AppColors.textMutedLight),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                icon: Icon(isRestTimerRunning ? Icons.pause : Icons.play_arrow),
                                label: Text(isRestTimerRunning ? 'Pause' : 'Start Timer'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8B5CF6),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: () {
                                  if (isRestTimerRunning) {
                                    restTimer?.cancel();
                                    setModalState(() => isRestTimerRunning = false);
                                  } else {
                                    SoundService.playMeditationBell();
                                    isRestTimerRunning = true;
                                    restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
                                      if (restSeconds > 0) {
                                        setModalState(() => restSeconds--);
                                      } else {
                                        t.cancel();
                                        SoundService.playMeditationBell();
                                        setModalState(() => isRestTimerRunning = false);
                                      }
                                    });
                                    setModalState(() {});
                                  }
                                },
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: () {
                                  restTimer?.cancel();
                                  setModalState(() {
                                    isRestTimerRunning = false;
                                    restSeconds = 300;
                                  });
                                },
                                child: const Text('Reset'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Shortcut to full guided meditation
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: isDark ? AppColors.darkBorder : Colors.grey.shade200),
                      ),
                      tileColor: isDark ? AppColors.darkSurface : Colors.grey.shade50,
                      leading: const Text('🌬️', style: TextStyle(fontSize: 24)),
                      title: const Text('Open Full Guided Meditation', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      subtitle: const Text('With ambient soundscapes & bell chime', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () {
                        restTimer?.cancel();
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LiveSessionScreen(
                              type: SessionType.meditation,
                              initialMinutes: 10,
                              title: 'Unapologetic Rest',
                              icon: '😴',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check, size: 20),
                        label: const Text('Rest Completed ✓ I Feel Recharged', style: TextStyle(fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5CF6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          restTimer?.cancel();
                          Navigator.pop(ctx);
                          _markHabitDone('rest');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // MODAL 6: SELF-KINDNESS & CONFIDENCE MODAL
  // ==========================================
  void _showKindnessModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text('❤️', style: TextStyle(fontSize: 28)),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Self-Kindness & Confidence',
                                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Speak to yourself as you would to a dear friend',
                                  style: TextStyle(fontSize: 13, color: AppColors.textMutedLight),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Affirmation Card Deck
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [const Color(0xFF3B1522), const Color(0xFF261018)]
                                : [const Color(0xFFFFF1F2), const Color(0xFFFFE4E6)],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : const Color(0xFFFECDD3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.auto_awesome, color: Color(0xFFE11D48), size: 18),
                                    SizedBox(width: 6),
                                    Text(
                                      'Daily Compassion Deck',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFE11D48)),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.shuffle, size: 20, color: Color(0xFFE11D48)),
                                  tooltip: 'Next Affirmation',
                                  onPressed: () {
                                    setModalState(() {
                                      _currentAffirmationIndex = (_currentAffirmationIndex + 1) % _affirmations.length;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '“${_affirmations[_currentAffirmationIndex]}”',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Card ${_currentAffirmationIndex + 1} of ${_affirmations.length} • Tap 🔀 for another',
                              style: const TextStyle(fontSize: 12, color: AppColors.textMutedLight),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Write a Love Note to Yourself:',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _noteController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'e.g. I am proud of how I handled today...',
                          hintStyle: const TextStyle(fontSize: 13),
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurface : Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send, color: Color(0xFFE11D48)),
                            onPressed: () {
                              if (_noteController.text.trim().isNotEmpty) {
                                setState(() {
                                  _selfLoveNotes.insert(0, _noteController.text.trim());
                                });
                                _noteController.clear();
                                setModalState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Saved your note with love ❤️')),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      if (_selfLoveNotes.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        const Text(
                          'Recent Reflections:',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMutedLight),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(
                          _selfLoveNotes.length > 2 ? 2 : _selfLoveNotes.length,
                          (idx) => Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Text('💌 ', style: TextStyle(fontSize: 14)),
                                Expanded(
                                  child: Text(_selfLoveNotes[idx], style: const TextStyle(fontSize: 13)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.favorite, size: 20),
                          label: const Text('I Honor Myself Today ❤️', style: TextStyle(fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE11D48),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _markHabitDone('kindness');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _markHabitDone(String id) {
    final idx = _habits.indexWhere((h) => h.id == id);
    if (idx != -1 && !_habits[idx].isCompleted) {
      _toggleHabit(idx);
    } else {
      SoundService.playMeditationBell();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Self-care ritual completed! 🌱 You are doing great.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Quick 1-Minute Breathing Reset Sheet
  void _openQuickBreathingSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 18),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🌬️ ', style: TextStyle(fontSize: 26)),
                  Text(
                    '1-Minute Calming Breath',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Follow the rhythm. Inhale calm, exhale release.',
                style: TextStyle(fontSize: 13, color: AppColors.textMutedLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              AnimatedBreathingCircle(
                onCycleCompleted: () {
                  SoundService.playMeditationBell();
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Finished Breath Reset ✓'),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // MAIN BUILD METHOD
  // ==========================================
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('Self-Care ✨', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Habit Checks',
            onPressed: () {
              setState(() {
                for (var h in _habits) {
                  h.isCompleted = false;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Habit checks reset for a brand new day! ☀️')),
              );
            },
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Subtitle & Gentle Intention
                Text(
                  'Take care of yourself without trying to be perfect.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                  ),
                ),
                const SizedBox(height: 16),

                // 🌟 HERO PROGRESS & DAILY NOURISHMENT CARD
                _buildProgressCard(isDark),
                const SizedBox(height: 16),

                // 💬 PHILOSOPHY & ROTATING MANTRAS BANNER
                _buildPhilosophyCard(isDark),
                const SizedBox(height: 16),

                // 🌬️ QUICK 1-MINUTE CALM SOS ACTION BAR
                _buildQuickCalmBanner(isDark),
                const SizedBox(height: 24),

                // SECTION TITLE & CATEGORY FILTER TABS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Everyday Care Habits',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                    ),
                    Text(
                      '$_completedCount of ${_habits.length} Done',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Category Chips Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(_categories.length, (index) {
                      final isSelected = _selectedCategoryIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_categories[index]),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                          },
                          selectedColor: isDark
                              ? AppColors.primaryGreen.withValues(alpha: 0.3)
                              : AppColors.softMint,
                          checkmarkColor: AppColors.primaryGreen,
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? (isDark ? Colors.white : AppColors.primaryGreenDark)
                                : (isDark ? AppColors.darkTextSecondary : AppColors.textDark),
                          ),
                          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),

                // RESPONSIVE HABITS CARDS (Grid on desktop / 2-column wide, single column on mobile)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final habits = _filteredHabits;
                    if (habits.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No habits in this category.',
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                            ),
                          ),
                        ),
                      );
                    }

                    final isWideScreen = constraints.maxWidth >= 640;

                    if (!isWideScreen) {
                      // Single Column Layout
                      return Column(
                        children: habits.map((habit) {
                          final originalIndex = _habits.indexOf(habit);
                          return _buildHabitCard(habit, originalIndex, isDark);
                        }).toList(),
                      );
                    }

                    // 2-Column Responsive Grid for wide screens
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 200,
                      ),
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        final habit = habits[index];
                        final originalIndex = _habits.indexOf(habit);
                        return _buildHabitCard(habit, originalIndex, isDark, isGridMode: true);
                      },
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET HELPERS
  // ==========================================

  Widget _buildProgressCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF281822), const Color(0xFF1B1424)]
              : [const Color(0xFFFFF7F5), const Color(0xFFFFF0EC)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFFFDCD4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                      color: AppColors.primaryGreen.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('✨', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Nourishment Progress',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Every small gentle effort counts',
                        style: TextStyle(fontSize: 12, color: AppColors.textMutedLight),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text('🔥 ', style: TextStyle(fontSize: 13)),
                    Text(
                      '3-Day Streak',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.primaryGreenLight : AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _completionPercent,
              minHeight: 10,
              backgroundColor: isDark ? AppColors.darkSurface : Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_completedCount of ${_habits.length} rituals completed',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Text(
                '${(_completionPercent * 100).toInt()}% Done',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _completedCount == _habits.length
                      ? const Color(0xFF10B981)
                      : AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhilosophyCard(bool isDark) {
    final quote = _quotes[_currentQuoteIndex];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.darkCardElevated, const Color(0xFF2C243B)]
              : [const Color(0xFFF6EEFB), const Color(0xFFEFE6F7)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE1D0F0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌸 ', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Self-Care Philosophy • ${quote['author']}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.softLavender,
                      ),
                    ),
                    InkWell(
                      onTap: _cycleQuote,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Icon(Icons.cached, size: 16, color: isDark ? AppColors.softLavender : AppColors.primaryGreen),
                            const SizedBox(width: 4),
                            Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.softLavender : AppColors.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '“${quote['quote']}”',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCalmBanner(bool isDark) {
    return GestureDetector(
      onTap: _openQuickBreathingSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : const Color(0xFFBBF7D0),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Text('🌬️', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1-Minute Calming Reset',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Feeling tense or overwhelmed? Tap here to take 3 mindful breaths.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMutedLight),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Breathe',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitCard(
    _CareHabit habit,
    int originalIndex,
    bool isDark, {
    bool isGridMode = false,
  }) {
    final isDone = habit.isCompleted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.only(bottom: isGridMode ? 0 : 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDone
            ? (isDark ? const Color(0xFF1B2820) : const Color(0xFFF2FBF6))
            : (isDark ? AppColors.darkCard : Colors.white),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDone
              ? const Color(0xFF10B981)
              : (isDark ? AppColors.darkBorder : AppColors.borderLight),
          width: isDone ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isGridMode ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? habit.bgDark : habit.bgLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: habit.accentColor.withValues(alpha: 0.3),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(habit.icon, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 12),
              // Title & Category Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: habit.accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            habit.badgeText,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: habit.accentColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '⏱️ ${habit.timeEstimate}',
                          style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      habit.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                ),
              ),
              // Checkbox button
              InkWell(
                onTap: () => _toggleHabit(originalIndex),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDone ? const Color(0xFF10B981) : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone
                          ? const Color(0xFF10B981)
                          : (isDark ? AppColors.darkBorder : Colors.grey.shade400),
                      width: 1.8,
                    ),
                  ),
                  child: isDone
                      ? const Icon(Icons.check, size: 20, color: Colors.white)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Subtitle description
          Text(
            habit.subtitle,
            maxLines: isGridMode ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          // Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                icon: Icon(
                  isDone ? Icons.done_all : Icons.open_in_new,
                  size: 14,
                  color: isDone ? const Color(0xFF10B981) : habit.accentColor,
                ),
                label: Text(
                  habit.actionLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDone ? const Color(0xFF10B981) : habit.accentColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(80, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  side: BorderSide(
                    color: isDone
                        ? const Color(0xFF10B981).withValues(alpha: 0.5)
                        : habit.accentColor.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: habit.onTapAction,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModalCheckItem({
    required String step,
    required String title,
    required String desc,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
            child: Text(
              step,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineStep(BuildContext context, String title, String desc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF10B981)),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                ),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                    ),
                  ),
                  TextSpan(
                    text: desc,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
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
}

class _CareHabit {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String timeEstimate;
  final String icon;
  final Color accentColor;
  final Color bgLight;
  final Color bgDark;
  final String badgeText;
  final String actionLabel;
  final VoidCallback onTapAction;
  bool isCompleted;

  _CareHabit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.timeEstimate,
    required this.icon,
    required this.accentColor,
    required this.bgLight,
    required this.bgDark,
    required this.badgeText,
    required this.actionLabel,
    required this.onTapAction,
    this.isCompleted = false,
  });
}
