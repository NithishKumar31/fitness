import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/sound_service.dart';

enum StopwatchTab { chronometer, intervalTimer }

enum IntervalState { prepare, work, rest, complete }

class LapRecord {
  final int index;
  final int lapTimeMs;
  final int totalTimeMs;

  const LapRecord({
    required this.index,
    required this.lapTimeMs,
    required this.totalTimeMs,
  });
}

class DigitalStopwatchScreen extends StatefulWidget {
  final StopwatchTab initialTab;

  const DigitalStopwatchScreen({
    super.key,
    this.initialTab = StopwatchTab.chronometer,
  });

  @override
  State<DigitalStopwatchScreen> createState() => _DigitalStopwatchScreenState();
}

class _DigitalStopwatchScreenState extends State<DigitalStopwatchScreen>
    with SingleTickerProviderStateMixin {
  late StopwatchTab _activeTab;

  // --- Chronometer (Stopwatch) State ---
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _stopwatchTimer;
  int _lastLapTotalMs = 0;
  final List<LapRecord> _laps = [];

  // --- HIIT Interval Timer State ---
  int _workSeconds = 30;
  int _restSeconds = 15;
  int _totalSets = 8;
  int _currentSet = 1;
  int _remainingSeconds = 30;
  IntervalState _intervalState = IntervalState.prepare;
  bool _intervalRunning = false;
  Timer? _intervalTimer;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
  }

  @override
  void dispose() {
    _stopwatchTimer?.cancel();
    _stopwatch.stop();
    _intervalTimer?.cancel();
    super.dispose();
  }

  // ==========================================
  // Chronometer Methods
  // ==========================================
  void _toggleStopwatch() {
    SoundService.playCountdownBeep();
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _stopwatchTimer?.cancel();
    } else {
      _stopwatch.start();
      _stopwatchTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
        if (mounted) setState(() {});
      });
    }
    setState(() {});
  }

  void _recordLap() {
    if (!_stopwatch.isRunning) return;
    SoundService.playCountdownBeep();
    final total = _stopwatch.elapsedMilliseconds;
    final lapTime = total - _lastLapTotalMs;
    _lastLapTotalMs = total;

    setState(() {
      _laps.insert(
        0,
        LapRecord(
          index: _laps.length + 1,
          lapTimeMs: lapTime,
          totalTimeMs: total,
        ),
      );
    });
  }

  void _resetStopwatch() {
    SoundService.playCountdownBeep();
    _stopwatch.reset();
    _stopwatch.stop();
    _stopwatchTimer?.cancel();
    _lastLapTotalMs = 0;
    setState(() {
      _laps.clear();
    });
  }

  String _formatElapsed(int ms) {
    final hundreds = (ms ~/ 10) % 100;
    final seconds = (ms ~/ 1000) % 60;
    final minutes = (ms ~/ (1000 * 60)) % 60;
    final hours = ms ~/ (1000 * 60 * 60);

    final hStr = hours > 0 ? '${hours.toString().padLeft(2, '0')}:' : '';
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');
    final cStr = hundreds.toString().padLeft(2, '0');

    return '$hStr$mStr:$sStr.$cStr';
  }

  // ==========================================
  // HIIT Interval Timer Methods
  // ==========================================
  void _startIntervalTimer() {
    if (_intervalRunning) return;
    SoundService.playCountdownBeep();

    setState(() {
      _intervalRunning = true;
      if (_intervalState == IntervalState.complete || _intervalState == IntervalState.prepare) {
        _intervalState = IntervalState.work;
        _remainingSeconds = _workSeconds;
        _currentSet = 1;
      }
    });

    _intervalTimer?.cancel();
    _intervalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_remainingSeconds <= 4 && _remainingSeconds > 1) {
        SoundService.playCountdownBeep();
      }

      if (_remainingSeconds > 1) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        // Transition to next interval
        SoundService.playWorkoutAlarm();
        if (_intervalState == IntervalState.work) {
          if (_currentSet >= _totalSets) {
            // Done!
            _intervalTimer?.cancel();
            setState(() {
              _intervalState = IntervalState.complete;
              _intervalRunning = false;
              _remainingSeconds = 0;
            });
          } else {
            // Switch to Rest
            setState(() {
              _intervalState = IntervalState.rest;
              _remainingSeconds = _restSeconds;
            });
          }
        } else if (_intervalState == IntervalState.rest) {
          // Switch to Work (next set)
          setState(() {
            _currentSet++;
            _intervalState = IntervalState.work;
            _remainingSeconds = _workSeconds;
          });
        }
      }
    });
  }

  void _pauseIntervalTimer() {
    SoundService.playCountdownBeep();
    _intervalTimer?.cancel();
    setState(() {
      _intervalRunning = false;
    });
  }

  void _resetIntervalTimer() {
    SoundService.playCountdownBeep();
    _intervalTimer?.cancel();
    setState(() {
      _intervalRunning = false;
      _intervalState = IntervalState.prepare;
      _currentSet = 1;
      _remainingSeconds = _workSeconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: const Color(0xFF030712), // Deep Cyber OLED Black
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F1D),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'DIGITAL CHRONO & HIIT',
          style: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: const Color(0xFF00F0FF),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF00F0FF).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00F0FF).withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⚡ ', style: TextStyle(fontSize: 11)),
                Text(
                  'PRO HUD',
                  style: GoogleFonts.orbitron(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF00F0FF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Column(
              children: [
                const SizedBox(height: 12),

                // Top Mode Toggle Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _activeTab = StopwatchTab.chronometer),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _activeTab == StopwatchTab.chronometer
                                    ? const Color(0xFF00F0FF)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: _activeTab == StopwatchTab.chronometer
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF00F0FF).withValues(alpha: 0.4),
                                          blurRadius: 10,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  '⏱️ STOPWATCH',
                                  style: GoogleFonts.orbitron(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w900,
                                    color: _activeTab == StopwatchTab.chronometer
                                        ? Colors.black
                                        : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _activeTab = StopwatchTab.intervalTimer),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _activeTab == StopwatchTab.intervalTimer
                                    ? const Color(0xFFFF9500)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: _activeTab == StopwatchTab.intervalTimer
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFFF9500).withValues(alpha: 0.4),
                                          blurRadius: 10,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  '🔥 HIIT INTERVAL',
                                  style: GoogleFonts.orbitron(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w900,
                                    color: _activeTab == StopwatchTab.intervalTimer
                                        ? Colors.black
                                        : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Main Display Content
                Expanded(
                  child: _activeTab == StopwatchTab.chronometer
                      ? _buildStopwatchView(isDark)
                      : _buildIntervalTimerView(isDark),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Chronometer (Stopwatch) View
  // ==========================================
  Widget _buildStopwatchView(bool isDark) {
    final elapsedMs = _stopwatch.elapsedMilliseconds;
    final isRunning = _stopwatch.isRunning;

    // Determine Best and Slowest lap
    int minLapMs = 999999999;
    int maxLapMs = -1;
    if (_laps.length > 1) {
      for (final lap in _laps) {
        if (lap.lapTimeMs < minLapMs) minLapMs = lap.lapTimeMs;
        if (lap.lapTimeMs > maxLapMs) maxLapMs = lap.lapTimeMs;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Giant OLED Digital LED Time Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0F1D),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isRunning
                    ? const Color(0xFF00F0FF).withValues(alpha: 0.6)
                    : const Color(0xFF1E293B),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isRunning
                      ? const Color(0xFF00F0FF).withValues(alpha: 0.25)
                      : Colors.transparent,
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PRECISION CHRONO 1/100s',
                      style: GoogleFonts.orbitron(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                        letterSpacing: 1.0,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isRunning ? const Color(0xFF00FF66) : const Color(0xFF64748B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isRunning ? 'ACTIVE' : 'IDLE',
                          style: GoogleFonts.orbitron(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: isRunning ? const Color(0xFF00FF66) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Digital Numbers Display
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _formatElapsed(elapsedMs),
                    style: GoogleFonts.orbitron(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: const Color(0xFF00F0FF).withValues(alpha: isRunning ? 0.8 : 0.2),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Control Buttons Row
          Row(
            children: [
              // Lap / Reset Button
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: OutlinedButton(
                    onPressed: isRunning
                        ? _recordLap
                        : (elapsedMs > 0 ? _resetStopwatch : null),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: (isRunning || elapsedMs > 0)
                            ? const Color(0xFF334155)
                            : const Color(0xFF1E293B),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      backgroundColor: const Color(0xFF0F172A),
                    ),
                    child: Text(
                      isRunning ? 'LAP 🏁' : 'RESET ↺',
                      style: GoogleFonts.orbitron(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: (isRunning || elapsedMs > 0)
                            ? Colors.white
                            : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Start / Stop Main Toggle Button
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _toggleStopwatch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRunning ? const Color(0xFFFF385C) : const Color(0xFF00FF66),
                      foregroundColor: isRunning ? Colors.white : Colors.black,
                      elevation: 8,
                      shadowColor: (isRunning
                              ? const Color(0xFFFF385C)
                              : const Color(0xFF00FF66))
                          .withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 24,
                          color: isRunning ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isRunning ? 'STOP' : 'START',
                          style: GoogleFonts.orbitron(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                            color: isRunning ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Laps Header & List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECORDED LAPS (${_laps.length})',
                style: GoogleFonts.orbitron(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: const Color(0xFF64748B),
                ),
              ),
              if (_laps.isNotEmpty)
                Text(
                  'SPLIT DELTA',
                  style: GoogleFonts.orbitron(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          Expanded(
            child: _laps.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('⏱️', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        Text(
                          'No laps recorded yet',
                          style: GoogleFonts.orbitron(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Press Start then Lap to track splits',
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _laps.length,
                    itemBuilder: (context, index) {
                      final lap = _laps[index];
                      final isBest = _laps.length > 1 && lap.lapTimeMs == minLapMs;
                      final isSlowest = _laps.length > 1 && lap.lapTimeMs == maxLapMs;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0F1D),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isBest
                                ? const Color(0xFF00FF66).withValues(alpha: 0.5)
                                : (isSlowest
                                    ? const Color(0xFFFF385C).withValues(alpha: 0.5)
                                    : const Color(0xFF1E293B)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isBest
                                    ? const Color(0xFF00FF66).withValues(alpha: 0.15)
                                    : const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'LAP ${lap.index.toString().padLeft(2, '0')}',
                                style: GoogleFonts.orbitron(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: isBest
                                      ? const Color(0xFF00FF66)
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                            if (isBest) ...[
                              const SizedBox(width: 6),
                              const Text('🥇', style: TextStyle(fontSize: 12)),
                            ],
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _formatElapsed(lap.lapTimeMs),
                                  style: GoogleFonts.shareTechMono(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: isBest
                                        ? const Color(0xFF00FF66)
                                        : (isSlowest ? const Color(0xFFFF385C) : Colors.white),
                                  ),
                                ),
                                Text(
                                  'TOT: ${_formatElapsed(lap.totalTimeMs)}',
                                  style: GoogleFonts.shareTechMono(
                                    fontSize: 10,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // HIIT Interval Timer View
  // ==========================================
  Widget _buildIntervalTimerView(bool isDark) {
    Color stateColor;
    String stateLabel;
    String stateSub;

    switch (_intervalState) {
      case IntervalState.work:
        stateColor = const Color(0xFF00FF66); // Neon Green Work
        stateLabel = 'WORK 🔥';
        stateSub = 'PUMP IT UP • MAXIMUM EFFORT';
        break;
      case IntervalState.rest:
        stateColor = const Color(0xFFFF9500); // Warm Orange Rest
        stateLabel = 'REST ❄️';
        stateSub = 'SLOW BREATH • RECOVER';
        break;
      case IntervalState.complete:
        stateColor = const Color(0xFF00F0FF); // Cyan Complete
        stateLabel = 'COMPLETED 🏆';
        stateSub = 'ALL ROUNDS FINISHED';
        break;
      case IntervalState.prepare:
        stateColor = const Color(0xFF94A3B8);
        stateLabel = 'READY TO SWEAT ⚡';
        stateSub = 'TAP START TO BEGIN INTERVALS';
        break;
    }

    final totalIntervalSec = _intervalState == IntervalState.rest ? _restSeconds : _workSeconds;
    final progress = totalIntervalSec > 0
        ? (_remainingSeconds / totalIntervalSec).clamp(0.0, 1.0)
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Giant Status HUD Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0F1D),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: stateColor.withValues(alpha: 0.6), width: 2),
              boxShadow: [
                BoxShadow(
                  color: stateColor.withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Set Counter Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: stateColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: stateColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    'ROUND $_currentSet OF $_totalSets',
                    style: GoogleFonts.orbitron(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: stateColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // State Title
                Text(
                  stateLabel,
                  style: GoogleFonts.orbitron(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    color: stateColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stateSub,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF94A3B8),
                  ),
                ),

                const SizedBox(height: 20),

                // Remaining Seconds Giant Number
                Text(
                  '${_remainingSeconds}s',
                  style: GoogleFonts.orbitron(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: stateColor.withValues(alpha: 0.8),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFF1E293B),
                    valueColor: AlwaysStoppedAnimation<Color>(stateColor),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: _resetIntervalTimer,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF334155)),
                      backgroundColor: const Color(0xFF0F172A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      'RESET ↺',
                      style: GoogleFonts.orbitron(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _intervalRunning ? _pauseIntervalTimer : _startIntervalTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _intervalRunning ? const Color(0xFFFF385C) : stateColor,
                      foregroundColor: _intervalRunning ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      shadowColor: (_intervalRunning ? const Color(0xFFFF385C) : stateColor)
                          .withValues(alpha: 0.5),
                      elevation: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _intervalRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 24,
                          color: _intervalRunning ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _intervalRunning ? 'PAUSE' : 'START HIIT',
                          style: GoogleFonts.orbitron(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: _intervalRunning ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Interval Configurator
          if (!_intervalRunning) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0F1D),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INTERVAL SETTINGS',
                    style: GoogleFonts.orbitron(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: const Color(0xFFFF9500),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Work Duration Setting
                  _buildConfigRow(
                    label: 'WORK DURATION',
                    value: '$_workSeconds sec',
                    color: const Color(0xFF00FF66),
                    onMinus: _workSeconds > 10
                        ? () => setState(() {
                              _workSeconds -= 5;
                              if (_intervalState == IntervalState.prepare) {
                                _remainingSeconds = _workSeconds;
                              }
                            })
                        : null,
                    onPlus: _workSeconds < 120
                        ? () => setState(() {
                              _workSeconds += 5;
                              if (_intervalState == IntervalState.prepare) {
                                _remainingSeconds = _workSeconds;
                              }
                            })
                        : null,
                  ),

                  const Divider(color: Color(0xFF1E293B), height: 24),

                  // Rest Duration Setting
                  _buildConfigRow(
                    label: 'REST DURATION',
                    value: '$_restSeconds sec',
                    color: const Color(0xFFFF9500),
                    onMinus: _restSeconds > 5
                        ? () => setState(() => _restSeconds -= 5)
                        : null,
                    onPlus: _restSeconds < 60
                        ? () => setState(() => _restSeconds += 5)
                        : null,
                  ),

                  const Divider(color: Color(0xFF1E293B), height: 24),

                  // Total Sets Setting
                  _buildConfigRow(
                    label: 'TOTAL ROUNDS',
                    value: '$_totalSets Sets',
                    color: const Color(0xFF00F0FF),
                    onMinus: _totalSets > 2
                        ? () => setState(() => _totalSets--)
                        : null,
                    onPlus: _totalSets < 20
                        ? () => setState(() => _totalSets++)
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildConfigRow({
    required String label,
    required String value,
    required Color color,
    required VoidCallback? onMinus,
    required VoidCallback? onPlus,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.orbitron(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.orbitron(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ],
        ),
        Row(
          children: [
            InkWell(
              onTap: onMinus,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.remove, color: Colors.white, size: 16),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: onPlus,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
