import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
import 'app_localizations.dart';

@singleton
class LocalizationService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  Locale _currentLocale = const Locale('si', '');
  bool _isInitialized = false;

  Locale get currentLocale => _currentLocale;
  bool get isInitialized => _isInitialized;

  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  Future<void> init() async {
    if (_isInitialized) return;

    await _loadSavedLanguage();
    _isInitialized = true;
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_languageKey);

      if (savedLanguageCode != null) {
        final savedLocale = Locale(savedLanguageCode, '');
        if (supportedLocales.any(
          (locale) => locale.languageCode == savedLanguageCode,
        )) {
          _currentLocale = savedLocale;
          notifyListeners();
        }
      }
    } catch (e) {
      // If loading fails, keep default locale
      debugPrint('Failed to load saved language: $e');
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale == locale) return;

    if (supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    )) {
      _currentLocale = locale;
      await _saveLanguage(locale.languageCode);
      notifyListeners();
    }
  }

  Future<void> _saveLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      debugPrint('Failed to save language preference: $e');
    }
  }

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'si':
        return 'සිංහල';
      case 'ta':
        return 'தமிழ்';
      default:
        return 'English';
    }
  }

  String getLanguageNameInCurrentLocale(String languageCode) {
    switch (_currentLocale.languageCode) {
      case 'si':
        switch (languageCode) {
          case 'en':
            return 'ඉංග්‍රීසි';
          case 'si':
            return 'සිංහල';
          case 'ta':
            return 'දෙමළ';
          default:
            return 'ඉංග්‍රීසි';
        }
      case 'ta':
        switch (languageCode) {
          case 'en':
            return 'ஆங்கிலம்';
          case 'si':
            return 'சிங்களம்';
          case 'ta':
            return 'தமிழ்';
          default:
            return 'ஆங்கிலம்';
        }
      case 'en':
      default:
        switch (languageCode) {
          case 'en':
            return 'English';
          case 'si':
            return 'Sinhala';
          case 'ta':
            return 'Tamil';
          default:
            return 'English';
        }
    }
  }
}
