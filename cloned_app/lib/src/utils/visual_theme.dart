import 'package:flutter/material.dart';

/// Brume Lamp — night-first, lamp-amber, fog glass.
/// Soft stadium cards, thin wide headlines. Not parchment, not sharp magazine.
class VisualTheme {
  static const Color night = Color(0xFF121820);
  static const Color panel = Color(0xFF1C2630);
  static const Color fog = Color(0xFF8BA3B5);
  static const Color lamp = Color(0xFFE8B86D);
  static const Color ember = Color(0xFFD4784A);
  static const Color mist = Color(0xFFE8EEF2);
  static const Color ink = Color(0xFFE8EEF2);
  static const Color muted = Color(0xFF8BA3B5);

  static const Color day = Color(0xFFE8EEF2);
  static const Color dayPanel = Color(0xFFF7FAFC);
  static const Color dayInk = Color(0xFF1C2630);
  static const Color dayMuted = Color(0xFF5C6E7A);

  static const double r = 28;

  static Color panelOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? panel : dayPanel;

  static Color nightOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? night : day;

  static Color inkOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? ink : dayInk;

  static Color mutedOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? muted : dayMuted;

  static TextStyle display(double size, {Color? color, FontWeight w = FontWeight.w300}) =>
      TextStyle(
        fontFamily: 'sans-serif',
        fontSize: size,
        fontWeight: w,
        height: 1.05,
        letterSpacing: 1.2,
        color: color,
      );

  static TextStyle heading(double size, {Color? color, FontWeight w = FontWeight.w500}) =>
      TextStyle(
        fontFamily: 'sans-serif',
        fontSize: size,
        fontWeight: w,
        height: 1.2,
        letterSpacing: 0.2,
        color: color,
      );

  static TextStyle body(double size, {Color? color, FontWeight w = FontWeight.w400}) =>
      TextStyle(fontFamily: 'sans-serif', fontSize: size, fontWeight: w, height: 1.45, color: color);

  static TextStyle micro(double size, {Color? color, FontWeight w = FontWeight.w600}) =>
      TextStyle(
        fontFamily: 'sans-serif',
        fontSize: size,
        fontWeight: w,
        letterSpacing: 2.4,
        height: 1.2,
        color: color,
      );

  static ThemeData get darkTheme => _build(
        Brightness.dark,
        night,
        panel,
        ink,
        muted,
        lamp,
        night,
      );

  static ThemeData get lightTheme => _build(
        Brightness.light,
        day,
        dayPanel,
        dayInk,
        dayMuted,
        const Color(0xFFB8863A),
        Colors.white,
      );

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
      seedColor: lamp,
      brightness: brightness,
      primary: primary,
      secondary: ember,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r)),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: inkColor,
        titleTextStyle: heading(18, color: inkColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: body(14, color: mutedColor),
        hintStyle: body(14, color: mutedColor.withValues(alpha: 0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r),
          borderSide: BorderSide(color: primary, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamily: 'sans-serif',
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.8,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          side: BorderSide(color: primary.withValues(alpha: 0.45)),
          shape: const StadiumBorder(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontFamily: 'sans-serif',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 1.0,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: surface,
        contentTextStyle: body(14, color: inkColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r)),
        titleTextStyle: heading(20, color: inkColor),
        contentTextStyle: body(15, color: mutedColor),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
    );
  }

  static const aims = ['unwind', 'sleep', 'stretch', 'sit'];
  static const bodyFeels = ['tender', 'even', 'ready'];
  static const minuteChoices = [8, 14, 22];

  static String aimLabel(String aim) {
    switch (aim) {
      case 'sleep':
        return 'Sleep';
      case 'stretch':
        return 'Stretch';
      case 'sit':
        return 'Sit';
      default:
        return 'Unwind';
    }
  }

  static Color kindTint(String kind) {
    switch (kind) {
      case 'yoga':
        return lamp;
      case 'breath':
        return fog;
      case 'sleep':
        return const Color(0xFF6B7FA0);
      case 'sit':
        return ember;
      case 'mobility':
        return const Color(0xFF7FA08A);
      default:
        return muted;
    }
  }
}
