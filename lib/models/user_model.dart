class UserModel {
  final String id;
  final String name;
  final String email;
  final String ageGroup; // '10–17', '18–40', '41–50', '50+'
  final List<String> interests;
  final List<String> goals;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.ageGroup,
    required this.interests,
    required this.goals,
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? ageGroup,
    List<String>? interests,
    List<String>? goals,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      ageGroup: ageGroup ?? this.ageGroup,
      interests: interests ?? this.interests,
      goals: goals ?? this.goals,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'ageGroup': ageGroup,
      'interests': interests,
      'goals': goals,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? 'user_1',
      name: json['name'] as String? ?? 'Friend',
      email: json['email'] as String? ?? 'friend@example.com',
      ageGroup: json['ageGroup'] as String? ?? '18–40',
      interests: (json['interests'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          ['Reading', 'Music', 'Gardening'],
      goals: (json['goals'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          ['Gentle Movement', 'Calm Mind', 'Consistent Sleep'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
