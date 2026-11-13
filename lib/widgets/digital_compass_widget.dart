import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class DigitalCompassWidget extends StatefulWidget {
  const DigitalCompassWidget({super.key});

  @override
  State<DigitalCompassWidget> createState() => _DigitalCompassWidgetState();
}

class _DigitalCompassWidgetState extends State<DigitalCompassWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _compassController;
  final double _heading = 42.0; // 042° NE

  @override
  void initState() {
    super.initState();
    _compassController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _compassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                ? const Color(0xFF14B8A6).withValues(alpha: 0.12)
                : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          if (isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF14B8A6).withValues(alpha: 0.2)
                          : const Color(0xFFCCFBF1),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🧭', style: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DIGITAL COMPASS & GPS HUD',
                        style: GoogleFonts.orbitron(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: isDark ? const Color(0xFF14B8A6) : const Color(0xFF0D9488),
                        ),
                      ),
                      Text(
                        'Altimeter & Environmental Barometer',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF94A3B8) : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF14B8A6).withValues(alpha: 0.15)
                      : const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF14B8A6).withValues(alpha: 0.4)
                        : const Color(0xFF99F6E4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🛰️ ', style: TextStyle(fontSize: 10)),
                    Text(
                      '12 SATS',
                      style: GoogleFonts.orbitron(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFF14B8A6) : const Color(0xFF0D9488),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Central Compass Dial & Heading Display
          Row(
            children: [
              // Rotating Compass Rose Dial
              AnimatedBuilder(
                animation: _compassController,
                builder: (context, child) {
                  final wobble = (_compassController.value - 0.5) * 6.0;
                  final curHeading = (_heading + wobble) % 360;

                  return Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? const Color(0xFF030712) : const Color(0xFFF8FAFC),
                      border: Border.all(
                        color: isDark ? const Color(0xFF14B8A6) : const Color(0xFF0D9488),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isDark ? const Color(0xFF14B8A6) : const Color(0xFF0D9488))
                              .withValues(alpha: isDark ? 0.25 : 0.12),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Compass Cardinal Ticks
                        Positioned(
                          top: 4,
                          child: Text(
                            'N',
                            style: GoogleFonts.orbitron(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFF385C),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          child: Text(
                            'S',
                            style: GoogleFonts.orbitron(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 6,
                          child: Text(
                            'E',
                            style: GoogleFonts.orbitron(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 6,
                          child: Text(
                            'W',
                            style: GoogleFonts.orbitron(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        // Rotating Needle
                        Transform.rotate(
                          angle: curHeading * (math.pi / 180),
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: CustomPaint(
                              painter: _CompassNeedlePainter(),
                            ),
                          ),
                        ),
                        // Center dot
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF00F0FF) : const Color(0xFF0D9488),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(width: 16),

              // Digital Telemetry Readings
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '042°',
                          style: GoogleFonts.orbitron(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : AppColors.textDark,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'NE (NORTHEAST)',
                          style: GoogleFonts.orbitron(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isDark ? const Color(0xFF14B8A6) : const Color(0xFF0D9488),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LAT: 13°04\'48" N  •  LON: 80°16\'12" E',
                      style: GoogleFonts.shareTechMono(
                        fontSize: 11,
                        color: isDark ? const Color(0xFF94A3B8) : AppColors.textMutedLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF030712) : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFA7F3D0),
                        ),
                      ),
                      child: Text(
                        'ELEVATION: +342 M • ±1.2M ACCURACY',
                        style: GoogleFonts.orbitron(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFF00FF66) : const Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Environmental Barometer Strip (Pressure, UV Index, Ambient Temp)
          Row(
            children: [
              Expanded(
                child: _buildEnvPill(
                  label: 'BAROMETER',
                  value: '1013.2 hPa',
                  icon: '🌪️',
                  color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildEnvPill(
                  label: 'AMBIENT TEMP',
                  value: '27.4°C',
                  icon: '🌡️',
                  color: const Color(0xFFFF9500),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildEnvPill(
                  label: 'UV INDEX',
                  value: '4 (MODERATE)',
                  icon: '☀️',
                  color: isDark ? const Color(0xFFFFD600) : const Color(0xFFD97706),
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnvPill({
    required String label,
    required String value,
    required String icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF030712) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.orbitron(
              fontSize: 7.5,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFF64748B) : AppColors.textMutedLight,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 10)),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.shareTechMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: color,
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

class _CompassNeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // North Pointer (Red)
    final northPath = Path()
      ..moveTo(cx, cy - 24)
      ..lineTo(cx - 5, cy)
      ..lineTo(cx + 5, cy)
      ..close();

    final northPaint = Paint()
      ..color = const Color(0xFFFF385C)
      ..style = PaintingStyle.fill;

    canvas.drawPath(northPath, northPaint);

    // South Pointer (White)
    final southPath = Path()
      ..moveTo(cx, cy + 24)
      ..lineTo(cx - 5, cy)
      ..lineTo(cx + 5, cy)
      ..close();

    final southPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.fill;

    canvas.drawPath(southPath, southPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
