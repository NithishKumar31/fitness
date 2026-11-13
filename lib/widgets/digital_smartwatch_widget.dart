import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/digital_stopwatch_screen.dart';
import '../theme/app_colors.dart';

class DigitalSmartwatchWidget extends StatefulWidget {
  final int steps;
  final int stepGoal;
  final int calories;
  final double distanceKm;
  final VoidCallback? onStartWorkout;
  final bool compact;

  const DigitalSmartwatchWidget({
    super.key,
    required this.steps,
    required this.stepGoal,
    required this.calories,
    required this.distanceKm,
    this.onStartWorkout,
    this.compact = false,
  });

  @override
  State<DigitalSmartwatchWidget> createState() =>
      _DigitalSmartwatchWidgetState();
}

class _DigitalSmartwatchWidgetState extends State<DigitalSmartwatchWidget> {
  late Timer _clockTimer;
  DateTime _currentTime = DateTime.now();
  bool _colonVisible = true;

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
          _colonVisible = !_colonVisible;
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  String _formatDigit(int val) => val.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hour = _formatDigit(_currentTime.hour);
    final minute = _formatDigit(_currentTime.minute);
    final second = _formatDigit(_currentTime.second);

    final progress =
        widget.stepGoal > 0 ? (widget.steps / widget.stepGoal).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0F1D) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : AppColors.borderLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0xFF00F0FF).withValues(alpha: 0.12)
                : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          if (isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Digital Smartwatch Top Status Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF00F0FF) : AppColors.primaryGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isDark ? const Color(0xFF00F0FF) : AppColors.primaryGreen)
                              .withValues(alpha: 0.6),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'DIGITAL SMARTWATCH HUD',
                    style: GoogleFonts.orbitron(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: isDark ? const Color(0xFF00F0FF) : AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'GPS 🛰️ LOCK • 98% 🔋',
                    style: GoogleFonts.shareTechMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF94A3B8) : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 2. Giant Digital LED Clock Display with Glowing Segments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF030712) : const Color(0xFFFFF8F6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? const Color(0xFF1F2937) : AppColors.borderLight,
                width: 1.2,
              ),
              boxShadow: isDark
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF385C).withValues(alpha: 0.15),
                        blurRadius: 14,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: const Color(0xFFE11D48).withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Big Digital Clock
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    _buildLedDigit(
                      hour,
                      isDark ? const Color(0xFFFFFFFF) : AppColors.textDark,
                      isDark,
                    ),
                    Text(
                      _colonVisible ? ':' : ' ',
                      style: GoogleFonts.orbitron(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: isDark ? const Color(0xFFFF385C) : AppColors.primaryGreen,
                      ),
                    ),
                    _buildLedDigit(
                      minute,
                      isDark ? const Color(0xFFFFFFFF) : AppColors.textDark,
                      isDark,
                    ),
                    Text(
                      _colonVisible ? ':' : ' ',
                      style: GoogleFonts.orbitron(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: isDark ? const Color(0xFFFF385C) : AppColors.primaryGreen,
                      ),
                    ),
                    Text(
                      second,
                      style: GoogleFonts.orbitron(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFFFF385C) : AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                // Live Heart Rate Complication
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFFFF385C).withValues(alpha: 0.15)
                        : const Color(0xFFFFEBE6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFFFF385C).withValues(alpha: 0.4)
                          : const Color(0xFFFFCDD2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.favorite_rounded,
                        color: Color(0xFFE11D48),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '114 BPM',
                        style: GoogleFonts.orbitron(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFE11D48),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 3. Digital Segmented Odometer for Steps
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF030712) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? const Color(0xFF1E293B) : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STEP ODOMETER',
                      style: GoogleFonts.orbitron(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
                      ),
                    ),
                    Text(
                      'TARGET: ${widget.stepGoal}',
                      style: GoogleFonts.shareTechMono(
                        fontSize: 11,
                        color: isDark ? const Color(0xFF64748B) : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('👟 ', style: TextStyle(fontSize: 18)),
                    _buildDigitalOdometer(widget.steps, isDark),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF10B981).withValues(alpha: 0.2)
                            : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(8),
                        border: isDark ? null : Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Text(
                        '${(progress * 100).toInt()}%',
                        style: GoogleFonts.orbitron(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Digital segmented progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 4. Digital Metrics Complications Strip (Calories, Distance, Pace)
          Row(
            children: [
              Expanded(
                child: _buildDigitalPill(
                  label: 'CALORIE BURN',
                  value: '${widget.calories} KCAL',
                  color: const Color(0xFFFF9500),
                  icon: '🔥',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDigitalPill(
                  label: 'DISTANCE',
                  value: '${widget.distanceKm.toStringAsFixed(2)} KM',
                  color: isDark ? const Color(0xFF00F0FF) : const Color(0xFF0284C7),
                  icon: '📍',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDigitalPill(
                  label: 'LIVE PACE',
                  value: '5\'24" /KM',
                  color: const Color(0xFFA855F7),
                  icon: '⚡',
                  isDark: isDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          // Dual Action Row: Stopwatch & Live Workout
          Row(
            children: [
              // Stopwatch & HIIT Launcher
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DigitalStopwatchScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF030712) : const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF00F0FF).withValues(alpha: 0.5)
                            : const Color(0xFF0284C7).withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isDark ? const Color(0xFF00F0FF) : const Color(0xFF0284C7))
                              .withValues(alpha: isDark ? 0.15 : 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            color: isDark ? const Color(0xFF00F0FF) : const Color(0xFF0284C7),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'STOPWATCH / HIIT',
                            style: GoogleFonts.orbitron(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: isDark ? const Color(0xFF00F0FF) : const Color(0xFF0284C7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.onStartWorkout != null) ...[
                const SizedBox(width: 10),
                // Live Workout Launcher
                Expanded(
                  child: InkWell(
                    onTap: widget.onStartWorkout,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE11D48), Color(0xFFFF6B00)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE11D48).withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('👟', style: TextStyle(fontSize: 13)),
                            const SizedBox(width: 6),
                            Text(
                              'LIVE WORKOUT',
                              style: GoogleFonts.orbitron(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLedDigit(String text, Color color, bool isDark) {
    return Text(
      text,
      style: GoogleFonts.orbitron(
        fontSize: 34,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: color,
        shadows: isDark
            ? [
                Shadow(
                  color: color.withValues(alpha: 0.6),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildDigitalOdometer(int value, bool isDark) {
    final str = value.toString().padLeft(5, '0');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: str.split('').map((char) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Text(
            char,
            style: GoogleFonts.orbitron(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
              shadows: isDark
                  ? [
                      Shadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.8),
                        blurRadius: 6,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDigitalPill({
    required String label,
    required String value,
    required Color color,
    required String icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF030712) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? color.withValues(alpha: 0.3) : const Color(0xFFE2E8F0),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
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
          const SizedBox(height: 4),
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.shareTechMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.textDark,
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
}
