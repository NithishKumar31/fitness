import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AnimatedBreathingCircle extends StatefulWidget {
  final VoidCallback? onCycleCompleted;

  const AnimatedBreathingCircle({super.key, this.onCycleCompleted});

  @override
  State<AnimatedBreathingCircle> createState() => _AnimatedBreathingCircleState();
}

class _AnimatedBreathingCircleState extends State<AnimatedBreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Timer? _phaseTimer;

  String _phaseText = "Tap to Begin";
  String _phaseDetail = "Take a moment to calm your mind";
  bool _isActive = false;
  int _completedCycles = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleBreathing() {
    if (_isActive) {
      _stopBreathing();
    } else {
      _startBreathing();
    }
  }

  void _startBreathing() {
    setState(() {
      _isActive = true;
    });
    _runInhale();
  }

  void _runInhale() {
    if (!_isActive) return;
    setState(() {
      _phaseText = "Inhale slowly...";
      _phaseDetail = "Fill your chest with calm air";
    });
    _controller.forward(from: 0.0);

    _phaseTimer = Timer(const Duration(seconds: 4), () {
      _runHold();
    });
  }

  void _runHold() {
    if (!_isActive) return;
    setState(() {
      _phaseText = "Hold gently...";
      _phaseDetail = "Rest in this stillness";
    });

    _phaseTimer = Timer(const Duration(seconds: 4), () {
      _runExhale();
    });
  }

  void _runExhale() {
    if (!_isActive) return;
    setState(() {
      _phaseText = "Exhale slowly...";
      _phaseDetail = "Release any tension";
    });
    _controller.reverse(from: 1.0);

    _phaseTimer = Timer(const Duration(seconds: 4), () {
      _runRest();
    });
  }

  void _runRest() {
    if (!_isActive) return;
    setState(() {
      _phaseText = "Rest...";
      _phaseDetail = "You are doing wonderful";
      _completedCycles++;
    });
    widget.onCycleCompleted?.call();

    _phaseTimer = Timer(const Duration(seconds: 2), () {
      _runInhale();
    });
  }

  void _stopBreathing() {
    _phaseTimer?.cancel();
    _controller.stop();
    setState(() {
      _isActive = false;
      _phaseText = "Tap to Begin";
      _phaseDetail = "Take a moment to calm your mind";
    });
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _toggleBreathing,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              final scale = _isActive ? _scaleAnimation.value : 1.0;
              return Container(
                width: 190 * scale,
                height: 190 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: isDark
                        ? [
                            AppColors.darkMint.withValues(alpha: 0.35),
                            AppColors.darkPrimary.withValues(alpha: 0.15),
                            Colors.transparent,
                          ]
                        : [
                            AppColors.softMint,
                            AppColors.mintAccent.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                  ),
                  boxShadow: _isActive
                      ? [
                          BoxShadow(
                            color: (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                                .withValues(alpha: 0.25),
                            blurRadius: 28 * scale,
                            spreadRadius: 8 * scale,
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? AppColors.darkCardElevated : Colors.white,
                      border: Border.all(
                        color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isActive ? Icons.air_rounded : Icons.play_arrow_rounded,
                          size: 32,
                          color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            _phaseText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
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
        ),
        const SizedBox(height: 16),
        Text(
          _phaseDetail,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
          ),
        ),
        if (_completedCycles > 0) ...[
          const SizedBox(height: 6),
          Text(
            '$_completedCycles breath cycle${_completedCycles > 1 ? 's' : ''} completed 🌱',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
            ),
          ),
        ],
      ],
    );
  }
}
