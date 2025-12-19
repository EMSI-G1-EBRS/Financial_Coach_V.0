import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/chat_message.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<String> sendMessage({
    required String message,
    required String userId,
    required String conversationId,
    String? language,
    String? persona,
  }) async {
    final uri = Uri.parse('$baseUrl/chat');

    final payload = <String, dynamic>{
      'message': message,
      'user_id': userId,
      'conversation_id': conversationId,
    };
    if (language != null) payload['language'] = language;
    if (persona != null) payload['persona'] = persona;

    try {
      final response = await http
          .post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        final String aiResponse =
            (body['response'] ?? body['message'] ?? '').toString();
        return aiResponse;
      } else {
        throw Exception('Erreur API ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      // Rendre l'erreur plus lisible pour l'UI
      throw Exception(
          'Impossible de joindre le service de chat ($baseUrl). Détails: $e');
    }
  }

  Future<List<ChatMessage>> getHistory({
    required String userId,
    required String conversationId,
  }) async {
    final uri = Uri.parse(
        '$baseUrl/history?user_id=$userId&conversation_id=$conversationId');

    try {
      final response = await http
          .get(
        uri,
        headers: {'Accept': 'application/json'},
      )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final List list = (decoded is List)
            ? decoded
            : (decoded['history'] is List ? decoded['history'] : <dynamic>[]);
        return list
            .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Erreur API ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception(
          'Impossible de joindre le service de chat ($baseUrl). Détails: $e');
    }
  }

  Future<void> clearHistory({
    required String userId,
    required String conversationId,
  }) async {
    final uri = Uri.parse('$baseUrl/clear_history');
    final payload = {
      'user_id': userId,
      'conversation_id': conversationId,
    };

    try {
      final response = await http
          .post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(
            'Erreur clear_history ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Impossible de joindre le service de chat ($baseUrl). Détails: $e');
    }
  }
}
