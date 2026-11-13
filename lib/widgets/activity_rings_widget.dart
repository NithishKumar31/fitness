import 'dart:math' as math;
import 'package:flutter/material.dart';

class ActivityRingsWidget extends StatelessWidget {
  final double stepProgress; // 0.0 to 1.0+
  final double calorieProgress;
  final double activeMinutesProgress;
  final double size;
  final Widget? centerChild;

  const ActivityRingsWidget({
    super.key,
    required this.stepProgress,
    required this.calorieProgress,
    required this.activeMinutesProgress,
    this.size = 160,
    this.centerChild,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final center = centerChild;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingsPainter(
              stepProgress: stepProgress,
              calorieProgress: calorieProgress,
              activeMinutesProgress: activeMinutesProgress,
              isDark: isDark,
            ),
          ),
          ?center,
        ],
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  final double stepProgress;
  final double calorieProgress;
  final double activeMinutesProgress;
  final bool isDark;

  _RingsPainter({
    required this.stepProgress,
    required this.calorieProgress,
    required this.activeMinutesProgress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = size.width * 0.082;
    final spacing = strokeWidth * 1.35;

    final outerRadius = (size.width / 2) - (strokeWidth / 2);
    final middleRadius = outerRadius - spacing;
    final innerRadius = middleRadius - spacing;

    // Outer Ring: Steps (Crimson / Sunset Red-Orange)
    _drawRing(
      canvas: canvas,
      center: center,
      radius: outerRadius,
      strokeWidth: strokeWidth,
      progress: stepProgress,
      trackColor: const Color(0xFFFF385C).withValues(alpha: isDark ? 0.20 : 0.15),
      startColor: const Color(0xFFFF385C),
      endColor: const Color(0xFFFF7A00),
    );

    // Middle Ring: Calories (Amber / Flame Gold)
    _drawRing(
      canvas: canvas,
      center: center,
      radius: middleRadius,
      strokeWidth: strokeWidth,
      progress: calorieProgress,
      trackColor: const Color(0xFFFF9500).withValues(alpha: isDark ? 0.20 : 0.15),
      startColor: const Color(0xFFFF8C00),
      endColor: const Color(0xFFFFC107),
    );

    // Inner Ring: Active Minutes (Emerald / Bright Mint)
    _drawRing(
      canvas: canvas,
      center: center,
      radius: innerRadius,
      strokeWidth: strokeWidth,
      progress: activeMinutesProgress,
      trackColor: const Color(0xFF10B981).withValues(alpha: isDark ? 0.20 : 0.15),
      startColor: const Color(0xFF10B981),
      endColor: const Color(0xFF34D399),
    );
  }

  void _drawRing({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double strokeWidth,
    required double progress,
    required Color trackColor,
    required Color startColor,
    required Color endColor,
  }) {
    if (radius <= 0) return;

    // 1. Draw track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // 2. Draw progress arc
    if (progress > 0.005) {
      final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
      final rect = Rect.fromCircle(center: center, radius: radius);

      final progressPaint = Paint()
        ..shader = SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: 3 * math.pi / 2,
          colors: [startColor, endColor],
          tileMode: TileMode.clamp,
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        -math.pi / 2, // Start at top 12 o'clock
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) {
    return oldDelegate.stepProgress != stepProgress ||
        oldDelegate.calorieProgress != calorieProgress ||
        oldDelegate.activeMinutesProgress != activeMinutesProgress ||
        oldDelegate.isDark != isDark;
  }
}
