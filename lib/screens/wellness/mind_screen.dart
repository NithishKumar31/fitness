import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../live_session_screen.dart';

class MindScreen extends StatefulWidget {
  const MindScreen({super.key});

  @override
  State<MindScreen> createState() => _MindScreenState();
}

class _MindScreenState extends State<MindScreen> {
  final TextEditingController _journalController = TextEditingController();
  final List<String> _journalEntries = [
    "Enjoyed the morning breeze and a warm cup of herbal tea.",
  ];

  void _openBreathingModal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LiveSessionScreen(
          type: SessionType.meditation,
          initialMinutes: 5,
          title: 'Guided Breathing Space',
          icon: '🌬️',
        ),
      ),
    );
  }

  void _openJournalDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Text('📝 ', style: TextStyle(fontSize: 20)),
            Text('Daily Reflection'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What was one small thing that made you smile or feel calm today?',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _journalController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Write a few comforting lines...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_journalController.text.trim().isNotEmpty) {
                setState(() {
                  _journalEntries.insert(0, _journalController.text.trim());
                  _journalController.clear();
                });
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reflection saved 🌱')),
              );
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 42)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mind 🧠'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Give your mind a little space.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
              ),
            ),
            const SizedBox(height: 16),
            // Guided Breathing Highlight Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.darkCard, const Color(0xFF132B2E)]
                      : [AppColors.softMint, const Color(0xFFDCF2EF)],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? AppColors.darkCardElevated : Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: const Text('🌬️', style: TextStyle(fontSize: 26)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Guided Breathing Space',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Take 5 minutes to slow down and breathe.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _openBreathingModal,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(76, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    child: const Text('Start'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Mindful Moments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            _buildMindCard(
              context,
              icon: '🧘',
              title: 'Relaxation & Body Scan',
              description: 'Progressively release tension from your forehead down to your toes.',
              duration: '7 min',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LiveSessionScreen(
                      type: SessionType.meditation,
                      initialMinutes: 7,
                      title: 'Relaxation & Body Scan',
                      icon: '🧘',
                    ),
                  ),
                );
              },
            ),
            _buildMindCard(
              context,
              icon: '📝',
              title: 'Gratitude & Journaling',
              description: 'Jot down a few simple thoughts and cherish small daily joys.',
              duration: '5 min',
              onTap: _openJournalDialog,
            ),
            _buildMindCard(
              context,
              icon: '🎯',
              title: 'Single-Task Focus',
              description: 'Pick one pleasant activity and immerse yourself for 10 unhurried minutes.',
              duration: '10 min',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LiveSessionScreen(
                      type: SessionType.meditation,
                      initialMinutes: 10,
                      title: 'Single-Task Focus',
                      icon: '🎯',
                    ),
                  ),
                );
              },
            ),
            _buildMindCard(
              context,
              icon: '🌱',
              title: 'Positive Reflection',
              description: 'Acknowledge your efforts today without criticism.',
              duration: '3 min',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LiveSessionScreen(
                      type: SessionType.meditation,
                      initialMinutes: 3,
                      title: 'Positive Reflection',
                      icon: '🌱',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Saved reflections
            if (_journalEntries.isNotEmpty) ...[
              Text(
                'Recent Gentle Notes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ..._journalEntries.map((entry) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🌱 ', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Text(
                            entry,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
            const SizedBox(height: 16),
            // Safety reminder
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.warmCream,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, size: 20, color: AppColors.primaryGreen),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Rejuvenate offers gentle lifestyle habits and does not diagnose or treat medical or psychological conditions.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMindCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
    required String duration,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.softCanvasLight,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(64, 38),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            child: const Text('Start', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
