import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinancialInfoStep extends StatefulWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const FinancialInfoStep({
    super.key,
    required this.userData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<FinancialInfoStep> createState() => _FinancialInfoStepState();
}

class _FinancialInfoStepState extends State<FinancialInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();
  final _savingsController = TextEditingController();
  String? _selectedRiskTolerance;

  final List<Map<String, dynamic>> _riskToleranceOptions = [
    {
      'value': 'low',
      'label': 'Faible',
      'description': 'Je préfère la sécurité et éviter les risques',
      'icon': Icons.shield,
    },
    {
      'value': 'medium',
      'label': 'Modéré',
      'description': 'Je suis prêt à prendre des risques calculés',
      'icon': Icons.balance,
    },
    {
      'value': 'high',
      'label': 'Élevé',
      'description': 'Je recherche des opportunités à fort potentiel',
      'icon': Icons.trending_up,
    },
  ];

  @override
  void initState() {
    super.initState();
    _incomeController.text = widget.userData['monthlyIncome']?.toString() ?? '';
    _savingsController.text =
        widget.userData['monthlySavings']?.toString() ?? '';
    _selectedRiskTolerance = widget.userData['riskTolerance'];
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _savingsController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRiskTolerance == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner votre tolérance au risque'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      widget.userData['monthlyIncome'] =
          double.parse(_incomeController.text.trim());
      widget.userData['monthlySavings'] =
          double.parse(_savingsController.text.trim());
      widget.userData['riskTolerance'] = _selectedRiskTolerance;

      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations financières',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Ces informations nous aident à personnaliser vos conseils financiers',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 32),

            // Revenu mensuel
            TextFormField(
              controller: _incomeController,
              decoration: const InputDecoration(
                labelText: 'Revenu mensuel (€)',
                hintText: '3000',
                prefixIcon: Icon(Icons.euro),
                helperText: 'Votre revenu mensuel net',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer votre revenu mensuel';
                }
                final income = double.tryParse(value.trim());
                if (income == null || income < 0) {
                  return 'Veuillez entrer un montant valide';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Épargne mensuelle
            TextFormField(
              controller: _savingsController,
              decoration: const InputDecoration(
                labelText: 'Épargne mensuelle (€)',
                hintText: '500',
                prefixIcon: Icon(Icons.savings),
                helperText: 'Montant que vous épargnez chaque mois',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer votre épargne mensuelle';
                }
                final savings = double.tryParse(value.trim());
                if (savings == null || savings < 0) {
                  return 'Veuillez entrer un montant valide';
                }

                final income = double.tryParse(_incomeController.text.trim());
                if (income != null && savings > income) {
                  return 'L\'épargne ne peut pas dépasser le revenu';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Tolérance au risque
            Text(
              'Tolérance au risque',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Comment vous sentez-vous par rapport au risque financier ?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),

            // Options de tolérance au risque
            ..._riskToleranceOptions.map((option) {
              final isSelected = _selectedRiskTolerance == option['value'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedRiskTolerance = option['value'] as String;
                    });
                  },
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
                              .withOpacity(0.1)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          option['icon'] as IconData,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[600],
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option['label'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                option['description'] as String,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),

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
      ),
    );
  }
}
