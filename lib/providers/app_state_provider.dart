import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/mood_model.dart';
import '../models/mission_model.dart';
import '../models/progress_model.dart';
import '../models/habit_model.dart';
import '../models/checkin_model.dart';
import '../models/chat_message_model.dart';
import '../models/activity_model.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';

enum VoiceState { idle, listening, speaking }

class AppStateProvider extends ChangeNotifier {
  final StorageService storage;
  final AiService aiService;

  UserModel _user = UserModel(
    id: 'user_1',
    name: 'Aarav',
    email: 'aarav@example.com',
    ageGroup: '18–40',
    interests: ['Walking', 'Reading', 'Music', 'Gardening'],
    goals: ['Gentle Movement', 'Calm Mind', 'Consistent Sleep'],
    createdAt: DateTime.now(),
  );

  MoodModel? _currentMood;
  String _supportiveMessage = "Take things one gentle breath at a time today.";
  
  List<MissionModel> _missions = [];
  late MissionModel _todayMission;
  
  List<HabitModel> _habits = [];
  ProgressModel _progress = const ProgressModel();
  List<DailyCheckInModel> _checkins = [];
  
  List<ChatMessageModel> _chatMessages = [];
  bool _isAiTyping = false;
  
  VoiceState _voiceState = VoiceState.idle;
  String _voiceTranscript = "";
  String _voiceAiResponse = "";
  bool _isMicMuted = false;
  bool _isSpeakerMuted = false;

  int _waterGlasses = 4;
  final int _targetWaterGlasses = 8;
  ActivityModel _activity = ActivityModel.initial();

  AppStateProvider({
    required this.storage,
    required this.aiService,
  }) {
    _initializeData();
  }

  // Getters
  UserModel get user => _user;
  MoodModel? get currentMood => _currentMood;
  String get supportiveMessage => _supportiveMessage;
  MissionModel get todayMission => _todayMission;
  List<MissionModel> get missions => _missions;
  List<HabitModel> get habits => _habits;
  ProgressModel get progress => _progress;
  List<DailyCheckInModel> get checkins => _checkins;
  List<ChatMessageModel> get chatMessages => _chatMessages;
  bool get isAiTyping => _isAiTyping;
  VoiceState get voiceState => _voiceState;
  String get voiceTranscript => _voiceTranscript;
  String get voiceAiResponse => _voiceAiResponse;
  bool get isMicMuted => _isMicMuted;
  bool get isSpeakerMuted => _isSpeakerMuted;
  int get waterGlasses => _waterGlasses;
  int get targetWaterGlasses => _targetWaterGlasses;
  ActivityModel get activity => _activity;
  bool get notificationsEnabled => storage.notificationsEnabled;

  void _initializeData() {
    final savedUser = storage.getUser();
    if (savedUser != null) {
      _user = savedUser;
    }

    _missions = storage.getMissions();
    if (_missions.isEmpty) {
      _missions = MissionModel.defaultMissionsPool();
    }
    _todayMission = _missions.first;

    _habits = storage.getHabits();
    _checkins = storage.getCheckins();
    _chatMessages = storage.getChatHistory();

    // Default welcoming initial chat message if empty
    if (_chatMessages.isEmpty) {
      _chatMessages = [
        ChatMessageModel(
          id: 'welcome_1',
          message: "Hi ${_user.name}! 😊 I'm your Rejuvenate companion. How are you feeling today?",
          sender: 'ai',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        )
      ];
    }

    // Set initial default mood
    _currentMood = MoodModel.defaultMoods[0];
    _supportiveMessage = _currentMood!.supportiveMessage;

    // Load saved activity steps & goals
    final savedSteps = storage.getSteps();
    final savedGoal = storage.getStepGoal();
    _activity = _activity.copyWith(
      steps: savedSteps,
      stepGoal: savedGoal,
      calories: (savedSteps * 0.048).round(),
      distanceKm: double.parse((savedSteps * 0.00076).toStringAsFixed(1)),
      activeMinutes: (savedSteps / 115).round(),
    );
  }

  // User Profile
  void updateUserProfile({
    String? name,
    String? email,
    String? ageGroup,
    List<String>? interests,
    List<String>? goals,
  }) {
    _user = _user.copyWith(
      name: name,
      email: email,
      ageGroup: ageGroup,
      interests: interests,
      goals: goals,
    );
    storage.saveUser(_user);
    notifyListeners();
  }

  void setAgeGroup(String ageGroup) {
    _user = _user.copyWith(ageGroup: ageGroup);
    storage.saveUser(_user);
    // Adapt today's mission if applicable
    _adaptMissionForAge();
    notifyListeners();
  }

