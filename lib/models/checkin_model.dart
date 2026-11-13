class DailyCheckInModel {
  final String id;
  final String mood; // 'Good', 'Okay', 'Neutral', 'Low', 'Stressed', 'Tired'
  final int energy; // 1 to 5
  final int sleep; // 1 to 5
  final bool movedBody;
  final bool connected;
  final String meaningfulActivity;
  final DateTime date;

  DailyCheckInModel({
    required this.id,
    required this.mood,
    required this.energy,
    required this.sleep,
    required this.movedBody,
    required this.connected,
    required this.meaningfulActivity,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mood': mood,
      'energy': energy,
      'sleep': sleep,
      'movedBody': movedBody,
      'connected': connected,
      'meaningfulActivity': meaningfulActivity,
      'date': date.toIso8601String(),
    };
  }

  factory DailyCheckInModel.fromJson(Map<String, dynamic> json) {
    return DailyCheckInModel(
      id: json['id'] as String? ?? 'checkin_1',
      mood: json['mood'] as String? ?? 'Good',
      energy: (json['energy'] as num?)?.toInt() ?? 4,
      sleep: (json['sleep'] as num?)?.toInt() ?? 4,
      movedBody: json['movedBody'] as bool? ?? true,
      connected: json['connected'] as bool? ?? true,
      meaningfulActivity: json['meaningfulActivity'] as String? ?? 'Read a book',
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
