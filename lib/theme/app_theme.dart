import 'package:flutter/material.dart';

abstract final class AppTheme {
  // ── Core palette ──────────────────────────────────────────────────────
  static const ink = Color(0xFF0D0D0F);
  static const orange = Color(0xFFE8A838);      // warm amber-gold
  static const cream = Color(0xFF1A1A1E);        // charcoal surface
  static const lime = Color(0xFFFF6B35);         // burnt-orange accent
  static const lavender = Color(0xFF252529);     // raised surface / alt
  static const muted = Color(0xFF8E8E93);        // subtitle gray

  // ── Light (now dark-based) theme ──────────────────────────────────────
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: orange,
      primary: orange,
      secondary: lime,
      surface: cream,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: cream,
    fontFamily: 'Outfit',
    appBarTheme: const AppBarTheme(
      backgroundColor: cream,
      foregroundColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
        fontFamily: 'Outfit',
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 42,
        height: 1.04,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: -2,
      ),
      headlineMedium: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: -1.2,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: -0.4,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, color: muted, height: 1.45),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF232328),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
      hintStyle: const TextStyle(color: Color(0xFF58585C)),
      prefixIconColor: muted,
      suffixIconColor: muted,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFF333338)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: orange, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 56),
        backgroundColor: orange,
        foregroundColor: ink,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 15,
          fontFamily: 'Outfit',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: orange,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontFamily: 'Outfit',
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF232328),
      selectedColor: orange,
      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      secondaryLabelStyle: const TextStyle(
        color: Color(0xFF0D0D0F),
        fontWeight: FontWeight.w700,
      ),
      side: const BorderSide(color: Color(0xFF333338)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E22),
      elevation: 0,
      margin: EdgeInsets.zero,
      shadowColor: Colors.black.withValues(alpha: .2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 76,
      backgroundColor: ink,
      indicatorColor: orange,
      elevation: 0,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? ink : Colors.white70,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          color: states.contains(WidgetState.selected)
              ? Colors.white
              : Colors.white60,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          fontFamily: 'Outfit',
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF2A2A2F),
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
