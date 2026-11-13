import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class HrZone {
  final int zone;
  final String name;
  final String range;
  final Color color;
  final String benefit;

  const HrZone({
    required this.zone,
    required this.name,
    required this.range,
    required this.color,
    required this.benefit,
  });
}

class DigitalBioScannerWidget extends StatefulWidget {
  const DigitalBioScannerWidget({super.key});

  @override
  State<DigitalBioScannerWidget> createState() => _DigitalBioScannerWidgetState();
}

class _DigitalBioScannerWidgetState extends State<DigitalBioScannerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ecgController;
  int _selectedZone = 2; // Zone 2 (Fat Burn) default active

  static const List<HrZone> zones = [
    HrZone(
      zone: 1,
      name: 'WARM UP',
      range: '90-110 BPM',
      color: Color(0xFF38BDF8),
      benefit: 'Active recovery, warm-up & gentle circulation',
    ),
    HrZone(
      zone: 2,
      name: 'FAT BURN',
      range: '111-130 BPM',
      color: Color(0xFF00FF66),
      benefit: 'Optimizes fat oxidation & baseline aerobic capacity',
    ),
    HrZone(
      zone: 3,
      name: 'AEROBIC',
      range: '131-150 BPM',
      color: Color(0xFFFFD600),
      benefit: 'Cardiovascular endurance & lung stroke volume',
    ),
    HrZone(
      zone: 4,
      name: 'ANAEROBIC',
      range: '151-170 BPM',
      color: Color(0xFFFF9500),
      benefit: 'Lactate threshold & fast-twitch stamina',
    ),
    HrZone(
      zone: 5,
      name: 'VO2 MAX',
      range: '170+ BPM',
      color: Color(0xFFFF385C),
      benefit: 'Peak athletic power, sprint speed & VO2 maximum',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ecgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _ecgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentZone = zones[_selectedZone - 1];

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
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Digital Status Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF385C).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🫀', style: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DIGITAL ECG BIO-SCANNER',
                        style: GoogleFonts.orbitron(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: isDark ? const Color(0xFF00F0FF) : AppColors.primaryGreen,
                        ),
                      ),
                      Text(
                        'Optical PPG & Zone HUD',
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF00FF66).withValues(alpha: 0.15)
                      : const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF00FF66).withValues(alpha: 0.4)
                        : const Color(0xFFA7F3D0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF00FF66) : const Color(0xFF059669),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'LIVE PPG',
                      style: GoogleFonts.orbitron(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFF00FF66) : const Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 2. Real-time Animated ECG Oscilloscope Wave Box
          Container(
            height: 72,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF030712) : const Color(0xFFFFF8F6),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? const Color(0xFF1E293B) : AppColors.borderLight,
              ),
            ),
            child: Stack(
              children: [
                // Grid Scan Lines
                Positioned.fill(
                  child: CustomPaint(
                    painter: _RadarGridPainter(isDark: isDark),
                  ),
                ),
                // Animated ECG Wave
                AnimatedBuilder(
                  animation: _ecgController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _EcgWavePainter(
                        animationValue: _ecgController.value,
                        color: currentZone.color,
                      ),
                      size: const Size(double.infinity, 72),
                    );
                  },
                ),
                // Center Digital BPM Badge
                Positioned(
                  right: 12,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0A0F1D).withValues(alpha: 0.9)
                          : Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: currentZone.color.withValues(alpha: isDark ? 0.5 : 0.35),
                      ),
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.favorite_rounded,
                          color: Color(0xFFFF385C),
                          size: 14,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '118 BPM',
                          style: GoogleFonts.orbitron(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Heart Rate Zones Interactive 5-Bar Spectrum
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TARGET HEART RATE ZONES',
                style: GoogleFonts.orbitron(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark ? const Color(0xFF94A3B8) : AppColors.textMutedLight,
                ),
              ),
              Text(
                currentZone.range,
                style: GoogleFonts.shareTechMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: currentZone.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: zones.map((z) {
              final isSelected = z.zone == _selectedZone;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedZone = z.zone),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark
                              ? z.color.withValues(alpha: 0.25)
                              : z.color.withValues(alpha: 0.15))
                          : (isDark ? const Color(0xFF030712) : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? z.color
                            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: z.color.withValues(alpha: 0.35),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Z${z.zone}',
                          style: GoogleFonts.orbitron(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: isSelected
                                ? z.color
                                : (isDark ? const Color(0xFF64748B) : AppColors.textMutedLight),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: z.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // Active Zone Description Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? currentZone.color.withValues(alpha: 0.1)
                  : currentZone.color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: currentZone.color.withValues(alpha: isDark ? 0.3 : 0.25),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'ZONE $_selectedZone • ${currentZone.name}:',
                  style: GoogleFonts.orbitron(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: currentZone.color,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    currentZone.benefit,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : AppColors.textDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4. Biometric Telemetry Matrix Strip (Resting HR, HRV, SpO2, Body Battery)
          Row(
            children: [
              Expanded(
                child: _buildBioTile(
                  label: 'RESTING HR',
                  value: '62 BPM',
                  color: isDark ? const Color(0xFF00F0FF) : const Color(0xFF0284C7),
                  icon: '❤️',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBioTile(
                  label: 'HRV (MS)',
                  value: '68 ms',
                  color: isDark ? const Color(0xFF00FF66) : const Color(0xFF059669),
                  icon: '⚡',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBioTile(
                  label: 'SPO2 OXYGEN',
                  value: '99%',
                  color: const Color(0xFF0284C7),
                  icon: '🫁',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBioTile(
                  label: 'BODY BATTERY',
                  value: '84%',
                  color: isDark ? const Color(0xFFFFD600) : const Color(0xFFD97706),
                  icon: '🔋',
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBioTile({
    required String label,
    required String value,
    required Color color,
    required String icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
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
          const SizedBox(height: 2),
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 10)),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.shareTechMono(
                    fontSize: 11.5,
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

class _RadarGridPainter extends CustomPainter {
  final bool isDark;

  _RadarGridPainter({this.isDark = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)).withValues(alpha: 0.6)
      ..strokeWidth = 0.5;

    // Draw horizontal grid lines
    const hDiv = 3;
    for (int i = 1; i <= hDiv; i++) {
      final y = size.height * (i / (hDiv + 1));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarGridPainter oldDelegate) => oldDelegate.isDark != isDark;
}

class _EcgWavePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _EcgWavePainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final path = Path();
    final width = size.width;
    final midY = size.height / 2;

    // ECG pattern normalized (0.0 to 1.0)
    final points = <Offset>[];
    const totalPoints = 120;

    for (int i = 0; i <= totalPoints; i++) {
      final xRatio = i / totalPoints;
      final x = xRatio * width;

      // Phase with animation
      final phase = (xRatio - animationValue) % 1.0;
      double yOffset = 0.0;

      if (phase >= 0.40 && phase < 0.45) {
        // P wave
        yOffset = -math.sin((phase - 0.40) / 0.05 * math.pi) * 6;
      } else if (phase >= 0.47 && phase < 0.49) {
        // Q dip
        yOffset = 5;
      } else if (phase >= 0.49 && phase < 0.53) {
        // R spike (giant peak)
        final p = (phase - 0.49) / 0.04;
        yOffset = -math.sin(p * math.pi) * 26;
      } else if (phase >= 0.53 && phase < 0.56) {
        // S dip
        yOffset = 8;
      } else if (phase >= 0.60 && phase < 0.70) {
        // T wave
        yOffset = -math.sin((phase - 0.60) / 0.10 * math.pi) * 10;
      }

      points.add(Offset(x, midY + yOffset));
    }

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EcgWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.color != color;
  }
}
