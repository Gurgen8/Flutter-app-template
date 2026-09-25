import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/features/profile/models/user_profile.dart';

export 'package:flutter_app/features/profile/models/user_profile.dart';

// ─── Notifier ─────────────────────────────────────────────────────────────────

class ProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() => const UserProfile(
        name: 'Gurgen Mkrtchyan',
        email: 'gurgen@example.com',
        avatarUrl: null, // null = показываем иконку вместо фото
      );

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

final profileProvider = NotifierProvider<ProfileNotifier, UserProfile>(
  ProfileNotifier.new,
);
