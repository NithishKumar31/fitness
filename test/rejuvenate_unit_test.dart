import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/models/mood_model.dart';
import 'package:flutter_application_1/models/progress_model.dart';
import 'package:flutter_application_1/services/ai_service.dart';
import 'package:flutter_application_1/services/storage_service.dart';
import 'package:flutter_application_1/providers/app_state_provider.dart';

void main() {
  group('Rejuvenate Models & Safety Logic Tests', () {
    test('ProgressModel computes percentages and non-medical scores correctly', () {
      const progress = ProgressModel(
        mindScore: 0.72,
        bodyScore: 0.65,
        selfCareScore: 0.80,
        relationshipScore: 0.60,
        purposeScore: 0.55,
      );

      expect(progress.mindPercentage, 72);
      expect(progress.bodyPercentage, 65);
      expect(progress.selfCarePercentage, 80);
      expect(progress.relationshipPercentage, 60);
      expect(progress.purposePercentage, 55);
      expect(progress.overallPercentage, 66);
    });

    test('CompanionAiService safely handles distress keywords', () async {
      final ai = CompanionAiService();
      final user = UserModel(
        id: 'u1',
        name: 'Aarav',
        email: 'test@example.com',
        ageGroup: '18–40',
        interests: ['Reading'],
        goals: ['Calm'],
        createdAt: DateTime.now(),
      );

      final response = await ai.generateResponse(
        userMessage: 'I feel like I want to hurt myself today',
        user: user,
      );

      // Verify safety and support helpline recommendation without medical diagnosis
      expect(response.toLowerCase().contains('qualified professional') || response.toLowerCase().contains('support'), isTrue);
      expect(response.contains('diagnose'), isFalse);
    });

    test('CompanionAiService provides age-appropriate suggestions for 10-17', () async {
      final ai = CompanionAiService();
      final youthUser = UserModel(
        id: 'u2',
        name: 'Rohan',
        email: 'rohan@example.com',
        ageGroup: '10–17',
        interests: ['Sports'],
        goals: ['Play'],
        createdAt: DateTime.now(),
      );

      final response = await ai.generateResponse(
        userMessage: 'Give me a small mission',
        user: youthUser,
      );

      expect(response.contains('kick a ball') || response.contains('🏏') || response.contains('outside'), isTrue);
    });

    test('AppStateProvider mission toggle and mood updates work reactively', () {
      final storage = StorageService();
      final ai = CompanionAiService();
      final provider = AppStateProvider(storage: storage, aiService: ai);

      // Verify initial mission state
      expect(provider.todayMission.completed, isFalse);

      // Toggle done
      provider.toggleTodayMissionDone();
      expect(provider.todayMission.completed, isTrue);

      // Select tired mood
      final tiredMood = MoodModel.defaultMoods.firstWhere((m) => m.label == 'Tired');
      provider.selectMood(tiredMood);
      expect(provider.currentMood?.label, 'Tired');
      expect(provider.supportiveMessage.contains('simple'), isTrue);
    });
  });
}
