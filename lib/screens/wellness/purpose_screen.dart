import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_colors.dart';

class PurposeScreen extends StatefulWidget {
  const PurposeScreen({super.key});

  @override
  State<PurposeScreen> createState() => _PurposeScreenState();
}

class _PurposeScreenState extends State<PurposeScreen> {
  final TextEditingController _curiosityController = TextEditingController();
  String? _savedAspiration;

  final List<Map<String, String>> _categories = [
    {
      'icon': '📚',
      'title': 'Learning & Knowledge',
      'desc': 'Discover new concepts, language words, history, or science documentaries.',
    },
    {
      'icon': '🎵',
      'title': 'Music & Rhythm',
      'desc': 'Play an instrument, listen to acoustic playlists, or learn lyrics of a poem.',
    },
    {
      'icon': '🏏',
      'title': 'Sports & Movement',
      'desc': 'Enjoy the strategy, teamwork, and playful spirit of athletic sports.',
    },
    {
      'icon': '🎨',
      'title': 'Creativity & Craft',
      'desc': 'Sketching, painting, pottery, writing, or cooking an inventive recipe.',
    },
    {
      'icon': '💻',
      'title': 'Coding & Technology',
      'desc': 'Build a helpful tool, explore algorithms, or automate everyday tasks.',
    },
    {
      'icon': '🌱',
      'title': 'Gardening & Nature',
      'desc': 'Nurture houseplants, plant a seed, or observe plants growing under sunlight.',
    },
    {
      'icon': '📖',
      'title': 'Reading & Books',
      'desc': 'Immerse in classic novels, biographies, or short essay collections.',
    },
    {
      'icon': '❤️',
      'title': 'Helping Others',
      'desc': 'Volunteer, help a neighbor with groceries, or offer compassionate advice.',
    },
  ];

  @override
  void dispose() {
    _curiosityController.dispose();
    super.dispose();
  }

  void _saveAspiration() {
    if (_curiosityController.text.trim().isNotEmpty) {
      setState(() {
        _savedAspiration = _curiosityController.text.trim();
        _curiosityController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aspiration added to your Rejuvenate journey 🎯')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purpose 🎯'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Make time for things that matter to you.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
              ),
            ),
            const SizedBox(height: 16),
            // Reflection prompt card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.darkCard, const Color(0xFF162A29)]
                      : [const Color(0xFFE2F4F7), const Color(0xFFD6EEF3)],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : const Color(0xFFB8E2EB),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('✨ ', style: TextStyle(fontSize: 22)),
                      Text(
                        'Gentle Reflection',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '“What is one thing you have always wanted to learn or try?”',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (_savedAspiration != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardElevated : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.warmAmber, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _savedAspiration!,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _curiosityController,
                          decoration: InputDecoration(
                            hintText: 'e.g. Learn acoustic guitar, astronomy...',
                            fillColor: isDark ? AppColors.darkSurface : Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _saveAspiration,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(70, 48),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                        ),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Meaningful Categories & Interests',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ..._categories.map((cat) {
              final isSaved = appState.user.interests.any(
                (intItem) => intItem.toLowerCase().contains(cat['title']!.toLowerCase().split(' ').first),
              );

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSaved
                        ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                        : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                    width: isSaved ? 1.5 : 1.0,
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
                      child: Text(cat['icon']!, style: const TextStyle(fontSize: 22)),
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
                                  cat['title']!,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                              ),
                              if (isSaved)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkCardElevated : AppColors.softMint,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Selected',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cat['desc']!,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: isSaved
                            ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                            : (isDark ? AppColors.darkTextSecondary : const Color(0xFFC0CEC5)),
                      ),
                      onPressed: () {
                        final currentInterests = List<String>.from(appState.user.interests);
                        final interestName = cat['title']!;
                        if (isSaved) {
                          currentInterests.removeWhere((i) => i.contains(cat['title']!.split(' ').first));
                        } else {
                          currentInterests.add(interestName);
                        }
                        appState.updateUserProfile(interests: currentInterests);
                      },
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
