import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';

class WeeklyTrendsWidget extends StatelessWidget {
  const WeeklyTrendsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final history = appState.activity.weeklyHistory;

    int totalWeeklySteps = 0;
    int maxSteps = 10000;
    for (final day in history) {
      totalWeeklySteps += day.steps;
      if (day.steps > maxSteps) maxSteps = day.steps;
    }
    final dailyAvg = history.isNotEmpty ? (totalWeeklySteps ~/ history.length) : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Streak Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WEEKLY ACTIVITY TRENDS',
                    style: GoogleFonts.orbitron(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: const Color(0xFFFF9500),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '7-Day Consistency',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF385C), Color(0xFFFF9500)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF385C).withValues(alpha: 0.35),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥 ', style: TextStyle(fontSize: 12)),
                    Text(
                      '5-DAY STREAK',
                      style: GoogleFonts.orbitron(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Total Weekly Stats Strip
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF030712) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL STEPS',
                        style: GoogleFonts.orbitron(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        totalWeeklySteps.toString(),
                        style: GoogleFonts.orbitron(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF030712) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DAILY AVERAGE',
                        style: GoogleFonts.orbitron(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$dailyAvg / day',
                        style: GoogleFonts.orbitron(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 7-Day Bar Chart
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: history.map((day) {
                final barRatio = maxSteps > 0 ? (day.steps / maxSteps).clamp(0.08, 1.0) : 0.1;
                final isToday = day.isToday;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Step count tooltip if today or high
                    Text(
                      day.steps >= 1000 ? '${(day.steps / 1000).toStringAsFixed(1)}k' : '${day.steps}',
                      style: GoogleFonts.shareTechMono(
                        fontSize: 9.5,
                        fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                        color: isToday
                            ? const Color(0xFFFF385C)
                            : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Bar
                    Container(
                      width: 26,
                      height: 80 * barRatio,
                      decoration: BoxDecoration(
                        gradient: isToday
                            ? const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFFFF385C), Color(0xFFFF9500)],
                              )
                            : LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isDark
                                    ? [const Color(0xFF334155), const Color(0xFF1E293B)]
                                    : [const Color(0xFFCBD5E1), const Color(0xFFE2E8F0)],
                              ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: isToday
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFFF385C).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Day label
                    Container(
                      padding: isToday ? const EdgeInsets.symmetric(horizontal: 5, vertical: 2) : EdgeInsets.zero,
                      decoration: isToday
                          ? BoxDecoration(
                              color: const Color(0xFFFF385C).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            )
                          : null,
                      child: Text(
                        day.dayLabel,
                        style: GoogleFonts.orbitron(
                          fontSize: 10,
                          fontWeight: isToday ? FontWeight.w900 : FontWeight.w600,
                          color: isToday
                              ? const Color(0xFFFF385C)
                              : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
