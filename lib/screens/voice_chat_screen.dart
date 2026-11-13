import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/voice_waveform.dart';

class VoiceChatScreen extends StatelessWidget {
  const VoiceChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isListening = appState.voiceState == VoiceState.listening;
    final isSpeaking = appState.voiceState == VoiceState.speaking;
    final isIdle = appState.voiceState == VoiceState.idle;

    String statusText = "Tap and Talk";
    if (isListening) statusText = "Listening...";
    if (isSpeaking) statusText = "Rejuvenate is speaking...";

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkCanvas : const Color(0xFFF2F7F4),
      appBar: AppBar(
        title: const Text('Voice Companion 🎙️'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            appState.stopVoiceListening();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text(
                'Speak naturally, like talking to a calm friend.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                ),
              ),
              const Spacer(),

              // Animated Waveform
              VoiceWaveformWidget(
                isAnimating: isListening || isSpeaking,
                barColor: isListening
                    ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                    : (isDark ? AppColors.darkLavender : AppColors.softLavender),
              ),
              const SizedBox(height: 36),

              // Large Animated Microphone Circle
              GestureDetector(
                onTap: () {
                  if (isListening || isSpeaking) {
                    appState.stopVoiceListening();
                  } else {
                    appState.startVoiceListening();
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isListening
                        ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                        : (isSpeaking
                            ? (isDark ? AppColors.darkLavender : AppColors.softLavender)
                            : (isDark ? AppColors.darkCard : Colors.white)),
                    border: Border.all(
                      color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                            .withValues(alpha: (isListening || isSpeaking) ? 0.4 : 0.15),
                        blurRadius: (isListening || isSpeaking) ? 32 : 16,
                        spreadRadius: (isListening || isSpeaking) ? 8 : 2,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    isListening ? Icons.mic_rounded : (isSpeaking ? Icons.volume_up_rounded : Icons.mic_none_rounded),
                    size: 56,
                    color: (isListening || isSpeaking)
                        ? Colors.white
                        : (isDark ? AppColors.darkMint : AppColors.primaryGreen),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Status Text
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),

              // Live Conversation Bubbles
              if (appState.voiceTranscript.isNotEmpty || appState.voiceAiResponse.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (appState.voiceTranscript.isNotEmpty) ...[
                        Row(
                          children: [
                            const Text('You: ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            Expanded(
                              child: Text(
                                appState.voiceTranscript,
                                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (appState.voiceAiResponse.isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('AI: ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primaryGreen)),
                            Expanded(
                              child: Text(
                                appState.voiceAiResponse,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                )
              else
                Text(
                  isIdle ? 'Tap the microphone circle to begin talking' : '',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                  ),
                ),

              const Spacer(),

              // Bottom Controls: Microphone, Speaker, End
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mic toggle
                    IconButton(
                      icon: Icon(
                        appState.isMicMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                        color: appState.isMicMuted ? Colors.redAccent : (isDark ? AppColors.darkMint : AppColors.primaryGreen),
                      ),
                      onPressed: () => appState.toggleMicMute(),
                      tooltip: 'Mute/Unmute Mic',
                    ),
                    const SizedBox(width: 16),
                    // Speaker toggle
                    IconButton(
                      icon: Icon(
                        appState.isSpeakerMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                        color: appState.isSpeakerMuted ? Colors.redAccent : (isDark ? AppColors.darkMint : AppColors.primaryGreen),
                      ),
                      onPressed: () => appState.toggleSpeakerMute(),
                      tooltip: 'Mute/Unmute Speaker',
                    ),
                    const SizedBox(width: 16),
                    // End Call
                    IconButton(
                      icon: const Icon(Icons.call_end_rounded, color: Colors.redAccent),
                      onPressed: () {
                        appState.stopVoiceListening();
                        Navigator.pop(context);
                      },
                      tooltip: 'End Voice Chat',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
