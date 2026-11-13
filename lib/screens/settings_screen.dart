import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_colors.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showLanguageDialog(BuildContext context) {
    final langProvider = context.read<LanguageProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Choose Language / மொழி'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              trailing: langProvider.languageCode == 'en'
                  ? const Icon(Icons.check, color: AppColors.primaryGreen)
                  : null,
              onTap: () {
                langProvider.setLanguage('en');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('தமிழ் (Tamil)'),
              trailing: langProvider.languageCode == 'ta'
                  ? const Icon(Icons.check, color: AppColors.primaryGreen)
                  : null,
              onTap: () {
                langProvider.setLanguage('ta');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPaletteDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
            Row(
              children: [
                const Icon(Icons.palette_rounded, color: AppColors.primaryGreen, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Choose Color Theme',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Select a calming, natural aesthetic that resonates with your day:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _buildPaletteTile(
              context,
              name: 'Ocean Teal & Soft Mint',
              subtitle: 'Fresh, tranquil aquatic serenity (Active)',
              color1: const Color(0xFF006D77),
              color2: const Color(0xFF83C5BE),
              isSelected: true,
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ocean Teal & Soft Mint is active 🌊')),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildPaletteTile(
              context,
              name: 'Calming Forest & Mint',
              subtitle: 'Lush botanicals and gentle leafy energy',
              color1: const Color(0xFF2D6A4F),
              color2: const Color(0xFF74C69D),
              isSelected: false,
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Switched to Forest Green palette 🌱')),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildPaletteTile(
              context,
              name: 'Warm Sunset & Peach',
              subtitle: 'Cozy terracotta and comforting sunrise light',
              color1: const Color(0xFFE27357),
              color2: const Color(0xFFF6BD60),
              isSelected: false,
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Switched to Warm Sunset palette 🌅')),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildPaletteTile(
              context,
              name: 'Gentle Lavender & Rose',
              subtitle: 'Soothing twilight and calm mindfulness',
              color1: const Color(0xFF7F6A93),
              color2: const Color(0xFFB5A4D8),
              isSelected: false,
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Switched to Gentle Lavender palette 💜')),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPaletteTile(
    BuildContext context, {
    required String name,
    required String subtitle,
    required Color color1,
    required Color color2,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkCardElevated : AppColors.softMint)
              : (isDark ? AppColors.darkSurface : AppColors.warmCream),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.darkMint : AppColors.primaryGreen)
                : (isDark ? AppColors.darkBorder : AppColors.borderLight),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(color: color1, shape: BoxShape.circle),
                ),
                Transform.translate(
                  offset: const Offset(-6, 0),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: color2,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Privacy & Care'),
        content: const SingleChildScrollView(
          child: Text(
            'At Rejuvenate, your wellbeing is sacred.\n\n'
            '• We do not sell or share personal habits.\n'
            '• Rejuvenate is an everyday lifestyle companion, not a doctor or medical clinic.\n'
            '• We never judge or score your body, appearance, or lifestyle.\n'
            '• All reflections and journals stay local and safe with you.',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Text('🌱 ', style: TextStyle(fontSize: 24)),
            Text('About Rejuvenate'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
            ),
            SizedBox(height: 12),
            Text(
              'Rejuvenate is a friendly everyday wellness and lifestyle companion for common people.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            SizedBox(height: 12),
            Text(
              '“Small steps. Better habits. A more alive everyday life.”\n\n“Feel more alive in the life you already have.”',
              style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: AppColors.primaryGreenDark),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final appState = context.watch<AppStateProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings ⚙️'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          _buildSectionHeader('Preferences', isDark),
          _buildSettingCard(
            isDark: isDark,
            children: [
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Theme Palette', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('🌊 Ocean Teal & Soft Mint (Active)'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showPaletteDialog(context),
              ),
              const Divider(height: 1),
              SwitchListTile(
                value: themeProvider.isDarkMode,
                activeThumbColor: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Tranquil oceanic night palette'),
                secondary: const Icon(Icons.dark_mode_outlined),
                onChanged: (val) => themeProvider.toggleTheme(),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text('Language / மொழி', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(langProvider.isTamil ? 'தமிழ் (Tamil)' : 'English'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showLanguageDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 18),

          _buildSectionHeader('Reminders & Habits', isDark),
          _buildSettingCard(
            isDark: isDark,
            children: [
              SwitchListTile(
                value: appState.notificationsEnabled,
                activeThumbColor: isDark ? AppColors.darkMint : AppColors.primaryGreen,
                title: const Text('Daily Gentle Reminders', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Good morning ☀️ & small mission alerts'),
                secondary: const Icon(Icons.notifications_outlined),
                onChanged: (_) => appState.toggleNotifications(),
              ),
            ],
          ),
          const SizedBox(height: 18),

          _buildSectionHeader('Support & Trust', isDark),
          _buildSettingCard(
            isDark: isDark,
            children: [
              ListTile(
                leading: const Icon(Icons.shield_outlined),
                title: const Text('Privacy & Non-Medical Assurance', style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showPrivacyDialog(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('About Rejuvenate', style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showAboutDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 18),

          _buildSectionHeader('Account', isDark),
          _buildSettingCard(
            isDark: isDark,
            children: [
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                title: const Text(
                  'Log Out',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.redAccent),
                ),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextSecondary : AppColors.textMutedLight,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildSettingCard({required bool isDark, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        ),
      ),
      child: Column(children: children),
    );
  }
}
