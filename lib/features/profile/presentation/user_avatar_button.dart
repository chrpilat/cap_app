import 'package:flutter/material.dart';

import '../model/user_profile_data.dart';
import '../repository/user_profile_repository.dart';
import 'user_profile_dialog.dart';

class UserAvatarButton extends StatefulWidget {
  const UserAvatarButton({super.key});

  @override
  State<UserAvatarButton> createState() => _UserAvatarButtonState();
}

class _UserAvatarButtonState extends State<UserAvatarButton> {
  final _profileRepository = UserProfileRepository();
  late Future<UserProfileData?> _profileFuture = _loadProfile();

  Future<UserProfileData?> _loadProfile() async {
    try {
      return await _profileRepository.getCurrentUserProfile();
    } catch (error) {
      debugPrint('Profile load error: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfileData?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        final profile = snapshot.data;
        return IconButton(
          tooltip: 'Open profile',
          onPressed: () async {
            final updated = await showDialog<bool>(
              context: context,
              builder: (_) => UserProfileDialog(profileFuture: _profileFuture),
            );
            if (updated == true && mounted) {
              setState(() {
                _profileFuture = _loadProfile();
              });
            }
          },
          icon: CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF0B1F3B),
            backgroundImage:
                profile?.avatarUrl != null &&
                    profile!.avatarUrl!.trim().isNotEmpty
                ? NetworkImage(profile.avatarUrl!)
                : null,
            child:
                profile == null || (profile.avatarUrl?.trim().isEmpty ?? true)
                ? Text(
                    _initialsFromProfile(profile),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }

  String _initialsFromProfile(UserProfileData? profile) {
    final source =
        (profile?.fullName.trim().isNotEmpty ?? false)
            ? profile!.fullName
            : profile?.email ?? 'U';
    final parts = source.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return source.substring(0, 1).toUpperCase();
  }
}
