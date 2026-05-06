import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const primary = Color(0xFF4CD6FF);
  static const primaryContainer = Color(0xFF007792);
  static const onPrimary = Color(0xFF003543);
  static const onPrimaryContainer = Color(0xFFDCF4FF);
  
  static const tertiary = Color(0xFFC1C1FF);
  
  // Surface Layers (Depth)
  static const surface = Color(0xFF05050A);
  static const surfaceContainerLowest = Color(0xFF020205);
  static const surfaceContainerLow = Color(0xFF0A0B13);
  static const surfaceContainer = Color(0xFF0F111A);
  static const surfaceContainerHighest = Color(0xFF32343E);
  static const surfaceBright = Color(0xFF373943);
  
  // Text Colors
  static const onSurface = Color(0xFFE1E1EF);
  static const secondary = Color(0xFFC6C5D4);
  
  // Accents
  static const outlineVariant = Color(0xFF434656);

  // Dynamic Theme Helpers
  static Color surfaceContainerWith(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? surfaceContainer : const Color(0xFFF1F5F9); // Slate 100
      
  static Color surfaceContainerLowWith(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? surfaceContainerLow : const Color(0xFFF8FAFC); // Slate 50
      
  static Color surfaceContainerHighestWith(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? surfaceContainerHighest : const Color(0xFFE2E8F0); // Slate 200
      
  static Color surfaceContainerLowestWith(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? surfaceContainerLowest : const Color(0xFFFFFFFF); // White

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        primaryContainer: primaryContainer,
        secondary: secondary,
        tertiary: tertiary,
        surface: surface,
        onSurface: onSurface,
        onPrimary: onPrimary,
        outlineVariant: outlineVariant,
      ),
      scaffoldBackgroundColor: surface,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 56,
          fontWeight: FontWeight.w700,
          color: onSurface,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: secondary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: onSurface,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onSurface,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.8,
          color: secondary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.8,
          color: secondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Handled by gradient in Ink feature usually
          foregroundColor: onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primary,
        primaryContainer: primaryContainer,
        secondary: secondary,
        tertiary: tertiary,
        surface: Color(0xFFF8FAFC), 
        onSurface: Color(0xFF0F172A), 
        onPrimary: Colors.white,
        outlineVariant: Color(0xFFCBD5E1),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.manrope(
          fontSize: 56,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0F172A),
          height: 1.2,
        ),
        displayMedium: GoogleFonts.manrope(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0F172A),
        ),
        headlineLarge: GoogleFonts.manrope(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0F172A),
        ),
        headlineSmall: GoogleFonts.manrope(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF475569), // Secondary text
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0F172A),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF0F172A),
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF0F172A),
          height: 1.5,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.8,
          color: const Color(0xFF475569),
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.8,
          color: const Color(0xFF475569),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
