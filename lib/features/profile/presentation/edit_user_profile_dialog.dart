import 'package:flutter/material.dart';

import '../model/country_option.dart';
import '../model/user_profile_data.dart';
import '../repository/user_profile_repository.dart';

class EditUserProfileDialog extends StatefulWidget {
  const EditUserProfileDialog({required this.profile, super.key});

  final UserProfileData profile;

  @override
  State<EditUserProfileDialog> createState() => _EditUserProfileDialogState();
}

class _EditUserProfileDialogState extends State<EditUserProfileDialog> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _affiliationController = TextEditingController();
  final _profileRepository = UserProfileRepository();
  String? _selectedCountryCode;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.profile.firstName ?? '';
    _lastNameController.text = widget.profile.lastName ?? '';
    _affiliationController.text = widget.profile.affiliation ?? '';
    _selectedCountryCode = findCountryByCode(widget.profile.countryCode)?.code;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _affiliationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _affiliationController.text.trim().isEmpty ||
        _selectedCountryCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill in all fields and select a country.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _profileRepository.updateCurrentUserProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        affiliation: _affiliationController.text,
        countryCode: _selectedCountryCode!,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profile update error: $error')));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Edit profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Main affiliation must be the one associated with ${widget.profile.email}.',
                style: const TextStyle(fontSize: 12, color: Color(0xFF4A5568)),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _firstNameController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'First name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _lastNameController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Last name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _affiliationController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Main affiliation',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCountryCode,
                items: kCountryOptions
                    .map(
                      (country) => DropdownMenuItem<String>(
                        value: country.code,
                        child: Text('${country.flag} ${country.name}'),
                      ),
                    )
                    .toList(),
                onChanged: _isSaving
                    ? null
                    : (value) => setState(() => _selectedCountryCode = value),
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
