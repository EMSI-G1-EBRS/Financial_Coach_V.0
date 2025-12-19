import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import '../services/api_service.dart';
import '../services/voice_service.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService apiService;
  final VoiceService voiceService;

  // Id utilisateur (pour l’instant généré, tu pourras plus tard le lier à un vrai compte)
  final String _userId;

  ChatProvider(this.apiService, this.voiceService, {String? userId})
      : _userId = userId ?? const Uuid().v4();

  // Etat privé
  List<ChatMessage> _messages = [];
  String _currentConversationId = const Uuid().v4();
  final Map<String, List<ChatMessage>> _conversationsHistory = {};
  bool _isListening = false;
  bool _isReplying = false;
  String _language = 'fr'; // fr, ar, en

  // Getters
  List<ChatMessage> get messages => _messages;
  bool get isListening => _isListening;
  bool get isReplying => _isReplying;
  String get currentConversationId => _currentConversationId;
  List<String> get conversationIds => _conversationsHistory.keys.toList();
  String get language => _language;
  String get userId => _userId;

  // Initialisation de la voix (appelée depuis main)
  Future<void> initializeVoice() async {
    try {
      await voiceService.initialize();
      // Appliquer la langue par défaut
      voiceService.setLanguage(_language);
    } catch (_) {}
  }

  // Changer la langue/persona
  void setLanguage(String lang) {
    if (lang == _language) return;
    _language = lang;
    voiceService.setLanguage(_language);
    notifyListeners();
  }

  // Ecoute micro
  void startListening() {
    if (_isReplying) return; // ne pas écouter pendant une réponse
    _isListening = true;
    notifyListeners();
    voiceService.startListening((text) {

    });
  }

  Future<void> stopListeningAndSend() async {
    if (!_isListening) return;
    _isListening = false;
    voiceService.stopListening();
    final userText = voiceService.lastRecognizedText.trim();
    if (userText.isEmpty) {
      notifyListeners();
      return;
    }

    _messages = List.of(_messages)
      ..add(ChatMessage(text: userText, isUser: true));
    notifyListeners();

    await _sendAgentMessage(userText);
  }

  Future<void> _sendAgentMessage(String userText) async {
    _isReplying = true;
    notifyListeners();
    try {
      final reply = await apiService.sendMessage(
        message: userText,
        userId: _userId,
        conversationId: _currentConversationId,
        language: _language,
        persona: _personaForLanguage(_language),
      );

      final cleanedReply = _cleanForTts(reply);

      _messages = List.of(_messages)
        ..add(ChatMessage(text: cleanedReply, isUser: false));

      // TTS
      await voiceService.speak(cleanedReply);
    } catch (e) {/*
      _messages = List.of(_messages)
        ..add(ChatMessage(text: 'Erreur: $e', isUser: false));*/
    } finally {
      _isReplying = false;
      notifyListeners();
    }
  }

  // Remplace les \n par des pauses naturelles pour la voix
  String _cleanForTts(String text) {
    // On garde les retours à la ligne pour l’affichage,
    // mais pour la voix c’est mieux en phrases.
    return text.replaceAll(RegExp(r'[\r\n]+'), '. ');
  }

  String _personaForLanguage(String lang) {
    switch (lang) {
      case 'ar':
        return 'كوتش مالي';
      case 'en':
        return 'financial coach';
      case 'fr':
      default:
        return 'coach financier';
    }
  }

  /// Crée une nouvelle conversation (nouvel onglet)
  void newConversation() {
    // Sauvegarde l’ancienne
    _conversationsHistory[_currentConversationId] = List.of(_messages);

    // Nouveau fil
    _currentConversationId = const Uuid().v4();
    _conversationsHistory[_currentConversationId] = []; // enregistrer le nouvel id
    _messages = [];
    notifyListeners();
  }

  /// Changer de conversation (depuis le Drawer)
  Future<void> switchConversation(String conversationId) async {
    if (conversationId == _currentConversationId) return;
    _currentConversationId = conversationId;
    await _loadHistory(conversationId);
  }

  Future<void> _loadHistory(String conversationId) async {
    try {
      final history = await apiService.getHistory(
        userId: _userId,
        conversationId: conversationId,
      );
      _messages = history;
    } catch (e) {
      _messages = [
        ChatMessage(
          text: 'Impossible de charger l\'historique: $e',
          isUser: false,
        )
      ];
    }
    notifyListeners();
  }

  /// Réinitialise la conversation courante côté backend
  Future<void> resetCurrentConversation() async {
    _isReplying = true;
    notifyListeners();
    // arreter la voix si elle parle
    voiceService.stopSpeaking();
    try {
      await apiService.clearHistory(
        userId: _userId,
        conversationId: _currentConversationId,
      );
      _messages = [];
    } catch (e) {
      _messages = [
        ChatMessage(
          text: 'Erreur lors de la réinitialisation: $e',
          isUser: false,
        )
      ];
    } finally {
      _isReplying = false;
      notifyListeners();
    }
  }
}
