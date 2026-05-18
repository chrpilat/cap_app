import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/user_profile_data.dart';

class UserProfileRepository {
  UserProfileRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<UserProfileData?> getCurrentUserProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final row = await _client.from('users').select().eq('id', user.id).maybeSingle();
    if (row == null) {
      return UserProfileData(
        id: user.id,
        email: user.email ?? '',
        username: user.userMetadata?['username'] as String?,
        firstName: user.userMetadata?['first_name'] as String?,
        lastName: user.userMetadata?['last_name'] as String?,
        affiliation: user.userMetadata?['affiliation'] as String?,
        countryCode: user.userMetadata?['country_code'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
      );
    }

    return UserProfileData.fromMap({
      ...row,
      'id': row['id'] ?? user.id,
      'email': row['email'] ?? user.email ?? '',
    });
  }

  Future<void> addUserProfile(UserProfileData profile) async {
    await _client.from('users').upsert(profile.toMap(), onConflict: 'id');
  }

  Future<void> updateCurrentUserProfile({
    required String firstName,
    required String lastName,
    required String affiliation,
    required String countryCode,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;
    await _client.from('users').upsert({
      'id': user.id,
      'email': user.email,
      'first_name': firstName.trim(),
      'last_name': lastName.trim(),
      'affiliation': affiliation.trim(),
      'country_code': countryCode.trim(),
    }, onConflict: 'id');
  }

  Future<void> deleteCurrentUserProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return;
    await _client.from('users').delete().eq('id', user.id);
  }
}
