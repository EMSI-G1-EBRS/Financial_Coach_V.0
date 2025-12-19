import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonalInfoStep extends StatefulWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onNext;

  const PersonalInfoStep({
    super.key,
    required this.userData,
    required this.onNext,
  });

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _occupationController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userData['fullName'] ?? '';
    _ageController.text = widget.userData['age']?.toString() ?? '';
    _occupationController.text = widget.userData['occupation'] ?? '';
    _countryController.text = widget.userData['country'] ?? '';
    _cityController.text = widget.userData['city'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      widget.userData['fullName'] = _nameController.text.trim();
      widget.userData['age'] = int.parse(_ageController.text.trim());
      widget.userData['occupation'] = _occupationController.text.trim();
      widget.userData['country'] = _countryController.text.trim();
      widget.userData['city'] = _cityController.text.trim();

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
              'Informations personnelles',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Parlez-nous un peu de vous pour personnaliser votre expérience',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 32),

            // Nom complet
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom complet',
                hintText: 'Jean Dupont',
                prefixIcon: Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer votre nom';
                }
                if (value.trim().length < 2) {
                  return 'Le nom doit contenir au moins 2 caractères';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Âge
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Âge',
                hintText: '25',
                prefixIcon: Icon(Icons.cake),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer votre âge';
                }
                final age = int.tryParse(value.trim());
                if (age == null || age < 18 || age > 120) {
                  return 'Veuillez entrer un âge valide (18-120)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Profession
            TextFormField(
              controller: _occupationController,
              decoration: const InputDecoration(
                labelText: 'Profession',
                hintText: 'Ingénieur logiciel',
                prefixIcon: Icon(Icons.work),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer votre profession';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Pays
            TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Pays',
                hintText: 'France',
                prefixIcon: Icon(Icons.flag),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer votre pays';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Ville
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Ville',
                hintText: 'Paris',
                prefixIcon: Icon(Icons.location_city),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer votre ville';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Bouton suivant
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAndContinue,
                child: const Text('Suivant'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
