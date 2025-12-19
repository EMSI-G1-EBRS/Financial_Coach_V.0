import 'package:flutter/material.dart';

class GoalsStep extends StatefulWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const GoalsStep({
    super.key,
    required this.userData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<GoalsStep> createState() => _GoalsStepState();
}

class _GoalsStepState extends State<GoalsStep> {
  final List<String> _selectedGoals = [];

  final List<Map<String, dynamic>> _availableGoals = [
    {
      'id': 'emergency_fund',
      'label': 'Fonds d\'urgence',
      'description': 'Constituer une réserve pour les imprévus',
      'icon': Icons.medical_services,
    },
    {
      'id': 'retirement',
      'label': 'Retraite',
      'description': 'Préparer une retraite confortable',
      'icon': Icons.elderly,
    },
    {
      'id': 'home_purchase',
      'label': 'Achat immobilier',
      'description': 'Acheter une maison ou un appartement',
      'icon': Icons.home,
    },
    {
      'id': 'education',
      'label': 'Éducation',
      'description': 'Financer vos études ou celles de vos enfants',
      'icon': Icons.school,
    },
    {
      'id': 'investment',
      'label': 'Investissement',
      'description': 'Faire fructifier votre argent',
      'icon': Icons.trending_up,
    },
    {
      'id': 'debt_reduction',
      'label': 'Réduction de dettes',
      'description': 'Rembourser vos dettes rapidement',
      'icon': Icons.credit_card_off,
    },
    {
      'id': 'vacation',
      'label': 'Vacances',
      'description': 'Épargner pour des voyages',
      'icon': Icons.flight,
    },
    {
      'id': 'business',
      'label': 'Entreprise',
      'description': 'Créer ou développer une entreprise',
      'icon': Icons.business,
    },
    {
      'id': 'vehicle',
      'label': 'Véhicule',
      'description': 'Acheter une voiture',
      'icon': Icons.directions_car,
    },
    {
      'id': 'wealth_building',
      'label': 'Patrimoine',
      'description': 'Construire un patrimoine durable',
      'icon': Icons.account_balance,
    },
  ];

  @override
  void initState() {
    super.initState();
    final goals = widget.userData['financialGoals'] as List<String>?;
    if (goals != null) {
      _selectedGoals.addAll(goals);
    }
  }

  void _toggleGoal(String goalId) {
    setState(() {
      if (_selectedGoals.contains(goalId)) {
        _selectedGoals.remove(goalId);
      } else {
        _selectedGoals.add(goalId);
      }
    });
  }

  void _saveAndContinue() {
    if (_selectedGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner au moins un objectif financier'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    widget.userData['financialGoals'] = _selectedGoals;
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vos objectifs financiers',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Sélectionnez vos objectifs pour recevoir des conseils personnalisés',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_selectedGoals.length} objectif(s) sélectionné(s)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          // Grille d'objectifs
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: _availableGoals.length,
            itemBuilder: (context, index) {
              final goal = _availableGoals[index];
              final isSelected = _selectedGoals.contains(goal['id']);

              return InkWell(
                onTap: () => _toggleGoal(goal['id'] as String),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Icon(
                            goal['icon'] as IconData,
                            size: 48,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[600],
                          ),
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        goal['label'] as String,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        goal['description'] as String,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Boutons navigation
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  child: const Text('Retour'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveAndContinue,
                  child: const Text('Suivant'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
