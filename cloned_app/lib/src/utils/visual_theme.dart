import 'package:flutter/material.dart';

/// Gesso Attic — primed canvas, Prussian ink, dusty rose.
/// Top underline rooms, square canvases, a growing picture frame for breath.
/// Not a kiln, not a dock, not cream cloth, not stone cairn, not a night lamp.
class VisualTheme {
  static const Color gesso = Color(0xFFF6F4EF);
  static const Color canvas = Color(0xFFFFFCF7);
  static const Color prussian = Color(0xFF1E3A5F);
  static const Color rose = Color(0xFFB76E79);
  static const Color muted = Color(0xFF7A746C);
  static const Color rule = Color(0xFFD8D2C8);

  static const Color night = Color(0xFF121820);
  static const Color nightCanvas = Color(0xFF1A2430);
  static const Color nightInk = Color(0xFFF6F4EF);
  static const Color nightMuted = Color(0xFFA8B0B8);

  static Color canvasOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? nightCanvas : canvas;

  static Color gessoOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? night : gesso;

  static Color inkOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? nightInk : prussian;

  static Color mutedOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? nightMuted : muted;

  static TextStyle display(double size, {Color? color, FontWeight w = FontWeight.w500}) =>
      TextStyle(
        fontFamily: 'sans-serif',
        fontSize: size,
        fontWeight: w,
        height: 1.18,
        letterSpacing: 0.7,
        color: color,
      );

  static TextStyle heading(double size, {Color? color, FontWeight w = FontWeight.w500}) =>
      TextStyle(
        fontFamily: 'sans-serif',
        fontSize: size,
        fontWeight: w,
        height: 1.3,
        letterSpacing: 0.2,
        color: color,
      );

  static TextStyle body(double size, {Color? color, FontWeight w = FontWeight.w400}) =>
      TextStyle(fontFamily: 'sans-serif', fontSize: size, fontWeight: w, height: 1.5, color: color);

  static TextStyle micro(double size, {Color? color, FontWeight w = FontWeight.w500}) =>
      TextStyle(
        fontFamily: 'sans-serif',
        fontSize: size,
        fontWeight: w,
        letterSpacing: 1.6,
        height: 1.2,
        color: color,
      );

  static ThemeData get lightTheme => _build(Brightness.light, gesso, canvas, prussian, muted, prussian, Colors.white);
  static ThemeData get darkTheme => _build(Brightness.dark, night, nightCanvas, nightInk, nightMuted, rose, night);

  static ThemeData _build(
    Brightness brightness,
    Color scaffold,
    Color surface,
    Color inkColor,
    Color mutedColor,
    Color primary,
    Color onPrimary,
  ) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: prussian,
      brightness: brightness,
      primary: primary,
      secondary: rose,
      surface: surface,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      splashFactory: InkRipple.splashFactory,
      textTheme: (dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme)
          .apply(bodyColor: inkColor, displayColor: inkColor),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: inkColor,
        titleTextStyle: heading(17, color: inkColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: body(14, color: mutedColor),
        hintStyle: body(14, color: mutedColor.withValues(alpha: 0.7)),
        border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
        enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: primary, width: 1.2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: const TextStyle(fontFamily: 'sans-serif', fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.6),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          side: BorderSide(color: primary.withValues(alpha: 0.5)),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontFamily: 'sans-serif', fontWeight: FontWeight.w600, fontSize: 13, letterSpacing: 1.2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: inkColor,
        contentTextStyle: body(14, color: dark ? night : gesso),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        titleTextStyle: heading(20, color: inkColor),
        contentTextStyle: body(15, color: mutedColor),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
    );
  }

  static const washes = ['ease', 'sleep', 'stretch', 'sit'];
  static const teeth = ['fine', 'even', 'coarse'];
  static const minuteChoices = [11, 17, 26];

  static String washLabel(String wash) {
    switch (wash) {
      case 'sleep':
        return 'Sleep';
      case 'stretch':
        return 'Stretch';
      case 'sit':
        return 'Sit';
      default:
        return 'Ease';
    }
  }

  static Color kindTint(String kind) {
    switch (kind) {
      case 'yoga':
        return prussian;
      case 'breath':
        return rose;
      case 'sleep':
        return const Color(0xFF4A5568);
      case 'sit':
        return const Color(0xFF5A4A6A);
      case 'mobility':
        return const Color(0xFF6A5A3A);
      default:
        return muted;
    }
  }
}
