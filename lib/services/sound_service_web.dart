// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'sound_service_interface.dart';

class SoundPlatformImpl implements SoundPlatform {
  @override
  void playMeditationBell() {
    try {
      js.context.callMethod('playRejuvenateSound', ['meditation_bell']);
    } catch (_) {}
  }

  @override
  void playWorkoutAlarm() {
    try {
      js.context.callMethod('playRejuvenateSound', ['workout_alarm']);
    } catch (_) {}
  }

  @override
  void playCountdownBeep() {
    try {
      js.context.callMethod('playRejuvenateSound', ['countdown_beep']);
    } catch (_) {}
  }

  @override
  void startAmbient(String soundType) {
    try {
      js.context.callMethod('startRejuvenateAmbient', [soundType]);
    } catch (_) {}
  }

  @override
  void stopAmbient() {
    try {
      js.context.callMethod('stopRejuvenateAmbient');
    } catch (_) {}
  }
}

SoundPlatform getSoundPlatform() => SoundPlatformImpl();
