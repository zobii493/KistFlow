class UserProfile {
  final String name;
  final String email;
  final String avatar;

  UserProfile({
    required this.name,
    required this.email,
    required this.avatar,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? avatar,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }
}