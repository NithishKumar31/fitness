import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../services/sound_service.dart';
import '../theme/app_colors.dart';

enum SessionType { walking, meditation }

enum DigitalDisplayMode { digitalWatch, gpsTrail, proCockpit }

class LiveSessionScreen extends StatefulWidget {
  final SessionType type;
  final int initialMinutes;
  final String title;
  final String icon;

  const LiveSessionScreen({
    super.key,
    required this.type,
    this.initialMinutes = 15,
    this.title = 'Walking Session',
    this.icon = '👟',
  });

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen>
    with TickerProviderStateMixin {
  late int _selectedMinutes;
  late int _totalSeconds;
  late int _remainingSeconds;
  int _elapsedSeconds = 0;
  int _tenths = 0;

  bool _isRunning = false;
  bool _isPaused = false;
  bool _isCompleted = false;

  Timer? _timer;
  Timer? _tenthsTimer;

  // Display Mode (defaults to Digital Smartwatch)
  DigitalDisplayMode _displayMode = DigitalDisplayMode.digitalWatch;

  // Real-time walking metrics
  int _sessionSteps = 0;
  int _sessionCalories = 0;
  double _sessionDistance = 0.0;
  int _currentBpm = 114;
  int _cadenceSpm = 116;
  int _strideCounter = 0;

  // Meditation Ambient Audio & Breathing
  String _activeAmbient = 'drone'; // 'drone', 'rain', 'ocean', 'silent'
  late AnimationController _breatheController;
  late Animation<double> _breatheAnimation;
  late AnimationController _heartPulseController;
  late Animation<double> _heartPulseAnimation;
  late AnimationController _radarController;

  String _breathePhase = 'Inhale Slowly...';
  String _breatheSub = 'Fill your lungs with pure vitality';
  int _phaseSecondsLeft = 4;

  @override
  void initState() {
    super.initState();
    _selectedMinutes = widget.initialMinutes;
    _totalSeconds = _selectedMinutes * 60;
    _remainingSeconds = _totalSeconds;

    // Breathing Controller (14s cycle: 4s inhale, 4s hold, 4s exhale, 2s rest)
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _breatheAnimation = Tween<double>(begin: 0.82, end: 1.28).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOutCubic),
    );

    // Heart Pulse Controller
    _heartPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _heartPulseAnimation = Tween<double>(begin: 0.92, end: 1.15).animate(
      CurvedAnimation(parent: _heartPulseController, curve: Curves.easeInOut),
    );

    // Radar pulse controller for GPS beacon
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    // Start ambient sound if meditation
    if (widget.type == SessionType.meditation) {
      SoundService.startAmbient(_activeAmbient);
      SoundService.playMeditationBell();
    } else {
      SoundService.playCountdownBeep();
    }

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _tenthsTimer?.cancel();

    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    if (widget.type == SessionType.meditation) {
      _breatheController.repeat(reverse: true);
      if (_activeAmbient != 'silent') {
        SoundService.startAmbient(_activeAmbient);
      }
    }

