import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_profile_provider.dart';
import '../../providers/auth_provider.dart';
import 'steps/personal_info_step.dart';
import 'steps/financial_info_step.dart';
import 'steps/goals_step.dart';
import 'steps/preferences_step.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  // Controllers pour les données
  final Map<String, dynamic> _userData = {};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final profileProvider = context.read<UserProfileProvider>();
    final authProvider = context.read<AuthProvider>();

    try {
      // Créer un profil si nécessaire
      if (!profileProvider.hasProfile) {
        final userId = authProvider.currentUser?.id ?? 'temp_user_${DateTime.now().millisecondsSinceEpoch}';
        final email = authProvider.currentUser?.email ?? '';
        await profileProvider.createProfile(userId, email);
      }

      // Mise à jour des informations personnelles
      await profileProvider.updatePersonalInfo(
        fullName: _userData['fullName'],
        age: _userData['age'],
        occupation: _userData['occupation'],
        country: _userData['country'],
        city: _userData['city'],
      );

      // Mise à jour des informations financières
      await profileProvider.updateFinancialInfo(
        monthlyIncome: _userData['monthlyIncome'],
        monthlySavings: _userData['monthlySavings'],
        financialGoals: _userData['financialGoals'],
        riskTolerance: _userData['riskTolerance'],
      );

      // Mise à jour des préférences
      await profileProvider.updatePreferences(
        preferredLanguage: _userData['preferredLanguage'],
        currency: _userData['currency'],
      );

      // Marquer l'onboarding comme terminé
      await profileProvider.completeOnboarding();

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration du profil'),
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousPage,
              )
            : null,
      ),
      body: Column(
        children: [
          // Indicateur de progression
          LinearProgressIndicator(
            value: (_currentPage + 1) / _totalPages,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Étape ${_currentPage + 1} sur $_totalPages',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${(((_currentPage + 1) / _totalPages) * 100).round()}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),

          // Contenu des pages
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                PersonalInfoStep(
                  userData: _userData,
                  onNext: _nextPage,
                ),
                FinancialInfoStep(
                  userData: _userData,
                  onNext: _nextPage,
                  onBack: _previousPage,
                ),
                GoalsStep(
                  userData: _userData,
                  onNext: _nextPage,
                  onBack: _previousPage,
                ),
                PreferencesStep(
                  userData: _userData,
                  onComplete: _completeOnboarding,
                  onBack: _previousPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
