import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import 'secure_storage_service.dart';

class ProfileService {
  final Dio _dio;
  final String baseUrl;
  final SecureStorageService _storageService;

  ProfileService({
    required this.baseUrl,
    required SecureStorageService storageService,
  })  : _storageService = storageService,
        _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
          },
        )) {
    // Intercepteur pour ajouter le token d'authentification
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          debugPrint('ProfileService Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  /// Récupérer le profil de l'utilisateur
  Future<UserProfile?> getProfile() async {
    try {
      // Vérifier si un token est disponible
      final token = await _storageService.getAccessToken();
      if (token == null) {
        debugPrint('Pas de token disponible, skip backend sync');
        return null;
      }

      final response = await _dio.get('/profile');
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Profil n'existe pas encore
        return null;
      }
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        // Non authentifié ou non autorisé
        debugPrint('Non authentifié, skip backend sync');
        return null;
      }
      debugPrint('Erreur lors de la récupération du profil: ${e.message}');
      return null; // Ne pas rethrow pour éviter les erreurs au démarrage
    }
  }

  /// Créer un nouveau profil
  Future<UserProfile> createProfile(UserProfile profile) async {
    try {
      final response = await _dio.post(
        '/profile',
        data: profile.toJson(),
      );
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Erreur lors de la création du profil: ${e.message}');
      rethrow;
    }
  }

  /// Mettre à jour le profil
  Future<UserProfile> updateProfile(UserProfile profile) async {
    try {
      final response = await _dio.put(
        '/profile',
        data: profile.toJson(),
      );
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Erreur lors de la mise à jour du profil: ${e.message}');
      rethrow;
    }
  }

  /// Supprimer le profil
  Future<void> deleteProfile() async {
    try {
      await _dio.delete('/profile');
    } on DioException catch (e) {
      debugPrint('Erreur lors de la suppression du profil: ${e.message}');
      rethrow;
    }
  }

  /// Vérifier si un profil existe
  Future<bool> hasProfile() async {
    try {
      // Vérifier si un token est disponible
      final token = await _storageService.getAccessToken();
      if (token == null) {
        return false;
      }

      final response = await _dio.get('/profile/exists');
      return response.data as bool;
    } on DioException catch (e) {
      debugPrint('Erreur lors de la vérification du profil: ${e.message}');
      return false;
    }
  }
}
