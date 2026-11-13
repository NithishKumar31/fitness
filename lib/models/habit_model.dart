class HabitModel {
  final String id;
  final String title;
  final String icon;
  final String category;
  final int targetDaysPerWeek;
  final int completedDaysThisWeek;
  final bool isCompletedToday;

  const HabitModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.category,
    this.targetDaysPerWeek = 7,
    this.completedDaysThisWeek = 4,
    this.isCompletedToday = false,
  });

  HabitModel copyWith({
    String? id,
    String? title,
    String? icon,
    String? category,
    int? targetDaysPerWeek,
    int? completedDaysThisWeek,
    bool? isCompletedToday,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
      completedDaysThisWeek: completedDaysThisWeek ?? this.completedDaysThisWeek,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
    );
  }

  static List<HabitModel> defaultHabits() {
    return const [
      HabitModel(
        id: 'h_move',
        title: 'Daily Movement',
        icon: '🚶',
        category: 'Body',
        targetDaysPerWeek: 7,
        completedDaysThisWeek: 5,
        isCompletedToday: true,
      ),
      HabitModel(
        id: 'h_water',
        title: 'Hydration (6 glasses)',
        icon: '💧',
        category: 'Self-Care',
        targetDaysPerWeek: 7,
        completedDaysThisWeek: 6,
        isCompletedToday: true,
      ),
      HabitModel(
        id: 'h_sleep',
        title: 'Consistent Sleep Routine',
        icon: '😴',
        category: 'Body',
        targetDaysPerWeek: 7,
        completedDaysThisWeek: 4,
        isCompletedToday: false,
      ),
      HabitModel(
        id: 'h_relax',
        title: 'Relaxation & Breathing',
        icon: '🧘',
        category: 'Mind',
        targetDaysPerWeek: 7,
        completedDaysThisWeek: 5,
        isCompletedToday: false,
      ),
      HabitModel(
        id: 'h_learn',
        title: 'Learning & Curiosity',
        icon: '📚',
        category: 'Purpose',
        targetDaysPerWeek: 5,
        completedDaysThisWeek: 3,
        isCompletedToday: true,
      ),
      HabitModel(
        id: 'h_social',
        title: 'Social Connection',
        icon: '❤️',
        category: 'Relationships',
        targetDaysPerWeek: 5,
        completedDaysThisWeek: 4,
        isCompletedToday: false,
      ),
      HabitModel(
        id: 'h_goal',
        title: 'Personal Interest Goal',
        icon: '🎯',
        category: 'Purpose',
        targetDaysPerWeek: 6,
        completedDaysThisWeek: 4,
        isCompletedToday: false,
      ),
    ];
  }
}
