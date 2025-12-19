import 'package:flutter/foundation.dart';
import 'package:projects/models/auth_response.dart';
import 'package:projects/models/user.dart';
import 'package:projects/services/auth_service.dart';
import 'package:projects/services/secure_storage_service.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Provider pour gérer l'état d'authentification
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final SecureStorageService _storageService;

  AuthProvider({
    required AuthService authService,
    required SecureStorageService storageService,
  })  : _authService = authService,
        _storageService = storageService;

  // État privé
  AuthState _state = AuthState.initial;
  User? _currentUser;
  String? _errorMessage;
  DateTime? _loginTime;

  // Getters publics
  AuthState get state => _state;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;

  /// Initialiser l'état d'authentification au démarrage de l'app
  Future<void> initialize() async {
    _setState(AuthState.loading);

    try {
      final isLoggedIn = await _storageService.isLoggedIn();
      
      if (isLoggedIn) {
        final userId = await _storageService.getUserId();
        final email = await _storageService.getUserEmail();
        _loginTime = await _storageService.getLoginTime();

        if (userId != null && email != null) {
          _currentUser = User(
            id: userId,
            email: email,
            roles: ['ROLE_USER'], // Vous pouvez stocker les rôles aussi
          );
          _setState(AuthState.authenticated);
          return;
        }
      }

      _setState(AuthState.unauthenticated);
    } catch (e) {
      _setError('Erreur d\'initialisation: $e');
    }
  }

  /// Inscription
  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _setState(AuthState.loading);
    _errorMessage = null;

    try {
      final authResponse = await _authService.register(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      await _saveAuthData(authResponse);
      _setState(AuthState.authenticated);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Connexion
  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setState(AuthState.loading);
    _errorMessage = null;

    try {
      final authResponse = await _authService.login(
        email: email,
        password: password,
      );

      await _saveAuthData(authResponse);
      _setState(AuthState.authenticated);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Rafraîchir le token
  Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      
      if (refreshToken == null) {
        await logout();
        return false;
      }

      final authResponse = await _authService.refreshToken(
        refreshToken: refreshToken,
      );

      await _storageService.updateAccessToken(authResponse.accessToken);
      _loginTime = DateTime.now();
      
      return true;
    } catch (e) {
      debugPrint('Erreur de rafraîchissement du token: $e');
      await logout();
      return false;
    }
  }

  /// Vérifier si le token doit être rafraîchi
  Future<bool> shouldRefreshToken() async {
    if (_loginTime == null) return false;
    
    final accessToken = await _storageService.getAccessToken();
    if (accessToken == null) return false;

    // Rafraîchir si le token expire dans moins de 5 minutes
    final now = DateTime.now();
    final expirationTime = _loginTime!.add(const Duration(hours: 1));
    final timeUntilExpiry = expirationTime.difference(now);
    
    return timeUntilExpiry.inMinutes < 5;
  }

  /// Déconnexion
  Future<void> logout() async {
    _setState(AuthState.loading);

    try {
      final refreshToken = await _storageService.getRefreshToken();
      
      if (refreshToken != null) {
        await _authService.logout(refreshToken: refreshToken);
      }
    } catch (e) {
      debugPrint('Erreur lors de la déconnexion: $e');
    } finally {
      await _storageService.clearAll();
      _currentUser = null;
      _loginTime = null;
      _setState(AuthState.unauthenticated);
    }
  }

  /// Sauvegarder les données d'authentification
  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await _storageService.saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      userId: authResponse.userId,
      email: authResponse.email,
    );

    _currentUser = User(
      id: authResponse.userId,
      email: authResponse.email,
      roles: authResponse.roles,
    );

    _loginTime = DateTime.now();
  }

  /// Changer l'état
  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Définir une erreur
  void _setError(String error) {
    _errorMessage = error;
    _state = AuthState.error;
    notifyListeners();
  }

  /// Effacer l'erreur
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Récupérer l'access token actuel
  Future<String?> getAccessToken() async {
    // Vérifier si le token doit être rafraîchi
    if (await shouldRefreshToken()) {
      final refreshed = await refreshAccessToken();
      if (!refreshed) return null;
    }
    
    return await _storageService.getAccessToken();
  }
}