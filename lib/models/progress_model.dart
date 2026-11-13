class ProgressModel {
  final double mindScore; // 0.0 - 1.0
  final double bodyScore;
  final double selfCareScore;
  final double relationshipScore;
  final double purposeScore;
  final double thisWeekProgress;
  final double lastWeekProgress;

  const ProgressModel({
    this.mindScore = 0.72,
    this.bodyScore = 0.65,
    this.selfCareScore = 0.80,
    this.relationshipScore = 0.60,
    this.purposeScore = 0.55,
    this.thisWeekProgress = 0.66,
    this.lastWeekProgress = 0.62,
  });

  double get overallProgress {
    return (mindScore + bodyScore + selfCareScore + relationshipScore + purposeScore) / 5.0;
  }

  int get overallPercentage => (overallProgress * 100).round();
  int get mindPercentage => (mindScore * 100).round();
  int get bodyPercentage => (bodyScore * 100).round();
  int get selfCarePercentage => (selfCareScore * 100).round();
  int get relationshipPercentage => (relationshipScore * 100).round();
  int get purposePercentage => (purposeScore * 100).round();

  ProgressModel copyWith({
    double? mindScore,
    double? bodyScore,
    double? selfCareScore,
    double? relationshipScore,
    double? purposeScore,
    double? thisWeekProgress,
    double? lastWeekProgress,
  }) {
    return ProgressModel(
      mindScore: mindScore ?? this.mindScore,
      bodyScore: bodyScore ?? this.bodyScore,
      selfCareScore: selfCareScore ?? this.selfCareScore,
      relationshipScore: relationshipScore ?? this.relationshipScore,
      purposeScore: purposeScore ?? this.purposeScore,
      thisWeekProgress: thisWeekProgress ?? this.thisWeekProgress,
      lastWeekProgress: lastWeekProgress ?? this.lastWeekProgress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mindScore': mindScore,
      'bodyScore': bodyScore,
      'selfCareScore': selfCareScore,
      'relationshipScore': relationshipScore,
      'purposeScore': purposeScore,
      'thisWeekProgress': thisWeekProgress,
      'lastWeekProgress': lastWeekProgress,
    };
  }

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      mindScore: (json['mindScore'] as num?)?.toDouble() ?? 0.72,
      bodyScore: (json['bodyScore'] as num?)?.toDouble() ?? 0.65,
      selfCareScore: (json['selfCareScore'] as num?)?.toDouble() ?? 0.80,
      relationshipScore: (json['relationshipScore'] as num?)?.toDouble() ?? 0.60,
      purposeScore: (json['purposeScore'] as num?)?.toDouble() ?? 0.55,
      thisWeekProgress: (json['thisWeekProgress'] as num?)?.toDouble() ?? 0.66,
      lastWeekProgress: (json['lastWeekProgress'] as num?)?.toDouble() ?? 0.62,
    );
  }
}