  void _adaptMissionForAge() {
    if (_user.ageGroup == '10–17') {
      _todayMission = MissionModel(
        id: 'm_sports',
        title: 'Enjoy 15 minutes of outdoor sports',
        description: 'Have fun running, kicking a ball, or cycling with friends.',
        category: 'Body',
        icon: '🏏',
        date: '2026-10-16',
      );
    } else if (_user.ageGroup == '50+') {
      _todayMission = MissionModel(
        id: 'm_gentle_walk',
        title: 'Take a gentle 15-minute walk',
        description: 'Enjoy the fresh air, steady breathing, and peaceful steps.',
        category: 'Body',
        icon: '🚶',
        date: '2026-10-16',
      );
    }
  }

  // Mood Selection
  void selectMood(MoodModel mood) {
    _currentMood = mood;
    _supportiveMessage = mood.supportiveMessage;
    storage.saveMood(mood.label);
    
    // Slightly adjust mind score positively for checking in
    _progress = _progress.copyWith(
      mindScore: (_progress.mindScore + 0.02).clamp(0.0, 1.0),
    );
    notifyListeners();
  }

  // Mission Management
  void toggleTodayMissionDone() {
    final newStatus = !_todayMission.completed;
    _todayMission = _todayMission.copyWith(completed: newStatus);

    // Update in missions list
    final idx = _missions.indexWhere((m) => m.id == _todayMission.id);
    if (idx != -1) {
      _missions[idx] = _todayMission;
    } else {
      _missions.add(_todayMission);
    }
    storage.saveMissions(_missions);

    // Update progress
    final bonus = newStatus ? 0.05 : -0.05;
    _progress = _progress.copyWith(
      bodyScore: (_progress.bodyScore + bonus).clamp(0.0, 1.0),
      thisWeekProgress: (_progress.thisWeekProgress + (bonus * 0.5)).clamp(0.0, 1.0),
    );

    notifyListeners();
  }

  void swapMission() {
    final pool = MissionModel.defaultMissionsPool();
    final currentIndex = pool.indexWhere((m) => m.title == _todayMission.title);
    final nextIndex = (currentIndex + 1) % pool.length;
    _todayMission = pool[nextIndex];
    notifyListeners();
  }

  // Habit Management
  void toggleHabit(String habitId) {
    final idx = _habits.indexWhere((h) => h.id == habitId);
    if (idx != -1) {
      final habit = _habits[idx];
      final newCompleted = !habit.isCompletedToday;
      final newCompletedCount = newCompleted
          ? habit.completedDaysThisWeek + 1
          : (habit.completedDaysThisWeek - 1).clamp(0, 7);

      _habits[idx] = habit.copyWith(
        isCompletedToday: newCompleted,
        completedDaysThisWeek: newCompletedCount,
      );

      // Boost self-care / purpose progress
      if (newCompleted) {
        _progress = _progress.copyWith(
          selfCareScore: (_progress.selfCareScore + 0.02).clamp(0.0, 1.0),
        );
      }
      notifyListeners();
    }
  }

  // Water Tracker
  void incrementWater() {
    if (_waterGlasses < 12) {
      _waterGlasses++;
      notifyListeners();
    }
  }

  void decrementWater() {
    if (_waterGlasses > 0) {
      _waterGlasses--;
      notifyListeners();
    }
  }

  // Activity & Step Tracking
  void addSteps(int count) {
    final newSteps = _activity.steps + count;
    final newCalories = (newSteps * 0.048).round();
    final newDistance = double.parse((newSteps * 0.00076).toStringAsFixed(1));
    final newActiveMins = (newSteps / 115).round();

    // Update today's entry in weekly history
    final updatedHistory = _activity.weeklyHistory.map((rec) {
      if (rec.isToday) {
        return DailyStepRecord(
          dayLabel: rec.dayLabel,
          steps: newSteps,
          goal: rec.goal,
          isToday: true,
        );
      }
      return rec;
    }).toList();

    // Update hourly steps
    final updatedHourly = List<int>.from(_activity.hourlySteps);
    if (updatedHourly.isNotEmpty) {
      updatedHourly[updatedHourly.length - 1] = newSteps;
    }

    _activity = _activity.copyWith(
      steps: newSteps,
      calories: newCalories,
      distanceKm: newDistance,
      activeMinutes: newActiveMins,
      weeklyHistory: updatedHistory,
      hourlySteps: updatedHourly,
    );

    // Gently increment body vitality score in progress
    _progress = _progress.copyWith(
      bodyScore: (_progress.bodyScore + 0.02).clamp(0.0, 1.0),
    );

    storage.saveSteps(newSteps);
    notifyListeners();
  }

