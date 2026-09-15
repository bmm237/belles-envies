import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palette inspirée des ingrédients de la cuisine camerounaise :
/// vert des feuilles de ndolé, rouille de l'huile de palme et du piment,
/// ocre des épices, et un fond parchemin chaud.
/// Palette Belle Envie : noir profond, blanc et or, pour une identité
/// élégante et haut de gamme.
class AppColors {
  static const black = Color(0xFF15130F);
  static const blackSoft = Color(0xFF2B2820);
  static const gold = Color(0xFFC9A227);
  static const goldLight = Color(0xFFE8CD82);
  static const cream = Color(0xFFFAF8F3);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1C1A16);
  static const inkSoft = Color(0xFF7A756B);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);

    final displayFont = GoogleFonts.fraunces();
    final bodyFont = GoogleFonts.manrope();

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.black,
        secondary: AppColors.gold,
        tertiary: AppColors.goldLight,
        surface: AppColors.surface,
      ),
      textTheme: TextTheme(
        displaySmall: displayFont.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
          height: 1.15,
        ),
        headlineSmall: displayFont.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        titleMedium: displayFont.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        bodyLarge: bodyFont.copyWith(
          fontSize: 15,
          color: AppColors.ink,
          height: 1.4,
        ),
        bodyMedium: bodyFont.copyWith(
          fontSize: 13.5,
          color: AppColors.inkSoft,
          height: 1.4,
        ),
        labelLarge: bodyFont.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.surface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        hintStyle: bodyFont.copyWith(color: AppColors.inkSoft, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.gold,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: bodyFont.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
    );
  }

  /// Style du titre "Belle Envie" utilisé dans l'AppBar.
  static TextStyle get appBarTitle => GoogleFonts.fraunces(
    color: AppColors.gold,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.1,
  );
}
