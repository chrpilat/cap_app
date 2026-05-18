class UserProfileData {
  const UserProfileData({
    required this.id,
    required this.email,
    this.username,
    this.fullName,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String? username;
  final String? fullName;
  final String? avatarUrl;

  factory UserProfileData.fromMap(Map<String, dynamic> map) {
    return UserProfileData(
      id: (map['id'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      username: map['username'] as String?,
      fullName: map['full_name'] as String?,
      avatarUrl: map['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'full_name': fullName,
      'avatar_url': avatarUrl,
    };
  }
}
