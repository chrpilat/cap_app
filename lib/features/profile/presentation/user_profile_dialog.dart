import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/user_profile_data.dart';
import 'country_profile_row.dart';
import 'edit_user_profile_dialog.dart';
import 'profile_row.dart';

class UserProfileDialog extends StatelessWidget {
  const UserProfileDialog({required this.profileFuture, super.key});

  final Future<UserProfileData?> profileFuture;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<UserProfileData?>(
            future: profileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final profile = snapshot.data;
              if (profile == null) {
                return const SizedBox(
                  height: 140,
                  child: Center(child: Text('No user profile available.')),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF0B1F3B),
                        backgroundImage:
                            profile.avatarUrl != null &&
                                profile.avatarUrl!.trim().isNotEmpty
                            ? NetworkImage(profile.avatarUrl!)
                            : null,
                        child:
                            profile.avatarUrl == null ||
                                profile.avatarUrl!.trim().isEmpty
                            ? Text(
                                _initials(profile),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'User profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ProfileRow(label: 'First name', value: profile.firstName ?? '-'),
                  ProfileRow(label: 'Last name', value: profile.lastName ?? '-'),
                  ProfileRow(
                    label: 'Main affiliation',
                    value: profile.affiliation ?? '-',
                  ),
                  CountryProfileRow(countryCode: profile.countryCode),
                  ProfileRow(label: 'Email', value: profile.email),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (_) => EditUserProfileDialog(profile: profile),
                      );
                      if (context.mounted && result == true) {
                        Navigator.of(context).pop(true);
                      }
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit profile'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Supabase.instance.client.auth.signOut();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _initials(UserProfileData profile) {
    final source = profile.fullName.trim().isNotEmpty
        ? profile.fullName
        : profile.email;
    final parts = source.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return source.substring(0, 1).toUpperCase();
  }
}
