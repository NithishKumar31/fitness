import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/mission_model.dart';
import '../models/habit_model.dart';
import '../models/checkin_model.dart';
import '../models/chat_message_model.dart';

class StorageService {
  static const String _keyUser = 'rejuvenate_user';
  static const String _keyCurrentMood = 'rejuvenate_mood';
  static const String _keyMissions = 'rejuvenate_missions';
  static const String _keyCheckins = 'rejuvenate_checkins';
  static const String _keyChatHistory = 'rejuvenate_chat_history';
  static const String _keyOnboardingDone = 'rejuvenate_onboarding_done';
  static const String _keyDarkMode = 'rejuvenate_dark_mode';
  static const String _keyLanguage = 'rejuvenate_language';
  static const String _keyNotifications = 'rejuvenate_notifications';
  static const String _keySteps = 'rejuvenate_steps';
  static const String _keyStepGoal = 'rejuvenate_step_goal';

  SharedPreferences? _prefs;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (_) {
      // In-memory fallback if platform plugin is pending
    }
  }

  // Onboarding
  bool get isOnboardingCompleted => _prefs?.getBool(_keyOnboardingDone) ?? false;
  Future<void> setOnboardingCompleted(bool val) async {
    await _prefs?.setBool(_keyOnboardingDone, val);
  }

  // Theme & Language
  bool get isDarkMode => _prefs?.getBool(_keyDarkMode) ?? false;
  Future<void> setDarkMode(bool val) async {
    await _prefs?.setBool(_keyDarkMode, val);
  }

  String get languageCode => _prefs?.getString(_keyLanguage) ?? 'en';
  Future<void> setLanguageCode(String val) async {
    await _prefs?.setString(_keyLanguage, val);
  }

  bool get notificationsEnabled => _prefs?.getBool(_keyNotifications) ?? true;
  Future<void> setNotificationsEnabled(bool val) async {
    await _prefs?.setBool(_keyNotifications, val);
  }

  // User
  UserModel? getUser() {
    final raw = _prefs?.getString(_keyUser);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(UserModel user) async {
    await _prefs?.setString(_keyUser, jsonEncode(user.toJson()));
  }

  // Mood
  String? getSavedMood() => _prefs?.getString(_keyCurrentMood);
  Future<void> saveMood(String mood) async => await _prefs?.setString(_keyCurrentMood, mood);

  // Missions
  List<MissionModel> getMissions() {
    final raw = _prefs?.getString(_keyMissions);
    if (raw == null) return MissionModel.defaultMissionsPool();
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((item) => MissionModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return MissionModel.defaultMissionsPool();
    }
  }

  Future<void> saveMissions(List<MissionModel> missions) async {
    final raw = jsonEncode(missions.map((m) => m.toJson()).toList());
    await _prefs?.setString(_keyMissions, raw);
  }

  // Habits
  List<HabitModel> getHabits() {
    return HabitModel.defaultHabits();
  }

  // Check-ins
  List<DailyCheckInModel> getCheckins() {
    final raw = _prefs?.getString(_keyCheckins);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((item) => DailyCheckInModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCheckin(DailyCheckInModel checkin) async {
    final current = getCheckins();
    current.insert(0, checkin);
    final raw = jsonEncode(current.map((c) => c.toJson()).toList());
    await _prefs?.setString(_keyCheckins, raw);
  }

  // Chat
  List<ChatMessageModel> getChatHistory() {
    final raw = _prefs?.getString(_keyChatHistory);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((item) => ChatMessageModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveChatHistory(List<ChatMessageModel> history) async {
    final raw = jsonEncode(history.map((m) => m.toJson()).toList());
    await _prefs?.setString(_keyChatHistory, raw);
  }

  // Steps & Activity
  int getSteps() => _prefs?.getInt(_keySteps) ?? 6840;
  Future<void> saveSteps(int steps) async => await _prefs?.setInt(_keySteps, steps);

  int getStepGoal() => _prefs?.getInt(_keyStepGoal) ?? 10000;
  Future<void> saveStepGoal(int goal) async => await _prefs?.setInt(_keyStepGoal, goal);

  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
