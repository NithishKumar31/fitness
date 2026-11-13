class MoodModel {
  final String label;
  final String emoji;
  final String supportiveMessage;

  const MoodModel({
    required this.label,
    required this.emoji,
    required this.supportiveMessage,
  });

  static const List<MoodModel> defaultMoods = [
    MoodModel(
      label: 'Good',
      emoji: '😊',
      supportiveMessage: "That's wonderful! Channel this gentle energy into something you enjoy today.",
    ),
    MoodModel(
      label: 'Okay',
      emoji: '🙂',
      supportiveMessage: 'A steady day is a great day. Take it one gentle step at a time.',
    ),
    MoodModel(
      label: 'Neutral',
      emoji: '😐',
      supportiveMessage: 'Being present with yourself is enough. Let today unfold at its own pace.',
    ),
    MoodModel(
      label: 'Low',
      emoji: '😔',
      supportiveMessage: "It's completely okay to feel this way. Be gentle with yourself and take one small comfort.",
    ),
    MoodModel(
      label: 'Stressed',
      emoji: '😰',
      supportiveMessage: "Take a small pause. You don't have to solve everything at once.",
    ),
    MoodModel(
      label: 'Tired',
      emoji: '😴',
      supportiveMessage: "Let's keep today simple. A little rest and gentle movement can be a good start.",
    ),
  ];
}
