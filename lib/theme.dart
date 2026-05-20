import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryGreen = Color(0xFF1A3B2B); // Deep Forest Green
  static const Color secondaryGreen = Color(0xFF133020); // Darker Forest Green
  static const Color mintGreen = Color(0xFF6FA886); // Mint / Accent Green
  static const Color lightMint = Color(0xFFE8F2EC); // Light Mint for highlights
  static const Color creamBg = Color(0xFFF7F6F0); // Off-White / Cream background
  static const Color accentGold = Color(0xFFF2AF42); // Streak / Coin Orange-Yellow
  static const Color lightGold = Color(0xFFFEF6E7); // Light gold background
  static const Color textDark = Color(0xFF2A2A2A); // Dark charcoal for body text
  static const Color textLight = Color(0xFF757575); // Medium grey for secondary text
  static const Color cardBg = Colors.white;

  // HSL customized colors for visual richness
  static const Color organicColor = Color(0xFF8D6E63); // Earth Brown
  static const Color anorganicColor = Color(0xFF2196F3); // Blue
  static const Color b3Color = Color(0xFFE53935); // Toxic Red

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: creamBg,
      primaryColor: primaryGreen,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: mintGreen,
        background: creamBg,
        surface: cardBg,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      textTheme: TextTheme(
        // Serif-like typography for brand headings
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primaryGreen,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryGreen,
        ),
        displaySmall: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryGreen,
        ),
        // Sans-serif typography for body copy
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textDark,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textDark,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textLight,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryGreen),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: primaryGreen,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
