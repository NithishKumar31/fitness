class ActivityModel {
  final int steps;
  final int stepGoal;
  final int calories;
  final int calorieGoal;
  final int activeMinutes;
  final int activeMinutesGoal;
  final double distanceKm;
  final List<int> hourlySteps; // Steps across 6:00, 9:00, 12:00, 15:00, 18:00, 21:00
  final List<DailyStepRecord> weeklyHistory;

  const ActivityModel({
    required this.steps,
    required this.stepGoal,
    required this.calories,
    required this.calorieGoal,
    required this.activeMinutes,
    required this.activeMinutesGoal,
    required this.distanceKm,
    required this.hourlySteps,
    required this.weeklyHistory,
  });

  double get stepProgress => (steps / (stepGoal > 0 ? stepGoal : 10000)).clamp(0.0, 1.0);
  double get calorieProgress => (calories / (calorieGoal > 0 ? calorieGoal : 500)).clamp(0.0, 1.0);
  double get activeMinutesProgress => (activeMinutes / (activeMinutesGoal > 0 ? activeMinutesGoal : 60)).clamp(0.0, 1.0);

  ActivityModel copyWith({
    int? steps,
    int? stepGoal,
    int? calories,
    int? calorieGoal,
    int? activeMinutes,
    int? activeMinutesGoal,
    double? distanceKm,
    List<int>? hourlySteps,
    List<DailyStepRecord>? weeklyHistory,
  }) {
    return ActivityModel(
      steps: steps ?? this.steps,
      stepGoal: stepGoal ?? this.stepGoal,
      calories: calories ?? this.calories,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      activeMinutesGoal: activeMinutesGoal ?? this.activeMinutesGoal,
      distanceKm: distanceKm ?? this.distanceKm,
      hourlySteps: hourlySteps ?? this.hourlySteps,
      weeklyHistory: weeklyHistory ?? this.weeklyHistory,
    );
  }

  static ActivityModel initial() {
    return const ActivityModel(
      steps: 6840,
      stepGoal: 10000,
      calories: 342,
      calorieGoal: 500,
      activeMinutes: 42,
      activeMinutesGoal: 60,
      distanceKm: 4.8,
      hourlySteps: [420, 1150, 1860, 2400, 3900, 6840],
      weeklyHistory: [
        DailyStepRecord(dayLabel: 'Mon', steps: 7450, goal: 10000),
        DailyStepRecord(dayLabel: 'Tue', steps: 8900, goal: 10000),
        DailyStepRecord(dayLabel: 'Wed', steps: 6200, goal: 10000),
        DailyStepRecord(dayLabel: 'Thu', steps: 10350, goal: 10000),
        DailyStepRecord(dayLabel: 'Fri', steps: 8800, goal: 10000),
        DailyStepRecord(dayLabel: 'Sat', steps: 11200, goal: 10000),
        DailyStepRecord(dayLabel: 'Sun', steps: 6840, goal: 10000, isToday: true),
      ],
    );
  }
}

class DailyStepRecord {
  final String dayLabel;
  final int steps;
  final int goal;
  final bool isToday;

  const DailyStepRecord({
    required this.dayLabel,
    required this.steps,
    required this.goal,
    this.isToday = false,
  });

  bool get reachedGoal => steps >= goal;
  double get progress => (steps / (goal > 0 ? goal : 10000)).clamp(0.0, 1.0);
}
