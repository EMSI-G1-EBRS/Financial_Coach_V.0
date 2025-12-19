import 'package:flutter/material.dart';

class PreferencesStep extends StatefulWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onComplete;
  final VoidCallback onBack;

  const PreferencesStep({
    super.key,
    required this.userData,
    required this.onComplete,
    required this.onBack,
  });

  @override
  State<PreferencesStep> createState() => _PreferencesStepState();
}

class _PreferencesStepState extends State<PreferencesStep> {
  String _selectedLanguage = 'fr';
  String _selectedCurrency = 'EUR';

  final List<Map<String, String>> _languages = [
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇲🇦'},
  ];

  final List<Map<String, String>> _currencies = [
    {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
    {'code': 'USD', 'name': 'Dollar US', 'symbol': '\$'},
    {'code': 'GBP', 'name': 'Livre Sterling', 'symbol': '£'},
    {'code': 'MAD', 'name': 'Dirham Marocain', 'symbol': 'DH'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.userData['preferredLanguage'] ?? 'fr';
    _selectedCurrency = widget.userData['currency'] ?? 'EUR';
  }

  void _saveAndComplete() {
    widget.userData['preferredLanguage'] = _selectedLanguage;
    widget.userData['currency'] = _selectedCurrency;
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Préférences',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Dernière étape ! Personnalisez votre expérience',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 32),

          // Langue préférée
          Text(
            'Langue préférée',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          ..._languages.map((language) {
            final isSelected = _selectedLanguage == language['code'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedLanguage = language['code']!;
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
                            .withValues(alpha: 0.1)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Text(
                        language['flag']!,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          language['name']!,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                  ),
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

          // Devise
          Text(
            'Devise',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          ..._currencies.map((currency) {
            final isSelected = _selectedCurrency == currency['code'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedCurrency = currency['code']!;
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
                            .withValues(alpha: 0.1)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            currency['symbol']!,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currency['name']!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                  ),
                            ),
                            Text(
                              currency['code']!,
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

          // Message de fin
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.celebration,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Félicitations !',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Vous êtes prêt à commencer votre parcours financier personnalisé',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                flex: 2,
                child: ElevatedButton(
                  onPressed: _saveAndComplete,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Terminer'),
                      SizedBox(width: 8),
                      Icon(Icons.check, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
