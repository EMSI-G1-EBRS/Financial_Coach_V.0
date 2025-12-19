import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/avatar_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<UserProfileProvider>(
          builder: (context, profileProvider, _) {
            final profile = profileProvider.profile;
            final userName = profile?.fullName ?? 'User Name';

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Header with back button and title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: const Text(
                            'Profil',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // Balance the back button
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Divider
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 1,
                    color: const Color(0xFFE6E6E6),
                  ),

                  const SizedBox(height: 26),

                  // Profile Avatar
                  Consumer<AvatarProvider>(
                    builder: (context, avatarProvider, _) {
                      return Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 3, 63, 130),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: avatarProvider.avatarColor.withAlpha(77),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          avatarProvider.avatarIcon,
                          size: 50,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // User Name
                  Text(
                    userName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xDD1C1A1A),
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Settings Section
                  _buildSectionHeader('Settings'),
                  _buildMenuItem(
                    context,
                    title: 'Language',
                    icon: Icons.language,
                    onTap: () => Navigator.of(context).pushNamed('/language'),
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Settings',
                    icon: Icons.settings,
                    onTap: () => Navigator.of(context).pushNamed('/settings'),
                  ),

                  const SizedBox(height: 20),

                  // Profile Configuration Section
                  _buildSectionHeader('Configuration Profil'),
                  _buildMenuItem(
                    context,
                    title: 'Voir les détails du profil',
                    icon: Icons.person_outline,
                    onTap: () => _showProfileDetailsDialog(context, profileProvider),
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Modifier le profil',
                    icon: Icons.edit,
                    onTap: () => Navigator.of(context).pushNamed('/onboarding'),
                  ),

                  const SizedBox(height: 20),

                  // Account Section
                  _buildSectionHeader('Account'),
                  _buildMenuItem(
                    context,
                    title: 'Change account Image',
                    icon: Icons.camera_alt,
                    onTap: () => Navigator.of(context).pushNamed('/change-image'),
                  ),

                  const SizedBox(height: 20),

                  // WealthPath Section
                  _buildSectionHeader('WealthPath'),
                  _buildMenuItem(
                    context,
                    title: 'About US',
                    icon: Icons.info_outline,
                    onTap: () => Navigator.of(context).pushNamed('/about'),
                  ),
                  _buildMenuItem(
                    context,
                    title: 'FAQ',
                    icon: Icons.help_outline,
                    onTap: () => Navigator.of(context).pushNamed('/faq'),
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Help & Feedback',
                    icon: Icons.feedback_outlined,
                    onTap: () => Navigator.of(context).pushNamed('/help-feedback'),
                  ),
                  _buildMenuItem(
                    context,
                    title: 'Support US',
                    icon: Icons.favorite_border,
                    onTap: () => Navigator.of(context).pushNamed('/support'),
                  ),

                  const SizedBox(height: 20),

                  // Log out
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () => _showLogoutDialog(context),
                      child: Row(
                        children: [
                          Container(
                            width: 26,
                            height: 27,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF4949),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Log out',
                            style: TextStyle(
                              color: Color(0xFFFF4949),
                              fontSize: 16,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFAFAFAF),
            fontSize: 14,
            fontFamily: 'Lato',
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 27,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.87),
                    fontSize: 16,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileDetailsDialog(BuildContext context, UserProfileProvider profileProvider) {
    final profile = profileProvider.profile;
    final summary = profileProvider.getProfileSummary();

    if (profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun profil disponible')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Détails du Profil',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Completeness Card
                  _buildCompletenessCard(context, summary),
                  const SizedBox(height: 20),

                  // Personal Information
                  _buildDialogSection(context, 'Informations personnelles'),
                  _buildDetailItem(context, Icons.person, 'Nom complet', profile.fullName ?? 'Non renseigné'),
                  _buildDetailItem(context, Icons.email, 'Email', profile.email ?? 'Non renseigné'),
                  _buildDetailItem(context, Icons.cake, 'Âge', profile.age?.toString() ?? 'Non renseigné'),
                  _buildDetailItem(context, Icons.work, 'Profession', profile.occupation ?? 'Non renseigné'),
                  _buildDetailItem(
                    context,
                    Icons.location_on,
                    'Localisation',
                    profile.city != null && profile.country != null
                        ? '${profile.city}, ${profile.country}'
                        : 'Non renseigné',
                  ),
                  const SizedBox(height: 16),

                  // Financial Information
                  _buildDialogSection(context, 'Informations financières'),
                  _buildDetailItem(
                    context,
                    Icons.euro,
                    'Revenu mensuel',
                    profile.monthlyIncome != null
                        ? '${profile.monthlyIncome!.toStringAsFixed(2)} ${profile.currency}'
                        : 'Non renseigné',
                  ),
                  _buildDetailItem(
                    context,
                    Icons.savings,
                    'Épargne mensuelle',
                    profile.monthlySavings != null
                        ? '${profile.monthlySavings!.toStringAsFixed(2)} ${profile.currency}'
                        : 'Non renseigné',
                  ),
                  if (profile.savingsRate != null)
                    _buildDetailItem(
                      context,
                      Icons.percent,
                      'Taux d\'épargne',
                      '${profile.savingsRate!.toStringAsFixed(1)}%',
                    ),
                  _buildDetailItem(
                    context,
                    Icons.security,
                    'Tolérance au risque',
                    _getRiskToleranceLabel(profile.riskTolerance),
                  ),
                  const SizedBox(height: 16),

                  // Financial Goals
                  _buildDialogSection(context, 'Objectifs financiers'),
                  if (profile.financialGoals.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Aucun objectif défini'),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: profile.financialGoals
                          .map((goal) => Chip(
                                label: Text(_formatGoalLabel(goal)),
                                avatar: const Icon(Icons.flag, size: 16),
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: 16),

                  // Preferences
                  _buildDialogSection(context, 'Préférences'),
                  _buildDetailItem(
                    context,
                    Icons.language,
                    'Langue',
                    _getLanguageLabel(profile.preferredLanguage),
                  ),
                  _buildDetailItem(
                    context,
                    Icons.attach_money,
                    'Devise',
                    profile.currency ?? 'EUR',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletenessCard(BuildContext context, Map<String, dynamic> summary) {
    final completeness = summary['completeness'] as int;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profil',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '$completeness%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: completeness / 100,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 8),
            Text(
              summary['message'] as String,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogSection(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRiskToleranceLabel(String? risk) {
    switch (risk) {
      case 'low':
        return 'Faible';
      case 'medium':
        return 'Modéré';
      case 'high':
        return 'Élevé';
      default:
        return 'Non renseigné';
    }
  }

  String _getLanguageLabel(String? lang) {
    switch (lang) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'ar':
        return 'العربية';
      default:
        return lang ?? 'Non renseigné';
    }
  }

  String _formatGoalLabel(String goal) {
    final Map<String, String> goalLabels = {
      'emergency_fund': 'Fonds d\'urgence',
      'retirement': 'Retraite',
      'home_purchase': 'Achat immobilier',
      'education': 'Éducation',
      'investment': 'Investissement',
      'debt_reduction': 'Réduction de dettes',
      'vacation': 'Vacances',
      'business': 'Entreprise',
      'vehicle': 'Véhicule',
      'wealth_building': 'Patrimoine',
    };
    return goalLabels[goal] ?? goal;
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFFF4949)),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}