    // 100ms timer for tenths of second & digital animations
    _tenthsTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _tenths = (_tenths + 1) % 10;
      });
    });

    // 1-second accurate cadence timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _elapsedSeconds++;

          if (widget.type == SessionType.walking) {
            // Realistic step generation: 1 or 2 steps per second (~105-115 steps/min)
            _strideCounter++;
            final addedStep = (_strideCounter % 4 == 0) ? 2 : 1;
            _sessionSteps += addedStep;
            _sessionCalories = (_sessionSteps * 0.048).round();
            _sessionDistance =
                double.parse((_sessionSteps * 0.00076).toStringAsFixed(2));

            // Fluctuating realistic BPM (112 - 124)
            final variance = ((_elapsedSeconds * 7) % 7) - 3;
            _currentBpm = (116 + variance).clamp(108, 128);
            _cadenceSpm = (_sessionSteps > 10)
                ? ((_sessionSteps * 60) ~/ math.max(1, _elapsedSeconds))
                    .clamp(90, 135)
                : 116;
          } else {
            // Meditation Breathing Phases: 4s Inhale, 4s Hold, 4s Exhale, 2s Rest
            final cycleSec = _elapsedSeconds % 14;
            if (cycleSec < 4) {
              _breathePhase = 'Inhale Slowly...';
              _breatheSub = 'Fill lungs with soothing oxygen';
              _phaseSecondsLeft = 4 - cycleSec;
            } else if (cycleSec < 8) {
              _breathePhase = 'Hold Gently...';
              _breatheSub = 'Rest comfortably in stillness';
              _phaseSecondsLeft = 8 - cycleSec;
            } else if (cycleSec < 12) {
              _breathePhase = 'Exhale Softly...';
              _breatheSub = 'Release all tension and stress';
              _phaseSecondsLeft = 12 - cycleSec;
            } else {
              _breathePhase = 'Rest in Peace...';
              _breatheSub = 'Completely centered and calm';
              _phaseSecondsLeft = 14 - cycleSec;
            }
          }
        } else {
          _onTimerCompleted();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _tenthsTimer?.cancel();
    if (widget.type == SessionType.meditation) {
      _breatheController.stop();
      SoundService.stopAmbient();
    }
    setState(() {
      _isPaused = true;
      _isRunning = false;
    });
  }

  void _resumeTimer() {
    SoundService.playCountdownBeep();
    _startTimer();
  }

  void _onTimerCompleted() {
    _timer?.cancel();
    _tenthsTimer?.cancel();
    if (widget.type == SessionType.meditation) {
      _breatheController.stop();
      SoundService.stopAmbient();
    }

    setState(() {
      _isRunning = false;
      _isPaused = false;
      _isCompleted = true;
      _remainingSeconds = 0;
      _tenths = 0;
    });

    // Play completion alarm / bell chime
    if (widget.type == SessionType.meditation) {
      SoundService.playMeditationBell();
    } else {
      SoundService.playWorkoutAlarm();
    }

    // Automatically commit to app state
    final appState = context.read<AppStateProvider>();
    if (widget.type == SessionType.walking) {
      appState.addSteps(_sessionSteps);
    } else {
      appState.addMindfulSession(_selectedMinutes);
    }

    _showCelebrationDialog();
  }

  void _stopSessionManually() {
    _pauseTimer();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE11D48).withValues(alpha: 0.12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.stop_circle_rounded,
                  color: Color(0xFFE11D48),
                  size: 32,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.type == SessionType.walking
                    ? 'End Walking Workout?'
                    : 'End Meditation Sanctuary?',
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.type == SessionType.walking
                    ? 'You walked ${_sessionDistance.toStringAsFixed(2)} km with $_sessionSteps steps and burned $_sessionCalories active kcal. Save your workout?'
                    : 'You spent ${_elapsedSeconds ~/ 60}m ${_elapsedSeconds % 60}s in peaceful reflection. Save your mindful minutes?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _resumeTimer();
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text('Resume Timer'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: isDark
                              ? AppColors.accentMintGradient
                              : AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: (isDark
                                      ? AppColors.darkMint
                                      : AppColors.primaryGreen)
                                  .withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              Navigator.pop(ctx);
                              _saveAndExit();
                            },
                            child: Center(
                              child: Text(
                                'Save & Finish',
                                style: GoogleFonts.orbitron(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveAndExit() {
    SoundService.stopAmbient();
    final appState = context.read<AppStateProvider>();
    if (widget.type == SessionType.walking) {
      if (_sessionSteps > 0) {
        appState.addSteps(_sessionSteps);
      }
    } else {
      final mins = math.max(1, (_elapsedSeconds / 60).round());
      appState.addMindfulSession(mins);
    }
    Navigator.pop(context);
  }

  void _showCelebrationDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        title: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isDark
                  ? AppColors.darkHeroGradient
                  : AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF385C).withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              widget.type == SessionType.walking ? '🏆' : '🌸',
              style: const TextStyle(fontSize: 38),
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.type == SessionType.walking
                  ? 'Workout Goal Complete! 👟'
                  : 'Mindful Sanctuary Complete 🧘',
              textAlign: TextAlign.center,
              style: GoogleFonts.orbitron(
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.type == SessionType.walking
                  ? 'Incredible endurance! You finished your $_selectedMinutes-min walk with $_sessionSteps steps and burned $_sessionCalories active kcal.'
                  : 'You have given yourself $_selectedMinutes peaceful minutes. Your mind is rested and vitality replenished.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardElevated : AppColors.warmCream,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryPill('Time', '$_selectedMinutes min', isDark),
                  if (widget.type == SessionType.walking) ...[
                    _buildSummaryPill('Distance', '${_sessionDistance}km', isDark),
                    _buildSummaryPill('Steps', '+$_sessionSteps', isDark),
                    _buildSummaryPill('Calories', '+$_sessionCalories kcal', isDark),
                  ] else ...[
                    _buildSummaryPill('Heart', 'Restful 68', isDark),
                    _buildSummaryPill('Status', 'Recharged ✨', isDark),
                  ],
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppColors.accentMintGradient
                    : AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF385C).withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      'Save to Activity Rings ✓',
                      style: GoogleFonts.orbitron(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPill(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
          ),
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _changeDuration(int minutes) {
    if (_isRunning) return;
    setState(() {
      _selectedMinutes = minutes;
      _totalSeconds = minutes * 60;
      _remainingSeconds = _totalSeconds;
      _elapsedSeconds = 0;
      _tenths = 0;
      _sessionSteps = 0;
      _sessionCalories = 0;
      _sessionDistance = 0.0;
    });
    _startTimer();
  }

  void _setAmbientSound(String type) {
    setState(() {
      _activeAmbient = type;
    });
    if (type == 'silent') {
      SoundService.stopAmbient();
    } else {
      SoundService.startAmbient(type);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tenthsTimer?.cancel();
    _breatheController.dispose();
    _heartPulseController.dispose();
    _radarController.dispose();
    SoundService.stopAmbient();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress =
        _totalSeconds > 0 ? (1.0 - (_remainingSeconds / _totalSeconds)) : 0.0;
    final isWalking = widget.type == SessionType.walking;
    final durationOptions = isWalking ? [5, 10, 15, 20, 30] : [2, 5, 7, 10, 15];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF070B14) : const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Sound Alarm Status',
            icon: const Icon(
              Icons.notifications_active_rounded,
              color: Color(0xFF00F0FF),
              size: 20,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isWalking
                        ? '🔔 Fanfare alarm will sound automatically when walk reaches 00:00.'
                        : '🔔 Sacred singing bowl will sound automatically when meditation completes.',
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                children: [
                  // 1. Digital Mode Switcher Bar (Digital Watch, GPS Trail, Pro Cockpit)
                  if (isWalking) ...[
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF1E293B)),
                      ),
                      child: Row(
                        children: [
                          _buildModeTab('⌚ DIGITAL WATCH',
                              DigitalDisplayMode.digitalWatch, isDark),
                          _buildModeTab('🗺️ GPS TRAIL',
                              DigitalDisplayMode.gpsTrail, isDark),
                          _buildModeTab('📊 COCKPIT',
                              DigitalDisplayMode.proCockpit, isDark),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  // 2. Quick Target Duration Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: durationOptions.map((min) {
                        final isSelected = _selectedMinutes == min;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => _changeDuration(min),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [Color(0xFFFF385C), Color(0xFFFF6B00)],
                                      )
                                    : null,
                                color: isSelected
                                    ? null
                                    : const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : const Color(0xFF1E293B),
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFFF385C)
                                              .withValues(alpha: 0.35),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Text(
                                '$min MIN',
                                style: GoogleFonts.orbitron(
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.w900
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 3. Realistic Visual Stage (Digital Smartwatch OR GPS OR Cockpit OR Meditation Zen Watch)
                  Expanded(
                    child: isWalking
                        ? (_displayMode == DigitalDisplayMode.digitalWatch
                            ? _buildDigitalWatchStage(progress, isDark)
                            : (_displayMode == DigitalDisplayMode.gpsTrail
                                ? _buildGpsTrailMapStage(progress, isDark)
                                : _buildProCockpitStage(progress, isDark)))
                        : _buildDigitalZenMeditationStage(isDark),
                  ),

                  const SizedBox(height: 10),

                  // 4. Ambient Sound Palette for Meditation
                  if (!isWalking) ...[
                    _buildAmbientSoundSelector(isDark),
                    const SizedBox(height: 10),
                  ],

                  // 5. Digital Controls (Stop Session + Pause/Resume)
                  Row(
                    children: [
                      // Dedicated Stop Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _stopSessionManually,
                          icon: const Icon(Icons.stop_circle_rounded, size: 20),
                          label: Text(
                            'STOP SESSION',
                            style: GoogleFonts.orbitron(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE11D48),
                            side: const BorderSide(
                                color: Color(0xFFE11D48), width: 1.8),
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Pause / Resume Button
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF385C), Color(0xFFFF6B00)],
                              ),
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF385C)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(26),
                                onTap: () {
                                  if (_isRunning) {
                                    _pauseTimer();
                                  } else {
                                    _resumeTimer();
                                  }
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _isRunning
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _isRunning ? 'PAUSE' : 'RESUME',
                                        style: GoogleFonts.orbitron(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.8,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeTab(
      String label, DigitalDisplayMode mode, bool isDark) {
    final isSelected = _displayMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _displayMode = mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1E293B)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: isSelected
                ? Border.all(color: const Color(0xFF00F0FF).withValues(alpha: 0.6))
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.orbitron(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              color: isSelected ? const Color(0xFF00F0FF) : const Color(0xFF94A3B8),
            ),
          ),
        ),
      ),
    );
  }

  // ⌚ 1. ULTIMATE DIGITAL SMARTWATCH FACE STAGE (Apple Watch Ultra / Garmin Style)
  Widget _buildDigitalWatchStage(double progress, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF030712), // Deep OLED
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFF1E293B),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F0FF).withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Smartwatch Bezel Complication Top Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'ULTRA SPORT • GPS ±1m',
                    style: GoogleFonts.orbitron(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              Text(
                '98% 🔋 • $_cadenceSpm SPM',
                style: GoogleFonts.shareTechMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),

          // Central Glowing Digital 7-Segment Stopwatch
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer Circular Digital Notches
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 9,
                  backgroundColor: const Color(0xFF1E293B),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFF385C),
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Inner Display Core
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF385C).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFFF385C).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      _isCompleted
                          ? 'SESSION COMPLETED 🎉'
                          : (_isPaused ? 'TIMER PAUSED ⏸️' : 'LIVE COUNTDOWN ⏱️'),
                      style: GoogleFonts.orbitron(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: const Color(0xFFFF385C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Giant Digital Numbers
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _formatDuration(_remainingSeconds),
                        style: GoogleFonts.orbitron(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: const Color(0xFFFF385C).withValues(alpha: 0.8),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '.$_tenths',
                        style: GoogleFonts.orbitron(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFF385C),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'REMAINING DURATION',
                    style: GoogleFonts.shareTechMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Digital Rolling Step Odometer Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0B132B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('👟 ', style: TextStyle(fontSize: 16)),
                    Text(
                      'STEP ODOMETER:',
                      style: GoogleFonts.orbitron(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                _buildDigitalOdometerTiles(_sessionSteps),
              ],
            ),
          ),

          // Live ECG Waveform Bar with Heart BPM
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFF385C).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                ScaleTransition(
                  scale: _heartPulseAnimation,
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFFFF385C),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomPaint(
                    painter: EcgWavePainter(
                      progress: _tenths / 10.0,
                      color: const Color(0xFFFF385C),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$_currentBpm BPM',
                  style: GoogleFonts.orbitron(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFF385C),
                  ),
                ),
              ],
            ),
          ),

          // 3 Digital Complications (Burn, Distance, Speed)
          Row(
            children: [
              Expanded(
                child: _buildDigitalMiniTile(
                  label: 'ACTIVE BURN',
                  value: '$_sessionCalories KCAL',
                  icon: '🔥',
                  color: const Color(0xFFFF9500),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDigitalMiniTile(
                  label: 'DISTANCE',
                  value: '${_sessionDistance.toStringAsFixed(2)} KM',
                  icon: '📍',
                  color: const Color(0xFF00F0FF),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDigitalMiniTile(
                  label: 'SPEED',
                  value: '5.4 KM/H',
                  icon: '⚡',
                  color: const Color(0xFFA855F7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDigitalOdometerTiles(int value) {
    final str = value.toString().padLeft(5, '0');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: str.split('').map((char) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF030712),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Text(
            char,
            style: GoogleFonts.orbitron(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF10B981),
              shadows: [
                Shadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.8),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDigitalMiniTile({
    required String label,
    required String value,
    required String icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.orbitron(
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.shareTechMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🗺️ 2. SIMULATED GPS TRAIL STAGE
  Widget _buildGpsTrailMapStage(double progress, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1821),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF1E293B),
          width: 1.5,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: AnimatedBuilder(
                animation: _radarController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: GpsTrailPainter(
                      progress: progress.clamp(0.0, 1.0),
                      radarValue: _radarController.value,
                      isDark: true,
                      steps: _sessionSteps,
                    ),
                  );
                },
              ),
            ),
          ),
          // Top HUD
          Positioned(
            top: 14,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'GPS LOCK • ±1m',
                        style: GoogleFonts.orbitron(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    'Elevation: +14m ⛰️',
                    style: GoogleFonts.shareTechMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom HUD Glass
          Positioned(
            bottom: 14,
            left: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF030712).withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            _formatDuration(_remainingSeconds),
                            style: GoogleFonts.orbitron(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '.$_tenths',
                            style: GoogleFonts.orbitron(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFFF385C),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$_currentBpm BPM ❤️',
                        style: GoogleFonts.orbitron(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFF385C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniTextMetric('DIST', '${_sessionDistance}km'),
                      _buildMiniTextMetric('STEPS', '$_sessionSteps'),
                      _buildMiniTextMetric('BURN', '$_sessionCalories kcal'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 📊 3. SPORTS COCKPIT STAGE
  Widget _buildProCockpitStage(double progress, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1D),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PRO COCKPIT HUD',
                style: GoogleFonts.orbitron(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF00F0FF),
                ),
              ),
              Text(
                'LIVE ACCELERATION',
                style: GoogleFonts.shareTechMono(
                  fontSize: 11,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatDuration(_remainingSeconds),
                style: GoogleFonts.orbitron(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
              Text(
                '.$_tenths',
                style: GoogleFonts.orbitron(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFFF385C),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildDigitalMiniTile(
                  label: 'STEPS',
                  value: '$_sessionSteps',
                  icon: '👟',
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDigitalMiniTile(
                  label: 'DISTANCE',
                  value: '${_sessionDistance}km',
                  icon: '📍',
                  color: const Color(0xFF00F0FF),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildDigitalMiniTile(
                  label: 'CALORIES',
                  value: '$_sessionCalories kcal',
                  icon: '🔥',
                  color: const Color(0xFFFF9500),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDigitalMiniTile(
                  label: 'PACE',
                  value: '5\'24" /km',
                  icon: '⚡',
                  color: const Color(0xFFA855F7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🧘 4. DIGITAL ZEN MEDITATION WATCH STAGE
  Widget _buildDigitalZenMeditationStage(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF050B14),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFF00F0FF).withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F0FF).withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Digital Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DIGITAL ZEN COMPASS',
                style: GoogleFonts.orbitron(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: const Color(0xFF00F0FF),
                ),
              ),
              Text(
                '528 Hz SOLFEGGIO 🔔',
                style: GoogleFonts.shareTechMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),

          // Sacred Lotus with Glowing Digital Numbers
          AnimatedBuilder(
            animation: _breatheAnimation,
            builder: (context, _) {
              return CustomPaint(
                size: const Size(200, 200),
                painter: SacredLotusPainter(
                  scale: _breatheAnimation.value,
                  isDark: true,
                  phaseProgress: _phaseSecondsLeft / 4.0,
                ),
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatDuration(_remainingSeconds),
                          style: GoogleFonts.orbitron(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: const Color(0xFF00F0FF).withValues(alpha: 0.8),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00F0FF).withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF00F0FF).withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            '$_breathePhase ($_phaseSecondsLeft s)',
                            style: GoogleFonts.orbitron(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF00F0FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Breathing Subtitle Guide
          Text(
            _breatheSub,
            textAlign: TextAlign.center,
            style: GoogleFonts.shareTechMono(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF94A3B8),
            ),
          ),

          // Real-time Graphic Audio Equalizer bars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(14, (idx) {
              final barHeight = 8.0 + ((_tenths * (idx + 2)) % 22);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                width: 3.5,
                height: barHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFF00F0FF),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00F0FF).withValues(alpha: 0.7),
                      blurRadius: 4,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientSoundSelector(bool isDark) {
    final sounds = [
      {'id': 'drone', 'icon': '🧘', 'label': 'Singing Bowl'},
      {'id': 'rain', 'icon': '🌧️', 'label': 'Rain'},
      {'id': 'ocean', 'icon': '🌊', 'label': 'Waves'},
      {'id': 'silent', 'icon': '🔇', 'label': 'Silent'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1D),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: sounds.map((s) {
          final isSelected = _activeAmbient == s['id'];
          return GestureDetector(
            onTap: () => _setAmbientSound(s['id']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF00F0FF).withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF00F0FF)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Text(s['icon']!, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 4),
                  Text(
                    s['label']!,
                    style: GoogleFonts.orbitron(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? const Color(0xFF00F0FF) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMiniTextMetric(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.shareTechMono(
            fontSize: 10,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

// 🗺️ Custom GPS Trail Painter
class GpsTrailPainter extends CustomPainter {
  final double progress;
  final double radarValue;
  final bool isDark;
  final int steps;

  GpsTrailPainter({
    required this.progress,
    required this.radarValue,
    required this.isDark,
    required this.steps,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1.0;

    const spacing = 28.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final riverPaint = Paint()
      ..color = const Color(0xFF1E3A5F).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 32.0
      ..strokeCap = StrokeCap.round;

    final riverPath = Path();
    riverPath.moveTo(0, size.height * 0.75);
    riverPath.quadraticBezierTo(
        size.width * 0.4, size.height * 0.9, size.width, size.height * 0.6);
    canvas.drawPath(riverPath, riverPaint);

    final trailPath = Path();
    trailPath.moveTo(size.width * 0.15, size.height * 0.70);
    trailPath.cubicTo(
      size.width * 0.10,
      size.height * 0.25,
      size.width * 0.45,
      size.height * 0.15,
      size.width * 0.65,
      size.height * 0.35,
    );
    trailPath.cubicTo(
      size.width * 0.85,
      size.height * 0.55,
      size.width * 0.80,
      size.height * 0.80,
      size.width * 0.45,
      size.height * 0.75,
    );

    final bgPathPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(trailPath, bgPathPaint);

    final metrics = trailPath.computeMetrics().toList();
    if (metrics.isNotEmpty) {
      final metric = metrics.first;
      final currentDist = metric.length * progress.clamp(0.01, 1.0);
      final activePath = metric.extractPath(0.0, currentDist);

      final activeTrailPaint = Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFF385C), Color(0xFFFF9500), Color(0xFF10B981)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7.0
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(activePath, activeTrailPaint);

      final startPos = metric.getTangentForOffset(0.0)?.position ?? Offset.zero;
      canvas.drawCircle(
          startPos, 6, Paint()..color = const Color(0xFF10B981));
      canvas.drawCircle(startPos, 3, Paint()..color = Colors.white);

      final currentPos =
          metric.getTangentForOffset(currentDist)?.position ?? startPos;

      final radarRadius = 10.0 + (radarValue * 18.0);
      final radarAlpha = (1.0 - radarValue).clamp(0.0, 1.0) * 0.5;
      final radarPaint = Paint()
        ..color = const Color(0xFFFF385C).withValues(alpha: radarAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawCircle(currentPos, radarRadius, radarPaint);

      final cursorPaint = Paint()..color = const Color(0xFFFF385C);
      canvas.drawCircle(currentPos, 8.0, cursorPaint);
      canvas.drawCircle(currentPos, 4.0, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant GpsTrailPainter oldDelegate) => true;
}

// 🫀 Custom ECG Pulse Line Painter
class EcgWavePainter extends CustomPainter {
  final double progress;
  final Color color;

  EcgWavePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final h = size.height;
    final w = size.width;

    path.moveTo(0, h * 0.5);
    path.lineTo(w * 0.25, h * 0.5);
    path.lineTo(w * 0.32, h * 0.2);
    path.lineTo(w * 0.40, h * 0.85);
    path.lineTo(w * 0.48, h * 0.1);
    path.lineTo(w * 0.56, h * 0.65);
    path.lineTo(w * 0.62, h * 0.5);
    path.lineTo(w, h * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant EcgWavePainter oldDelegate) => true;
}

// 🧘 Sacred Geometry Breathing Lotus Mandala Painter
class SacredLotusPainter extends CustomPainter {
  final double scale;
  final bool isDark;
  final double phaseProgress;

  SacredLotusPainter({
    required this.scale,
    required this.isDark,
    required this.phaseProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * scale * 0.72;

    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00F0FF).withValues(alpha: 0.3),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.4));
    canvas.drawCircle(center, radius * 1.4, auraPaint);

    const numPetals = 8;
    for (int i = 0; i < numPetals; i++) {
      final angle = (i * 2 * math.pi) / numPetals;
      final petalCenter = Offset(
        center.dx + (radius * 0.42 * math.cos(angle)),
        center.dy + (radius * 0.42 * math.sin(angle)),
      );

      final petalPaint = Paint()
        ..color = const Color(0xFF00F0FF).withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(petalCenter, radius * 0.46, petalPaint);
    }

    final ringPaint = Paint()
      ..color = const Color(0xFF00F0FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (phaseProgress.clamp(0.0, 1.0)) * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.82),
      -math.pi / 2,
      sweepAngle,
      false,
      ringPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SacredLotusPainter oldDelegate) => true;
}
