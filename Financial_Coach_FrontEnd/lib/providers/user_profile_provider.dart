import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_profile.dart';
import '../services/profile_service.dart';

class UserProfileProvider extends ChangeNotifier {
  static const String _profileKey = 'user_profile';
  UserProfile? _profile;
  bool _isLoading = false;
  ProfileService? _profileService;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get hasProfile => _profile != null;
  bool get hasCompletedOnboarding =>
      _profile?.hasCompletedOnboarding ?? false;

  // Initialiser le service de profil
  void initializeService(ProfileService profileService) {
    _profileService = profileService;
  }

  // Charger le profil (local d'abord, puis synchroniser avec le backend)
  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Charger depuis le stockage local
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);

      if (profileJson != null) {
        final Map<String, dynamic> data = json.decode(profileJson);
        _profile = UserProfile.fromJson(data);
        notifyListeners();
      }

      // 2. Synchroniser avec le backend si le service est initialisé
      if (_profileService != null) {
        try {
          final backendProfile = await _profileService!.getProfile();
          if (backendProfile != null) {
            _profile = backendProfile;
            // Sauvegarder localement
            await _saveToLocal(backendProfile);
          }
        } catch (e) {
          debugPrint('Erreur de synchronisation avec le backend: $e');
          // On garde le profil local en cas d'erreur réseau
        }
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement du profil: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sauvegarder le profil (local + backend)
  Future<void> saveProfile(UserProfile profile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedProfile = profile.copyWith(
        updatedAt: DateTime.now(),
      );

      // 1. Sauvegarder localement
      await _saveToLocal(updatedProfile);

      // 2. Synchroniser avec le backend
      if (_profileService != null) {
        try {
          // Vérifier si le profil existe déjà
          final exists = await _profileService!.hasProfile();

          UserProfile backendProfile;
          if (exists) {
            backendProfile = await _profileService!.updateProfile(updatedProfile);
          } else {
            backendProfile = await _profileService!.createProfile(updatedProfile);
          }

          _profile = backendProfile;
          await _saveToLocal(backendProfile);
        } catch (e) {
          debugPrint('Erreur de synchronisation avec le backend: $e');
          // On garde la version locale en cas d'erreur
          _profile = updatedProfile;
        }
      } else {
        _profile = updatedProfile;
      }
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde du profil: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sauvegarder localement
  Future<void> _saveToLocal(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = json.encode(profile.toJson());
    await prefs.setString(_profileKey, profileJson);
  }

  // Créer un nouveau profil
  Future<void> createProfile(String userId, String email) async {
    final newProfile = UserProfile(
      userId: userId,
      email: email,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await saveProfile(newProfile);
  }

  // Mettre à jour les informations personnelles
  Future<void> updatePersonalInfo({
    String? fullName,
    int? age,
    String? occupation,
    String? country,
    String? city,
  }) async {
    if (_profile == null) return;

    final updatedProfile = _profile!.copyWith(
      fullName: fullName ?? _profile!.fullName,
      age: age ?? _profile!.age,
      occupation: occupation ?? _profile!.occupation,
      country: country ?? _profile!.country,
      city: city ?? _profile!.city,
    );

    await saveProfile(updatedProfile);
  }

  // Mettre à jour les informations financières
  Future<void> updateFinancialInfo({
    double? monthlyIncome,
    double? monthlySavings,
    List<String>? financialGoals,
    String? riskTolerance,
    Map<String, double>? budgetCategories,
  }) async {
    if (_profile == null) return;

    final updatedProfile = _profile!.copyWith(
      monthlyIncome: monthlyIncome ?? _profile!.monthlyIncome,
      monthlySavings: monthlySavings ?? _profile!.monthlySavings,
      financialGoals: financialGoals ?? _profile!.financialGoals,
      riskTolerance: riskTolerance ?? _profile!.riskTolerance,
      budgetCategories: budgetCategories ?? _profile!.budgetCategories,
    );

    await saveProfile(updatedProfile);
  }

  // Mettre à jour les préférences
  Future<void> updatePreferences({
    String? preferredLanguage,
    String? currency,
  }) async {
    if (_profile == null) return;

    final updatedProfile = _profile!.copyWith(
      preferredLanguage: preferredLanguage ?? _profile!.preferredLanguage,
      currency: currency ?? _profile!.currency,
    );

    await saveProfile(updatedProfile);
  }

  // Ajouter un objectif financier
  Future<void> addFinancialGoal(String goal) async {
    if (_profile == null) return;

    final updatedGoals = List<String>.from(_profile!.financialGoals)
      ..add(goal);

    await updateFinancialInfo(financialGoals: updatedGoals);
  }

  // Supprimer un objectif financier
  Future<void> removeFinancialGoal(String goal) async {
    if (_profile == null) return;

    final updatedGoals = List<String>.from(_profile!.financialGoals)
      ..remove(goal);

    await updateFinancialInfo(financialGoals: updatedGoals);
  }

  // Ajouter/Mettre à jour une catégorie de budget
  Future<void> updateBudgetCategory(String category, double amount) async {
    if (_profile == null) return;

    final updatedBudget = Map<String, double>.from(_profile!.budgetCategories)
      ..[category] = amount;

    await updateFinancialInfo(budgetCategories: updatedBudget);
  }

  // Supprimer une catégorie de budget
  Future<void> removeBudgetCategory(String category) async {
    if (_profile == null) return;

    final updatedBudget = Map<String, double>.from(_profile!.budgetCategories)
      ..remove(category);

    await updateFinancialInfo(budgetCategories: updatedBudget);
  }

  // Marquer l'onboarding comme terminé
  Future<void> completeOnboarding() async {
    if (_profile == null) return;

    final updatedProfile = _profile!.copyWith(
      hasCompletedOnboarding: true,
    );

    await saveProfile(updatedProfile);
  }

  // Supprimer le profil
  Future<void> deleteProfile() async {
    try {
      // 1. Supprimer du backend
      if (_profileService != null) {
        try {
          await _profileService!.deleteProfile();
        } catch (e) {
          debugPrint('Erreur lors de la suppression du profil backend: $e');
        }
      }

      // 2. Supprimer localement
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
      _profile = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de la suppression du profil: $e');
      rethrow;
    }
  }

  // Obtenir un résumé du profil pour affichage
  Map<String, dynamic> getProfileSummary() {
    if (_profile == null) {
      return {
        'completeness': 0,
        'message': 'Aucun profil disponible',
      };
    }

    int totalFields = 7; // Nombre de champs principaux
    int completedFields = 0;

    if (_profile!.fullName != null) completedFields++;
    if (_profile!.age != null) completedFields++;
    if (_profile!.occupation != null) completedFields++;
    if (_profile!.monthlyIncome != null) completedFields++;
    if (_profile!.monthlySavings != null) completedFields++;
    if (_profile!.financialGoals.isNotEmpty) completedFields++;
    if (_profile!.riskTolerance != null) completedFields++;

    int completeness = ((completedFields / totalFields) * 100).round();

    return {
      'completeness': completeness,
      'message': completeness == 100
          ? 'Profil complet'
          : 'Profil à $completeness% complet',
      'completedFields': completedFields,
      'totalFields': totalFields,
    };
  }
}
