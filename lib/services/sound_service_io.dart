import 'package:flutter/services.dart';
import 'sound_service_interface.dart';

class SoundPlatformImpl implements SoundPlatform {
  @override
  void playMeditationBell() {
    SystemSound.play(SystemSoundType.alert);
  }

  @override
  void playWorkoutAlarm() {
    SystemSound.play(SystemSoundType.alert);
  }
  @override
  void playCountdownBeep() {
    SystemSound.play(SystemSoundType.click);
  }

  @override
  void startAmbient(String soundType) {}

  @override
  void stopAmbient() {}
}

SoundPlatform getSoundPlatform() => SoundPlatformImpl();
