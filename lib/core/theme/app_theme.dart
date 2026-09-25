import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralised design system — single source of truth for colours,
/// typography and component defaults.
abstract final class AppTheme {
  // ─── Palette ──────────────────────────────────────────────────────────────
  static const primary = Color(0xFF6C63FF);
  static const primaryLight = Color(0xFF9C94FF);
  static const secondary = Color(0xFFFF6584);
  static const accent = Color(0xFF43E97B);
  static const bgDark = Color(0xFF0F0F1A);
  static const bgCard = Color(0xFF1A1A2E);
  static const bgCardLight = Color(0xFF252540);
  static const textPrimary = Color(0xFFF5F5FF);
  static const textSecondary = Color(0xFF9898B8);

  // ─── Gradients ────────────────────────────────────────────────────────────
  static const primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF9C44FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const avatarGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Shadows ──────────────────────────────────────────────────────────────
  static List<BoxShadow> primaryShadow(double opacity) => [
        BoxShadow(
          color: primary.withValues(alpha: opacity),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  // ─── Theme ────────────────────────────────────────────────────────────────
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: bgCard,
        onPrimary: Colors.white,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
            color: textPrimary, fontWeight: FontWeight.w800),
        headlineMedium: GoogleFonts.inter(
            color: textPrimary, fontWeight: FontWeight.w800),
        titleLarge: GoogleFonts.inter(
            color: textPrimary, fontWeight: FontWeight.w700),
        titleMedium: GoogleFonts.inter(
            color: textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: textPrimary),
        bodyMedium: GoogleFonts.inter(color: textSecondary),
        bodySmall: GoogleFonts.inter(color: textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
    );
  }
}
