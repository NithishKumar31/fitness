import '../models/user_model.dart';
import '../models/mission_model.dart';

abstract class AiService {
  Future<String> generateResponse({
    required String userMessage,
    required UserModel user,
    String? currentMood,
    MissionModel? currentMission,
    String? languageCode,
  });

  Future<String> generateVoiceResponse({
    required String speechText,
    required UserModel user,
    String? currentMood,
  });
}

class CompanionAiService implements AiService {
  @override
  Future<String> generateResponse({
    required String userMessage,
    required UserModel user,
    String? currentMood,
    MissionModel? currentMission,
    String? languageCode,
  }) async {
    // Simulate brief network / processing time for natural conversation flow
    await Future.delayed(const Duration(milliseconds: 650));

    final rawLower = userMessage.toLowerCase().trim();
    final isTamil = languageCode == 'ta';
    // Clean punctuation for robust matching
    final lower = rawLower.replaceAll(RegExp(r'[^\w\s]'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

    // 1. Math calculation check (e.g. "30+30", "15 * 2", "100 / 4")
    final mathResult = _evaluateMath(rawLower);
    if (mathResult != null) {
      return mathResult;
    }

    // 2. Safety check: Distress or medical emergency
    if (_containsDistress(lower)) {
      if (isTamil) {
        return "நீங்கள் அதிக மன உளைச்சலில் இருப்பது போல் தெரிகிறது. தயவுசெய்து உங்களுக்கு நெருக்கமானவரிடமோ அல்லது நம்பகமான மருத்துவ நிபுணரிடமோ பேசுங்கள். நீங்கள் தனியாக இல்லை. 💚";
      }
      return "I hear that things feel very difficult right now. Please know you are not alone. Rejuvenate is here for gentle everyday habits, but for deep distress, talking with someone you trust or a qualified professional / support helpline can provide the care you deserve. 💚";
    }

    // 3. Greetings (handles 'holle', 'helo', 'hello', 'hi', 'hey', 'namaste', etc.)
    if (_isGreeting(lower)) {
      if (isTamil) {
        return "வணக்கம் ${user.name}! 😊 உங்களைப் பார்ப்பதில் மகிழ்ச்சி. இன்று நீங்கள் எப்படி உணர்கிறீர்கள்?";
      }
      return "Hi ${user.name}! 😊 Nice to see you. How are you feeling today?";
    }

    // 4. Name & identity queries (e.g., "you name", "your name", "who are you")
    if (lower == 'you name' ||
        lower == 'your name' ||
        lower == 'ur name' ||
        lower == 'name' ||
        lower.contains('you name') ||
        lower.contains('your name') ||
        lower.contains('ur name') ||
        lower.contains('who are you') ||
        lower.contains('what are you') ||
        lower.contains('whats your name') ||
        lower.contains('what is your name')) {
      if (isTamil) {
        return "நான் உங்கள் Rejuvenate AI நலவாழ்வு வழிகாட்டி! 🌿 உடற்பயிற்சி மற்றும் மன அமைதிக்கு வழிகாட்ட நான் தயாராக உள்ளேன்.";
      }
      return "I'm your Rejuvenate AI Wellness Coach! 🌿 I'm here to support your daily wellness, guide you through quick 2-minute missions, track healthy habits, and help you feel your best every day. What's on your mind today, ${user.name}?";
    }

    // 5. User name / identity query
    if (lower.contains('my name') || lower.contains('who am i')) {
      return "You are ${user.name}! 🌟 You're on an inspiring journey toward everyday vitality and peace of mind. I'm honored to accompany you!";
    }

    // 6. "How are you" / Check-in
    if (lower.contains('how are you') ||
        lower.contains('how are u') ||
        lower.contains('how r u') ||
        lower.contains('how r you') ||
        lower.contains('how do you do') ||
        lower.contains('hows it going') ||
        lower.contains('whats up') ||
        lower.contains('what s up')) {
      return "I'm doing great, thank you for asking, ${user.name}! 😊 I'm here and ready to support your health & peace of mind. How is your energy today?";
    }

    // 7. "What can you do" / "Help"
    if (lower == 'help' ||
        lower.contains('what can you do') ||
        lower.contains('what can u do') ||
        lower.contains('how to use')) {
      return "I'm your Rejuvenate AI Wellness Companion! 🌿 I can guide you through quick 2-minute daily missions, mindful breathing, destressing techniques, hydration checks, and healthy habits. Try tapping one of the chips above or ask me anything!";
    }

    // 8. Casual acknowledgments (e.g. "ok", "cool", "yes")
    if (lower == 'ok' || lower == 'okay' || lower == 'cool' || lower == 'yes' || lower == 'yep' || lower == 'sure' || lower == 'nice' || lower == 'fine' || lower == 'great') {
      return "Awesome! 😊 Whenever you're ready, tap one of the wellness chips above or let me know what you'd like to focus on.";
    }

    // 9. Jokes & Fun
    if (lower.contains('joke') || lower.contains('laugh') || lower.contains('funny')) {
      return "Why did the tomato blush? 🍅 Because it saw the salad dressing! 😂 Keep that smile going—laughter is one of the best wellness boosters for your heart and mood!";
    }

    // 10. Nutrition / Diet / Weight / Food
    if (lower.contains('weight') || lower.contains('diet') || lower.contains('food') || lower.contains('eat') || lower.contains('fat') || lower.contains('nutrition')) {
      return "Nourishing your body is an act of self-care! 🥗 Focus on whole foods, fresh colorful produce, adequate protein, and plenty of water. Even swapping sugary drinks for herbal tea or infused water makes a huge difference!";
    }

    // 11. Workouts / Gym / Exercise
    if (lower.contains('workout') || lower.contains('gym') || lower.contains('exercise') || lower.contains('muscle') || lower.contains('fitness') || lower.contains('yoga')) {
      return "Consistency beats intensity every single time! 🏃 Even a 15-minute daily walk, 10 squats, or gentle yoga stretches keep your joints healthy, boost dopamine, and maintain metabolic vigor.";
    }

    // 11b. Steps & Walking & Activity Tracker
    if (lower.contains('step') || lower.contains('walk') || lower.contains('calorie') || lower.contains('burn')) {
      return "Walking is one of the most powerful everyday longevity practices! 👟 Aiming for 7,000–10,000 steps daily improves cardiovascular health, burns healthy active calories, and lowers stress. Check out your live rings in our Step & Calorie Tracker!";
    }

    // 12. Motivation / Laziness
    if (lower.contains('lazy') || lower.contains('unmotivated') || lower.contains('procrastinat')) {
      return "Be gentle with yourself—everyone experiences low-energy moments! 💡 The secret is the '2-Minute Rule': just do one tiny action, like standing up to drink a fresh glass of water or rolling your shoulders. Action creates motivation!";
    }

    // 13. Gratitude / Compliments
    if (lower.contains('thank') || lower == 'thanks' || lower == 'thx' || lower.contains('appreciate') || lower.contains('good job')) {
      return "You're very welcome, ${user.name}! 🌟 Taking small steps for your well-being is something to be proud of. I'm always here for you.";
    }

    // 14. Goodbyes / Sleep
    if (lower.contains('bye') || lower.contains('goodnight') || lower.contains('good night') || lower.contains('see you')) {
      return "Rest well and take good care of yourself, ${user.name}! 🌙 I'll be right here whenever you want to check in again.";
    }

    // 15. Tiredness
    if (lower.contains('tired') || lower.contains('exhausted') || lower.contains('sleepy')) {
      if (isTamil) {
        return "இன்று காரியங்களை எளிமையாக வைத்துக் கொள்வோம். நீங்கள் சற்று ஓய்வெடுக்க விரும்புகிறீர்களா, அல்லது ஒரு சிறிய உடல் அசைவு செய்யலாமா?";
      }
      return "Let's keep things simple today. Would you like a small body activity, a relaxing activity, or just a chat?";
    }

    // 16. Stressed / Anxious
    if (lower.contains('stress') || lower.contains('anxious') || lower.contains('overwhelm') || lower.contains('nervous') || lower.contains('destress')) {
      return "Take a deep breath and give yourself a little pause. You don't have to carry or fix everything in this single moment. Would you like to do a quick 2-minute breathing exercise together?";
    }

    // 17. Positive mood
    if (lower.contains('good') || lower.contains('great') || lower.contains('happy') || lower.contains('awesome') || lower.contains('energized')) {
      return "That is wonderful to hear, ${user.name}! ✨ When your energy is good, it's a great moment to enjoy a light walk or complete one of your daily wellness missions.";
    }

    // 18. Low mood / Sad
    if (lower.contains('sad') || lower.contains('down') || lower.contains('bad') || lower.contains('low') || lower.contains('unhappy')) {
      return "I'm sorry things feel heavy right now, ${user.name}. 💙 Remember to be extra kind to yourself. Even taking 5 minutes to sit peacefully or sip some warm water can bring a gentle comfort.";
    }

    // 19. Hydration
    if (lower.contains('water') || lower.contains('hydrat')) {
      return "Hydration is essential for keeping your energy, focus, and body revitalized! 💧 Take a moment to drink a full glass of fresh water right now.";
    }

    // 20. Quick action: How am I feeling?
    if (lower.contains('how am i feeling') || lower.contains('how am i doing')) {
      if (currentMood != null) {
        return "Earlier you noted feeling $currentMood. Remember that emotions fluctuate throughout the day, and whatever you're experiencing right now is completely valid. How does your body feel in this moment?";
      }
      return "How does your body and mind feel right now? Are you carrying any tension in your shoulders or feeling relatively light?";
    }

    // 21. Quick action: Give me a small mission
    if (lower.contains('mission') || lower.contains('task') || lower.contains('give me a')) {
      final missionSuggestion = _getAgeAppropriateMission(user);
      return "Here is one small, gentle idea for you today: $missionSuggestion. No pressure, just take it at your own rhythm!";
    }

    // 22. Quick action: Help me relax / Breathing
    if (lower.contains('relax') || lower.contains('calm') || lower.contains('slow down') || lower.contains('breath') || lower.contains('meditat')) {
      return "Let's relax together. Drop your shoulders down away from your ears, unclench your jaw, and take one slow, deep breath in for 4 seconds... hold for 2... and gently exhale for 4. How does that feel?";
    }

    // 23. Quick action: Morning routine tips
    if (lower.contains('morning routine') || lower.contains('morning tip') || lower.contains('routine')) {
      return "A refreshing morning routine: 1️⃣ Drink a glass of water upon waking, 2️⃣ Spend 5 minutes in natural morning light, and 3️⃣ Do 2 minutes of gentle stretching. It gently wakes up your circulation without any rush!";
    }

    // 24. Quick action: Body activity / Movement
    if (lower.contains('body') || lower.contains('movement') || lower.contains('exercise') || lower.contains('walk')) {
      final bodySuggestion = _getBodySuggestionForAge(user.ageGroup);
      return "For feeling more energized in your body, here is a friendly idea suited for you: $bodySuggestion. Remember to listen to your body and move at your own comfort!";
    }

    // 25. Quick action: Self-care
    if (lower.contains('self-care') || lower.contains('self care') || lower.contains('skin') || lower.contains('comfort')) {
      return "Self-care isn't about perfection—it's about feeling comfortable and cared for. How about drinking a fresh glass of water, washing your face with cool water, or putting on your favorite comfortable clothes?";
    }

    // 26. Quick action: Talk to me / Just talk
    if (lower.contains('talk to me') || lower.contains('just talk') || lower.contains('tell me something')) {
      return "I'm always glad to talk with you. What was one quiet, pleasant thing that happened recently—maybe a warm drink, a kind word, or a pleasant breeze?";
    }

    // 27. Quick action: My progress
    if (lower.contains('progress') || lower.contains('score') || lower.contains('habits')) {
      return "You're taking steady, everyday steps! Remember, this isn't a score to judge yourself by; it's just celebrating every small habit you've built. Keep treating yourself with kindness!";
    }

    // 28. Contextual response honoring user's age and interests
    if (user.interests.isNotEmpty) {
      for (final interest in user.interests) {
        if (lower.contains(interest.toLowerCase())) {
          return "I love that you enjoy $interest! Making even 10 minutes today for $interest can give your day a wonderful spark of aliveness.";
        }
      }
    }

    // 29. Question fallback
    if (rawLower.endsWith('?') || lower.startsWith('what') || lower.startsWith('why') || lower.startsWith('how') || lower.startsWith('can you') || lower.startsWith('could you')) {
      return "That's a thoughtful question! 💡 As your Rejuvenate Wellness Coach, my focus is helping you maintain vibrant energy, peace of mind, and healthy habits. Would you like a 2-minute daily mission or a quick breathing pause right now?";
    }

    // 30. Diverse dynamic fallbacks instead of a single repetitive sentence
    final fallbacks = [
      "Thank you for sharing that with me, ${user.name}! Every day has its own rhythm. Is there something small and enjoyable you can do for yourself in the next hour? 🌿",
      "I hear you! Taking time for yourself is essential. Would you like to try a quick 2-minute breathing exercise or a light stretch? ✨",
      "I'm here with you, ${user.name}! Remember that every small healthy choice adds up to big well-being. How are your shoulders and breathing feeling right now? 💚",
    ];
    return fallbacks[userMessage.length % fallbacks.length];
  }

  @override
  Future<String> generateVoiceResponse({
    required String speechText,
    required UserModel user,
    String? currentMood,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final lower = speechText.toLowerCase().trim();

    if (lower.contains('hi') || lower.contains('hello')) {
      return "Hi! 😊 How are you feeling today?";
    }
    if (lower.contains('tired') || lower.contains('exhausted')) {
      return "That's okay. Let's keep today simple. Would you like to relax, move a little, or just talk?";
    }
    if (lower.contains('good') || lower.contains('great')) {
      return "I'm really glad to hear that! What's something pleasant you're looking forward to?";
    }
    if (lower.contains('walk') || lower.contains('move')) {
      return "A small walk sounds lovely. Fresh air and gentle movement make such a difference.";
    }
    return "I hear you. Let's take it one calm step at a time today.";
  }

  bool _containsDistress(String text) {
    final distressKeywords = [
      'kill myself',
      'suicide',
      'end my life',
      'hurt myself',
      'want to die',
      'no reason to live',
    ];
    return distressKeywords.any((k) => text.contains(k));
  }

  bool _isGreeting(String text) {
    final words = text.split(' ').where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return false;
    final firstWord = words.first;

    // Check common greetings & frequent typos (e.g., holle, helo, etc.)
    const greetingWords = {
      'hi', 'hii', 'hiii', 'hello', 'helo', 'holle', 'hellow', 'helloo',
      'hey', 'heyy', 'heyyy', 'hlo', 'hlw', 'hola', 'namaste', 'vanakkam',
      'yo', 'sup', 'greetings', 'aloha', 'bonjour',
    };

    if (greetingWords.contains(text) || greetingWords.contains(firstWord)) {
      return true;
    }

    if (text.contains('good morning') ||
        text.contains('good afternoon') ||
        text.contains('good evening') ||
        text.contains('good day') ||
        text.startsWith('hey ') ||
        text.startsWith('hi ') ||
        text.startsWith('hello ')) {
      return true;
    }

    return false;
  }

  String _getAgeAppropriateMission(UserModel user) {
    switch (user.ageGroup) {
      case '10–17':
        return "Step outside to kick a ball or stretch for 10 minutes 🏏";
      case '18–40':
        return "Take a refreshing 10-minute stroll around your block 🚶";
      case '41–50':
        return "Do 5 minutes of gentle neck and shoulder mobility stretches 🧘";
      case '50+':
        return "Enjoy a comfortable 10-minute walk and practice a 1-minute gentle balance stand ⚖️";
      default:
        return "Take a 10-minute walk and enjoy the outdoors 🚶";
    }
  }

  String _getBodySuggestionForAge(String ageGroup) {
    switch (ageGroup) {
      case '10–17':
        return "Play an energetic outdoor game or do some fun full-body stretching.";
      case '18–40':
        return "A brisk 15-minute walk followed by gentle wrist and hamstring stretches.";
      case '41–50':
        return "Gentle joint mobility exercises for your back and shoulders, plus a calm walk.";
      case '50+':
        return "A gentle, steady walk and light balance practice near a supportive chair.";
      default:
        return "A gentle 10-minute walk and easy stretching.";
    }
  }

  String? _evaluateMath(String input) {
    // Matches patterns like "30+30", "30 + 30", "15*4", "100 / 2", "50 - 25"
    final clean = input.replaceAll(' ', '');
    final match = RegExp(r'^(\d+(\.\d+)?)\s*([\+\-\*\/xX])\s*(\d+(\.\d+)?)$').firstMatch(clean);
    if (match != null) {
      final a = double.tryParse(match.group(1)!);
      String op = match.group(3)!;
      if (op == 'x' || op == 'X') op = '*';
      final b = double.tryParse(match.group(4)!);
      if (a != null && b != null) {
        double result = 0;
        if (op == '+') {
          result = a + b;
        } else if (op == '-') {
          result = a - b;
        } else if (op == '*') {
          result = a * b;
        } else if (op == '/') {
          if (b == 0) {
            return "Dividing by zero is impossible, but taking a mindful deep breath is always possible! 😉";
          }
          result = a / b;
        }
        final resultStr = (result % 1 == 0) ? result.toInt().toString() : result.toStringAsFixed(2);
        final aStr = (a % 1 == 0) ? a.toInt().toString() : a.toString();
        final bStr = (b % 1 == 0) ? b.toInt().toString() : b.toString();
        final displayOp = op == '*' ? '×' : (op == '/' ? '÷' : op);
        return "$aStr $displayOp $bStr = $resultStr! 🧮 Keeping your brain sharp with quick calculations is a wonderful mental exercise! How can I help with your wellness today?";
      }
    }
    return null;
  }
}
