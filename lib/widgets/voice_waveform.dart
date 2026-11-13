import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class VoiceWaveformWidget extends StatefulWidget {
  final bool isAnimating;
  final Color? barColor;

  const VoiceWaveformWidget({
    super.key,
    required this.isAnimating,
    this.barColor,
  });

  @override
  State<VoiceWaveformWidget> createState() => _VoiceWaveformWidgetState();
}

class _VoiceWaveformWidgetState extends State<VoiceWaveformWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = widget.barColor ?? (isDark ? AppColors.darkMint : AppColors.primaryGreen);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(16, (index) {
            double heightMultiplier = 0.25;
            if (widget.isAnimating) {
              final wave = sin((_controller.value * 2 * pi) + (index * 0.45));
              heightMultiplier = 0.25 + (wave.abs() * 0.75);
            }
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              width: 4,
              height: 48 * heightMultiplier,
              decoration: BoxDecoration(
                color: color.withValues(
                  alpha: widget.isAnimating ? (0.4 + (heightMultiplier * 0.6)) : 0.2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }
}
