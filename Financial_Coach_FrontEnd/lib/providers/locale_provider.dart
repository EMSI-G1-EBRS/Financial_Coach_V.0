import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('fr');

  Locale get locale => _locale;

  String get languageCode => _locale.languageCode;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'fr';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    if (_locale.languageCode == languageCode) return;

    _locale = Locale(languageCode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);

    notifyListeners();
  }

  // Get language code for ChatProvider
  String get chatLanguageCode {
    // Map locale codes to ChatProvider expected codes
    switch (_locale.languageCode) {
      case 'ar':
        return 'ar'; // Darija/Arabic
      case 'en':
        return 'en'; // English
      case 'es':
        return 'fr'; // Spanish not supported by ChatProvider, fallback to French
      case 'fr':
      default:
        return 'fr'; // French (default)
    }
  }

  String getLanguageLabel(String code) {
    switch (code) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية (Darija)';
      case 'es':
        return 'Español';
      default:
        return code;
    }
  }
}
