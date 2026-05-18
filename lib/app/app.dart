import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/presentation/auth_gate.dart';
import '../features/filters/presentation/filters_panel.dart';
import '../features/profile/model/user_profile_data.dart';
import '../features/profile/repository/user_profile_repository.dart';
import '../features/search/presentation/search_results_panel.dart';

class ConferenceArchivePlatformApp extends StatelessWidget {
  const ConferenceArchivePlatformApp({
    required this.hasSupabaseConfig,
    super.key,
  });

  final bool hasSupabaseConfig;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conference Archive Platform',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B1F3B)),
        fontFamily: 'Manrope',
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: EntryScreen(hasSupabaseConfig: hasSupabaseConfig),
    );
  }
}

class EntryScreen extends StatelessWidget {
  const EntryScreen({required this.hasSupabaseConfig, super.key});

  final bool hasSupabaseConfig;

  @override
  Widget build(BuildContext context) {
    if (!hasSupabaseConfig) {
      return const MissingSupabaseConfigScreen();
    }
    return const AuthGate();
  }
}

class MissingSupabaseConfigScreen extends StatelessWidget {
  const MissingSupabaseConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Set SUPABASE_URL and SUPABASE_ANON_KEY in main.dart to enable login.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF0B1F3B);
    const seaBlue = Color(0xFF0D7EA2);

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    const UserAvatarButton(),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Conference Archive Platform',
                        style: TextStyle(
                          color: darkBlue,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.upload_file_outlined,
                            size: 18,
                          ),
                          label: const Text('Import CSV'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: darkBlue,
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: darkBlue, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download_outlined, size: 18),
                          label: const Text('Export CSV'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: darkBlue,
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: darkBlue, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.groups_2_outlined, size: 18),
                          label: const Text('TPC Members'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: seaBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(height: 1.5, color: const Color(0xFF8A95A6)),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: FiltersPanel(),
                  ),
                ),
                SizedBox(
                  width: 1.5,
                  child: ColoredBox(color: Color(0xFFD1D8E0)),
                ),
                Expanded(flex: 3, child: SearchResultsPanel()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserAvatarButton extends StatefulWidget {
  const UserAvatarButton({super.key});

  @override
  State<UserAvatarButton> createState() => _UserAvatarButtonState();
}

class _UserAvatarButtonState extends State<UserAvatarButton> {
  final _profileRepository = UserProfileRepository();
  late final Future<UserProfileData?> _profileFuture = _loadProfile();

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
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (_) => UserProfileDialog(profileFuture: _profileFuture),
            );
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
    final source = profile?.fullName?.trim().isNotEmpty == true
        ? profile!.fullName!
        : profile?.email ?? 'U';
    final parts = source.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return source.substring(0, 1).toUpperCase();
  }
}

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
                  _ProfileRow(
                    label: 'Full name',
                    value: profile.fullName ?? '-',
                  ),
                  _ProfileRow(
                    label: 'Username',
                    value: profile.username ?? '-',
                  ),
                  _ProfileRow(label: 'Email', value: profile.email),
                  _ProfileRow(label: 'User ID', value: profile.id),
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
    final source = profile.fullName?.trim().isNotEmpty == true
        ? profile.fullName!
        : profile.email;
    final parts = source.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return source.substring(0, 1).toUpperCase();
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