  void setStepGoal(int goal) {
    final updatedHistory = _activity.weeklyHistory.map((rec) {
      if (rec.isToday) {
        return DailyStepRecord(
          dayLabel: rec.dayLabel,
          steps: rec.steps,
          goal: goal,
          isToday: true,
        );
      }
      return rec;
    }).toList();

    _activity = _activity.copyWith(
      stepGoal: goal,
      weeklyHistory: updatedHistory,
    );
    storage.saveStepGoal(goal);
    notifyListeners();
  }

  void resetTodaySteps() {
    _activity = _activity.copyWith(
      steps: 0,
      calories: 0,
      distanceKm: 0.0,
      activeMinutes: 0,
    );
    storage.saveSteps(0);
    notifyListeners();
  }

  void addMindfulSession(int minutes) {
    _progress = _progress.copyWith(
      mindScore: (_progress.mindScore + (minutes * 0.01).clamp(0.02, 0.08)).clamp(0.0, 1.0),
      selfCareScore: (_progress.selfCareScore + (minutes * 0.008).clamp(0.02, 0.06)).clamp(0.0, 1.0),
    );
    notifyListeners();
  }

  // Daily Check-In
  void submitDailyCheckIn(DailyCheckInModel checkin) {
    _checkins.insert(0, checkin);
    storage.saveCheckin(checkin);

    // Boost overall scores gently
    _progress = _progress.copyWith(
      mindScore: (_progress.mindScore + 0.03).clamp(0.0, 1.0),
      bodyScore: (_progress.bodyScore + 0.03).clamp(0.0, 1.0),
      relationshipScore: (_progress.relationshipScore + 0.04).clamp(0.0, 1.0),
      purposeScore: (_progress.purposeScore + 0.04).clamp(0.0, 1.0),
    );

    notifyListeners();
  }

  // Notifications Toggle
  void toggleNotifications() {
    final newVal = !storage.notificationsEnabled;
    storage.setNotificationsEnabled(newVal);
    notifyListeners();
  }

  // AI Chat
  Future<void> sendChatMessage(String text, {String? quickActionTag}) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      message: text.trim(),
      sender: 'user',
      timestamp: DateTime.now(),
      quickActionTag: quickActionTag,
    );

    _chatMessages.add(userMsg);
    _isAiTyping = true;
    notifyListeners();

    try {
      final aiReply = await aiService.generateResponse(
        userMessage: text,
        user: _user,
        currentMood: _currentMood?.label,
        currentMission: _todayMission,
      );

      final aiMsg = ChatMessageModel(
        id: 'msg_ai_${DateTime.now().millisecondsSinceEpoch}',
        message: aiReply,
        sender: 'ai',
        timestamp: DateTime.now(),
      );

      _chatMessages.add(aiMsg);
      storage.saveChatHistory(_chatMessages);
    } catch (_) {
      final fallbackMsg = ChatMessageModel(
        id: 'msg_err_${DateTime.now().millisecondsSinceEpoch}',
        message: "I am here with you. Let's take things one calm step at a time.",
        sender: 'ai',
        timestamp: DateTime.now(),
      );
      _chatMessages.add(fallbackMsg);
    } finally {
      _isAiTyping = false;
      notifyListeners();
    }
  }

  // Voice Chat
  void startVoiceListening() {
    _voiceState = VoiceState.listening;
    _voiceTranscript = "Listening to you...";
    _voiceAiResponse = "";
    notifyListeners();

    // Simulate speech detection
    Timer(const Duration(seconds: 3), () async {
      if (_voiceState != VoiceState.listening) return;
      _voiceTranscript = "“Hi, I'm feeling a little tired today.”";
      _voiceState = VoiceState.speaking;
      _voiceAiResponse = "Let's keep today simple. Would you like a small body activity, a relaxing activity, or just a chat?";
      notifyListeners();

      // Return to idle after speech finishes
      Timer(const Duration(seconds: 4), () {
        if (_voiceState == VoiceState.speaking) {
          _voiceState = VoiceState.idle;
          notifyListeners();
        }
      });
    });
  }

  void stopVoiceListening() {
    _voiceState = VoiceState.idle;
    notifyListeners();
  }

  void toggleMicMute() {
    _isMicMuted = !_isMicMuted;
    notifyListeners();
  }

  void toggleSpeakerMute() {
    _isSpeakerMuted = !_isSpeakerMuted;
    notifyListeners();
  }

  void resetAllData() {
    storage.clearAll();
    _initializeData();
    notifyListeners();
  }
}
