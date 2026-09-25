import 'package:flutter/material.dart';

/// Pewter Stoa — cool gray colonnade, fuchsia capital.
/// Four column rooms across the top, tall bay cards, rising columns for breath.
/// Not gesso attic, not kiln, not dock, not cream cloth, not stone cairn, not night lamp.
class VisualTheme {
  static const Color mist = Color(0xFFEEF0F2);
  static const Color bay = Color(0xFFF8F9FA);
  static const Color pewter = Color(0xFF5C636A);
  static const Color ink = Color(0xFF16191C);
  static const Color fuchsia = Color(0xFFC23B6E);
  static const Color muted = Color(0xFF6E757C);
  static const Color rule = Color(0xFFD5D8DC);

  static const Color night = Color(0xFF121416);
  static const Color nightBay = Color(0xFF1C2024);
  static const Color nightInk = Color(0xFFEEF0F2);
  static const Color nightMuted = Color(0xFF9AA1A8);

  static Color bayOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? nightBay : bay;

  static Color mistOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? night : mist;

  static Color inkOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? nightInk : ink;

  static Color mutedOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? nightMuted : muted;

  static TextStyle display(double size, {Color? color, FontWeight w = FontWeight.w400}) =>
      TextStyle(
        fontFamily: 'sans-serif',
        fontSize: size,
        fontWeight: w,
        height: 1.12,
        letterSpacing: 0.4,
        color: color,
      );

  static TextStyle heading(double size, {Color? color, FontWeight w = FontWeight.w500}) =>
      TextStyle(
        fontFamily: 'sans-serif',
        fontSize: size,
        fontWeight: w,
        height: 1.28,
        letterSpacing: 0.15,
        color: color,
      );

  static TextStyle body(double size, {Color? color, FontWeight w = FontWeight.w400}) =>
      TextStyle(fontFamily: 'sans-serif', fontSize: size, fontWeight: w, height: 1.48, color: color);

  static TextStyle micro(double size, {Color? color, FontWeight w = FontWeight.w600}) =>
      TextStyle(
        fontFamily: 'sans-serif',
        fontSize: size,
        fontWeight: w,
        letterSpacing: 2.0,
        height: 1.15,
        color: color,
      );

  static ThemeData get lightTheme => _build(Brightness.light, mist, bay, ink, muted, fuchsia, Colors.white);
  static ThemeData get darkTheme => _build(Brightness.dark, night, nightBay, nightInk, nightMuted, fuchsia, night);

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
      seedColor: fuchsia,
      brightness: brightness,
      primary: primary,
      secondary: pewter,
      surface: surface,
    );
    const bayRadius = BorderRadius.all(Radius.circular(2));
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
        shape: const RoundedRectangleBorder(borderRadius: bayRadius),
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
        border: const OutlineInputBorder(borderRadius: bayRadius, borderSide: BorderSide.none),
        enabledBorder: const OutlineInputBorder(borderRadius: bayRadius, borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: bayRadius, borderSide: BorderSide(color: primary, width: 1.2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
          textStyle: const TextStyle(fontFamily: 'sans-serif', fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.5),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          side: BorderSide(color: primary.withValues(alpha: 0.5)),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontFamily: 'sans-serif', fontWeight: FontWeight.w600, fontSize: 13, letterSpacing: 1.3),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: inkColor,
        contentTextStyle: body(14, color: dark ? night : mist),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(borderRadius: bayRadius),
        titleTextStyle: heading(20, color: inkColor),
        contentTextStyle: body(15, color: mutedColor),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
    );
  }

  static const aspects = ['ease', 'sleep', 'stretch', 'sit'];
  static const grains = ['smooth', 'even', 'rough'];
  static const minuteChoices = [13, 19, 27];

  static String aspectLabel(String aspect) {
    switch (aspect) {
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
        return fuchsia;
      case 'breath':
        return pewter;
      case 'sleep':
        return ink;
      case 'sit':
        return const Color(0xFF7A4A62);
      case 'mobility':
        return const Color(0xFF6A7A4A);
      default:
        return muted;
    }
  }
}
