import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service pour gérer le stockage sécurisé des tokens et informations utilisateur
class SecureStorageService {
  final FlutterSecureStorage _storage;

  // Clés de stockage
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyLoginTime = 'login_time';

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Sauvegarder les tokens et informations utilisateur
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String email,
  }) async {
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: accessToken),
      _storage.write(key: _keyRefreshToken, value: refreshToken),
      _storage.write(key: _keyUserId, value: userId),
      _storage.write(key: _keyUserEmail, value: email),
      _storage.write(
        key: _keyLoginTime,
        value: DateTime.now().toIso8601String(),
      ),
    ]);
  }

  /// Récupérer l'access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  /// Récupérer le refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  /// Récupérer l'ID utilisateur
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  /// Récupérer l'email utilisateur
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  /// Récupérer le temps de connexion
  Future<DateTime?> getLoginTime() async {
    final timeStr = await _storage.read(key: _keyLoginTime);
    if (timeStr == null) return null;
    return DateTime.tryParse(timeStr);
  }

  /// Mettre à jour uniquement l'access token (après refresh)
  Future<void> updateAccessToken(String accessToken) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
  }

  /// Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }

  /// Effacer toutes les données
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Effacer uniquement les tokens (garder les infos utilisateur)
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
    ]);
  }
}