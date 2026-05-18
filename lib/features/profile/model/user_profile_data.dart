class UserProfileData {
  const UserProfileData({
    required this.id,
    required this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.affiliation,
    this.countryCode,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? affiliation;
  final String? countryCode;
  final String? avatarUrl;

  String get fullName {
    final first = firstName?.trim() ?? '';
    final last = lastName?.trim() ?? '';
    final value = '$first $last'.trim();
    return value;
  }

  factory UserProfileData.fromMap(Map<String, dynamic> map) {
    return UserProfileData(
      id: (map['id'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      username: map['username'] as String?,
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
      affiliation: map['affiliation'] as String?,
      countryCode: map['country_code'] as String?,
      avatarUrl: map['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'affiliation': affiliation,
      'country_code': countryCode,
      'avatar_url': avatarUrl,
    };
  }
}
