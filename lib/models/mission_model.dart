class MissionModel {
  final String id;
  final String title;
  final String description;
  final String category; // 'Mind', 'Body', 'Self-Care', 'Relationships', 'Purpose'
  final String? ageGroup;
  final String icon;
  final bool completed;
  final String date; // YYYY-MM-DD

  MissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.ageGroup,
    required this.icon,
    this.completed = false,
    required this.date,
  });

  MissionModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? ageGroup,
    String? icon,
    bool? completed,
    String? date,
  }) {
    return MissionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      ageGroup: ageGroup ?? this.ageGroup,
      icon: icon ?? this.icon,
      completed: completed ?? this.completed,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'ageGroup': ageGroup,
      'icon': icon,
      'completed': completed,
      'date': date,
    };
  }

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      id: json['id'] as String? ?? 'm1',
      title: json['title'] as String? ?? 'Take a 10-minute walk',
      description: json['description'] as String? ?? 'A little movement can be a great way to reset your day.',
      category: json['category'] as String? ?? 'Body',
      ageGroup: json['ageGroup'] as String?,
      icon: json['icon'] as String? ?? '🚶',
      completed: json['completed'] as bool? ?? false,
      date: json['date'] as String? ?? '2026-10-16',
    );
  }

  static List<MissionModel> defaultMissionsPool() {
    return [
      MissionModel(
        id: 'm_walk',
        title: 'Take a 10-minute walk',
        description: 'A little movement can be a great way to reset your day and refresh your mind.',
        category: 'Body',
        icon: '🚶',
        date: '2026-10-16',
      ),
      MissionModel(
        id: 'm_relax',
        title: 'Try 5 minutes of relaxation',
        description: 'Sit comfortably, close your eyes, and enjoy a few slow, unhurried breaths.',
        category: 'Mind',
        icon: '🧘',
        date: '2026-10-16',
      ),
      MissionModel(
        id: 'm_phone_break',
        title: 'Take a short phone break',
        description: 'Put your screen aside for 15 minutes and look around your physical surroundings.',
        category: 'Mind',
        icon: '📵',
        date: '2026-10-16',
      ),
      MissionModel(
        id: 'm_hydrate',
        title: 'Drink a glass of water',
        description: 'Hydrate your body with a fresh glass of water. Small sips, no rush.',
        category: 'Self-Care',
        icon: '💧',
        date: '2026-10-16',
      ),
      MissionModel(
        id: 'm_connect',
        title: 'Talk to someone you care about',
        description: 'Send a quick warm text or call a friend or family member just to say hello.',
        category: 'Relationships',
        icon: '❤️',
        date: '2026-10-16',
      ),
      MissionModel(
        id: 'm_music',
        title: 'Listen to music you enjoy',
        description: 'Put on 2 of your favorite uplifting or soothing songs and just enjoy the melody.',
        category: 'Purpose',
        icon: '🎵',
        date: '2026-10-16',
      ),
      MissionModel(
        id: 'm_outdoors',
        title: 'Spend some time outdoors',
        description: 'Step outside to feel the fresh air and sunlight on your face for a few minutes.',
        category: 'Body',
        icon: '🌳',
        date: '2026-10-16',
      ),
      MissionModel(
        id: 'm_bedtime',
        title: 'Start a gentle bedtime routine',
        description: 'Dim the lights 20 minutes before sleep and let your thoughts slow down.',
        category: 'Self-Care',
        icon: '😴',
        date: '2026-10-16',
      ),
    ];
  }
}
