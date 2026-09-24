import 'package:flutter/material.dart';

/// Lichen Kiln — warm sand, lichen green, umber ink.
/// Bold titles, right kiln rail, pots round at the base. Not mist dock. Not cream cloth. Not stone cairn. Not night lamp.
class VisualTheme {
  static const Color sand = Color(0xFFF2EBD8);
  static const Color bisque = Color(0xFFFAF4E8);
  static const Color umber = Color(0xFF3D2A1C);
  static const Color lichen = Color(0xFF5C7A32);
  static const Color moss = Color(0xFF7A8F3E);
  static const Color muted = Color(0xFF7A6A58);
  static const Color rule = Color(0xFFDDD2BC);

  static const Color night = Color(0xFF1C1610);
  static const Color nightBisque = Color(0xFF2A2218);
  static const Color nightInk = Color(0xFFF2EBD8);
  static const Color nightMuted = Color(0xFFB8A894);

  static Color bisqueOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? nightBisque : bisque;

  static Color sandOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? night : sand;

  static Color inkOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? nightInk : umber;

  static Color mutedOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? nightMuted : muted;

  static TextStyle display(double size, {Color? color, FontWeight w = FontWeight.w700}) =>
      TextStyle(
        fontFamily: 'sans-serif',
        fontSize: size,
        fontWeight: w,
        height: 1.08,
        letterSpacing: -0.35,
        color: color,
      );

  static TextStyle heading(double size, {Color? color, FontWeight w = FontWeight.w600}) =>
      TextStyle(
        fontFamily: 'sans-serif',
        fontSize: size,
        fontWeight: w,
        height: 1.22,
        letterSpacing: -0.1,
        color: color,
      );

  static TextStyle body(double size, {Color? color, FontWeight w = FontWeight.w400}) =>
      TextStyle(fontFamily: 'sans-serif', fontSize: size, fontWeight: w, height: 1.48, color: color);

  static TextStyle micro(double size, {Color? color, FontWeight w = FontWeight.w700}) =>
      TextStyle(
        fontFamily: 'sans-serif',
        fontSize: size,
        fontWeight: w,
        letterSpacing: 2.2,
        height: 1.2,
        color: color,
      );

  static ThemeData get lightTheme => _build(Brightness.light, sand, bisque, umber, muted, lichen, Colors.white);
  static ThemeData get darkTheme => _build(Brightness.dark, night, nightBisque, nightInk, nightMuted, lichen, night);

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
      seedColor: lichen,
      brightness: brightness,
      primary: primary,
      secondary: moss,
      surface: surface,
    );
    const pot = BorderRadius.only(
      topLeft: Radius.circular(4),
      topRight: Radius.circular(4),
      bottomLeft: Radius.circular(28),
      bottomRight: Radius.circular(28),
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
        shape: const RoundedRectangleBorder(borderRadius: pot),
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
        border: const OutlineInputBorder(borderRadius: pot, borderSide: BorderSide.none),
        enabledBorder: const OutlineInputBorder(borderRadius: pot, borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: pot, borderSide: BorderSide(color: primary, width: 1.4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontFamily: 'sans-serif', fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          side: BorderSide(color: primary.withValues(alpha: 0.55)),
          shape: const StadiumBorder(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontFamily: 'sans-serif', fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 1.4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: inkColor,
        contentTextStyle: body(14, color: dark ? night : sand),
        shape: const StadiumBorder(),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(borderRadius: pot),
        titleTextStyle: heading(20, color: inkColor),
        contentTextStyle: body(15, color: mutedColor),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
    );
  }

  static const glazes = ['ease', 'sleep', 'stretch', 'sit'];
  static const bisques = ['soft', 'even', 'fired'];
  static const minuteChoices = [12, 18, 28];

  static String glazeLabel(String glaze) {
    switch (glaze) {
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
        return lichen;
      case 'breath':
        return moss;
      case 'sleep':
        return umber;
      case 'sit':
        return const Color(0xFF4A5C38);
      case 'mobility':
        return const Color(0xFF8A7A3A);
      default:
        return muted;
    }
  }
}
