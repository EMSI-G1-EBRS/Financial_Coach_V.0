import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../providers/user_profile_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final currentLang = localeProvider.languageCode;

    final List<Map<String, dynamic>> languages = [
      {
        'code': 'fr',
        'name': 'Français',
        'nativeName': 'Français',
        'flag': '🇫🇷',
        'color': const Color(0xFF0055A4),
      },
      {
        'code': 'en',
        'name': 'English',
        'nativeName': 'English',
        'flag': '🇺🇸',
        'color': const Color(0xFF3C3B6E),
      },
      {
        'code': 'ar',
        'name': 'Arabic',
        'nativeName': 'العربية (Darija)',
        'flag': '🇲🇦',
        'color': const Color(0xFFC1272D),
      },
      {
        'code': 'es',
        'name': 'Spanish',
        'nativeName': 'Español',
        'flag': '🇪🇸',
        'color': const Color(0xFFC60B1E),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Language',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.language,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Choose Your Language',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select your preferred language for the app',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Language List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final lang = languages[index];
                final isSelected = currentLang == lang['code'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildLanguageCard(
                    context,
                    lang: lang,
                    isSelected: isSelected,
                    onTap: () => _changeLanguage(context, lang['code']),
                  ),
                );
              },
            ),
          ),

          // Info Section
          Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'The app interface will be displayed in your selected language',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[900],
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context, {
    required Map<String, dynamic> lang,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? lang['color'].withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? lang['color']
                : Colors.grey[300]!,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: lang['color'].withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Flag
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  lang['flag'],
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Language Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: isSelected ? lang['color'] : const Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lang['nativeName'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),

            // Check Icon
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: lang['color'],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeLanguage(BuildContext context, String code) async {
    final localeProvider = context.read<LocaleProvider>();
    final profileProvider = context.read<UserProfileProvider>();

    // Update locale
    await localeProvider.setLocale(code);

    // Update profile preference
    await profileProvider.updatePreferences(preferredLanguage: code);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Language changed to ${localeProvider.getLanguageLabel(code)}'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
