/// Immutable domain model for the current user's profile.
class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  final String name;
  final String email;
  final String? avatarUrl;

  UserProfile copyWith({String? name, String? email, String? avatarUrl}) =>
      UserProfile(
        name: name ?? this.name,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );
}
