import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

enum VoiceLocale {
  french,
  english,
  arabic,
}

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool _isListening = false;
  String _lastRecognizedText = '';

  // Internal state tracking
  VoiceLocale _currentLocalePreference = VoiceLocale.french;
  bool _isTtsInitialized = false;

  /// Returns the current locale preference for UI updates if needed
  VoiceLocale get currentLocale => _currentLocalePreference;
  String get lastRecognizedText => _lastRecognizedText;

  /// Initialize the service. Call this once at app startup.
  Future<void> initialize() async {
    if (_isTtsInitialized) return;

    // 1. Configure iOS Audio Session (Critical for Volume/Routing)
    if (Platform.isIOS) {
      await _tts.setSharedInstance(true);
      await _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playAndRecord,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ],
        IosTextToSpeechAudioMode.defaultMode,
      );
    }

    // 2. General TTS Configuration
    // awaitSpeakCompletion(true) is vital for sequential conversation flows
    await _tts.awaitSpeakCompletion(true);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    // 3. Initialize STT (Permission check only)
    await _speech.initialize(
      onError: (e) => debugPrint('STT Error: $e'),
      onStatus: (s) => debugPrint('STT Status: $s'),
    );

    _isTtsInitialized = true;
    debugPrint("VoiceService: RPP Protocol Initialized");
  }

  /// Sets the user's preferred language context.
  /// Note: This does NOT trigger a TTS config change immediately.
  /// Configuration happens just-in-time during speak() to avoid race conditions.
  void setGlobalLanguage(String langCode) {
    switch (langCode) {
      case 'ar':
        _currentLocalePreference = VoiceLocale.arabic;
        break;
      case 'en':
        _currentLocalePreference = VoiceLocale.english;
        break;
      case 'fr':
      default:
        _currentLocalePreference = VoiceLocale.french;
        break;
    }
    // If listening, restart to apply new STT locale
    if (_isListening) {
      stopListening();
    }
  }

  // Backward compatibility with existing code expecting setLanguage(...)
  void setLanguage(String langCode) => setGlobalLanguage(langCode);

  /// The Core "Safe Speak" Method.
  /// 1. Detects script.
  /// 2. Resolves best available engine.
  /// 3. Configures engine.
  /// 4. Speaks.
  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    // Nettoyer les retours à la ligne pour le TTS
    final sanitized =
    text.replaceAll(RegExp(r'[\r\n]+'), '. ').trim();

    // Stop any ongoing interaction
    stopListening();
    await _tts.stop();

    // 1. Script Detection
    VoiceLocale targetLocale =
    _detectScriptLocale(sanitized, _currentLocalePreference);

    // 2. Negotiation
    String resolvedLanguage = await _resolveBestLanguage(targetLocale);

    // 3. Configuration
    try {
      await _tts.setLanguage(resolvedLanguage);

      if (targetLocale == VoiceLocale.arabic) {
        await _tts.setSpeechRate(0.45);
      } else {
        await _tts.setSpeechRate(0.5);
      }

      debugPrint("VoiceService: Speaking in '$resolvedLanguage'");

      // 4. Execution
      await _tts.speak(sanitized);
    } catch (e) {
      debugPrint("VoiceService: Critical Failure in Speak Chain - $e");
    }
  }


  /// Analyzes text content to determine the required TTS engine.
  VoiceLocale _detectScriptLocale(String text, VoiceLocale preference) {
    // Regex for Arabic Unicode Block
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    if (arabicRegex.hasMatch(text)) {
      // If text contains Arabic characters, force Arabic engine
      return VoiceLocale.arabic;
    }
    // Otherwise, respect the user's current setting (French or English)
    return preference;
  }

  /// The Fallback Chain Algorithm.
  /// Iterates through candidate locales to find one installed on the device.
  Future<String> _resolveBestLanguage(VoiceLocale locale) async {
    List<String> candidates;

    switch (locale) {
      case VoiceLocale.arabic:
        // Priority: Morocco -> Saudi (Standard iOS) -> Egypt -> UAE -> Generic
        candidates = ['ar-MA', 'ar-SA', 'ar-EG', 'ar-AE', 'ar'];
        break;
      case VoiceLocale.english:
        candidates = ['en-US', 'en-GB', 'en-AU', 'en-IN', 'en'];
        break;
      case VoiceLocale.french:
      default:
        candidates = ['fr-MA', 'fr-FR', 'fr-CA', 'fr-BE', 'fr-CH', 'fr'];
        break;
    }

    for (String lang in candidates) {
      // Check availability on the native platform
      bool available = await _tts.isLanguageAvailable(lang);
      if (available) {
        // Android specific check: is it actually installed?
        if (Platform.isAndroid) {
          bool installed = await _tts.isLanguageInstalled(lang);
          if (!installed) continue;
        }
        return lang;
      }
    }

    // Ultimate Fallback: Default to US English rather than silence
    debugPrint("VoiceService: No candidates found for $locale. Fallback to en-US.");
    return 'en-US';
  }

  void startListening(Function(String) onResult) async {
    if (_isListening) return;

    // Resolve STT Locale (Cloud STT usually supports exact locales better than on-device TTS)
    String sttLocaleId;
    switch (_currentLocalePreference) {
      case VoiceLocale.arabic:
        sttLocaleId = 'ar_MA';
        break;
      case VoiceLocale.english:
        sttLocaleId = 'en_US';
        break;
      case VoiceLocale.french:
      default:
        sttLocaleId = 'fr_FR';
        break;
    }

    bool available = await _speech.initialize(
      onStatus: (val) {
        if (val == 'done' || val == 'notListening') {
          _isListening = false;
        }
      },
      onError: (val) => debugPrint('STT Error: $val'),
    );

    if (available) {
      _isListening = true;
      _speech.listen(
        localeId: sttLocaleId,
        onResult: (val) {
          _lastRecognizedText = val.recognizedWords;
          onResult(_lastRecognizedText);
        },
      );
    }
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
    }
  }

  void stopSpeaking() {}
}