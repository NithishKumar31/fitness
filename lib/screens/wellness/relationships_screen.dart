import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';

class RelationshipsScreen extends StatefulWidget {
  const RelationshipsScreen({super.key});

  @override
  State<RelationshipsScreen> createState() => _RelationshipsScreenState();
}

class _RelationshipsScreenState extends State<RelationshipsScreen> {
  final List<String> _sampleKindMessages = [
    "“Hey! Just thinking of you today and hoping you are having a peaceful week 😊”",
    "“Hi there! No reply needed, just wanted to say I appreciate you and am grateful for our friendship 💚”",
    "“Thinking of you! Sending you warm thoughts and a big smile today ☀️”",
    "“Hey, hope you're taking good care of yourself today! Let's catch up soon 🌱”",
  ];

  void _showKindMessageTemplates() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkCard
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Row(
              children: [
                Text('😊 ', style: TextStyle(fontSize: 26)),
                Text(
                  'Send a Kind Message',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap any message to copy it to your clipboard:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ..._sampleKindMessages.map((msg) => GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: msg.replaceAll('“', '').replaceAll('”', '')));
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Message copied to clipboard! Paste it to someone you care about ❤️')),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.softMint.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            msg,
                            style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, height: 1.35),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.copy_rounded, size: 18, color: AppColors.primaryGreen),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relationships 🤝'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Small connections can make a big difference.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              icon: '😊',
              title: 'Send a Kind Message',
              description: 'A brief, thoughtful text message can brighten someone’s whole afternoon.',
              actionLabel: 'Browse Templates',
              onTap: _showKindMessageTemplates,
            ),
            _buildActionCard(
              context,
              icon: '📞',
              title: 'Call a Friend or Family',
              description: 'Have a 5-minute warm chat just to hear a familiar, comforting voice.',
              actionLabel: 'Mark Done',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connection made! Meaningful relationships bring joy ❤️')),
                );
              },
            ),
            _buildActionCard(
              context,
              icon: '❤️',
              title: 'Check In With Loved Ones',
              description: 'Ask someone how their day really went and simply listen with an open heart.',
              actionLabel: 'Start',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Listening is one of the most generous forms of kindness.')),
                );
              },
            ),
            _buildActionCard(
              context,
              icon: '👥',
              title: 'Meet for a Tea or Walk',
              description: 'Plan a casual 20-minute meetup or stroll in the park with a neighbor or friend.',
              actionLabel: 'Plan',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('A shared cup of tea or walk creates lasting warmth ☕')),
                );
              },
            ),
            _buildActionCard(
              context,
              icon: '👨‍👩‍👧',
              title: 'Quality Family Time',
              description: 'Share a screen-free meal, play a board game, or tell a funny story together.',
              actionLabel: 'Reflect',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cherish these quiet shared moments 🌱')),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
    required String actionLabel,
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
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(64, 38),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            child: Text(actionLabel, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
