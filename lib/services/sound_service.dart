import 'sound_service_interface.dart';
import 'sound_service_io.dart'
    if (dart.library.js) 'sound_service_web.dart';

class SoundService {
  static final SoundPlatform _platform = getSoundPlatform();

  static void playMeditationBell() {
    _platform.playMeditationBell();
  }

  static void playWorkoutAlarm() {
    _platform.playWorkoutAlarm();
  }

  static void playCountdownBeep() {
    _platform.playCountdownBeep();
  }

  static void startAmbient(String soundType) {
    _platform.startAmbient(soundType);
  }

  static void stopAmbient() {
    _platform.stopAmbient();
  }
}
