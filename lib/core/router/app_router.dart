import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/features/home/screens/home_screen.dart';
import 'package:flutter_app/features/profile/screens/profile_screen.dart';

/// Centralised navigation registry using [GoRouter].
///
/// Benefits over Navigator 1.0:
/// - Type-safe route paths as constants
/// - Deep link support out of the box
/// - Guard / redirect hooks (e.g. auth check before profile)
/// - URL-driven navigation (useful for web/desktop targets)
abstract final class AppRouter {
  // ─── Route paths ──────────────────────────────────────────────────────────
  static const home = '/';
  static const profile = '/profile';

  // ─── Router instance ──────────────────────────────────────────────────────
  static final router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );

  // ─── Navigation helpers ───────────────────────────────────────────────────

  /// Push the profile screen onto the navigation stack.
  static void toProfile(BuildContext context) => context.push(profile);

  /// Go back to the previous screen.
  static void back(BuildContext context) => context.pop();
}
