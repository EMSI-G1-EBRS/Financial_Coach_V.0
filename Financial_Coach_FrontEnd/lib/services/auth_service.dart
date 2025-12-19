import 'package:dio/dio.dart';
import '../models/auth_response.dart';

/// Service d'authentification pour communiquer avec l'API Backend
class AuthService {
  final Dio _dio;
  final String baseUrl;

  AuthService({
    required this.baseUrl,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  /// Inscription d'un nouvel utilisateur
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );

      if (response.statusCode == 201) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de l\'inscription');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Connexion d'un utilisateur
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors de la connexion');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Rafraîchir l'access token
  Future<AuthResponse> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await _dio.post(
        '/refresh',
        data: {
          'refreshToken': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw Exception('Erreur lors du rafraîchissement du token');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Déconnexion
  Future<void> logout({
    required String refreshToken,
  }) async {
    try {
      await _dio.post(
        '/logout',
        data: {
          'refreshToken': refreshToken,
        },
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Health check
  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Gestion des erreurs Dio
  String _handleDioError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      
      // Si l'API retourne un message d'erreur
      if (data is Map<String, dynamic>) {
        if (data.containsKey('message')) {
          return data['message'] as String;
        }
        if (data.containsKey('error')) {
          return data['error'] as String;
        }
      }

      // Erreurs HTTP standards
      switch (error.response!.statusCode) {
        case 400:
          return 'Données invalides';
        case 401:
          return 'Email ou mot de passe incorrect';
        case 403:
          return 'Accès refusé';
        case 404:
          return 'Service non disponible';
        case 500:
          return 'Erreur serveur';
        default:
          return 'Une erreur est survenue';
      }
    }

    // Erreurs de connexion
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Délai de connexion dépassé';
    }

    if (error.type == DioExceptionType.unknown) {
      return 'Impossible de se connecter au serveur';
    }

    return 'Une erreur est survenue';
  }
}