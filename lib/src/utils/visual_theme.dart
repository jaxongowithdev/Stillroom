import 'package:flutter/material.dart';

/// Stillroom uses a warm paper palette and rounded, welcoming surfaces.
class VisualTheme {
  static const mist = Color(0xFFFFF7F1),
      bay = Color(0xFFFFFFFF),
      pewter = Color(0xFF315C6D),
      ink = Color(0xFF21334A),
      fuchsia = Color(0xFFE8755B),
      muted = Color(0xFF657487),
      rule = Color(0xFFEBDDD2),
      sky = Color(0xFFD7ECF2),
      apricot = Color(0xFFFFD5A6);
  static const night = Color(0xFF172536),
      nightBay = Color(0xFF22354A),
      nightInk = Color(0xFFFFF4EA),
      nightMuted = Color(0xFFBAC6D1);
  static Color bayOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? nightBay : bay;
  static Color mistOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? night : mist;
  static Color inkOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? nightInk : ink;
  static Color mutedOf(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? nightMuted : muted;
  static TextStyle display(
    double s, {
    Color? color,
    FontWeight w = FontWeight.w700,
  }) => TextStyle(
    fontFamily: 'sans-serif',
    fontSize: s,
    fontWeight: w,
    height: 1.06,
    letterSpacing: -.7,
    color: color,
  );
  static TextStyle heading(
    double s, {
    Color? color,
    FontWeight w = FontWeight.w700,
  }) => TextStyle(
    fontFamily: 'sans-serif',
    fontSize: s,
    fontWeight: w,
    height: 1.22,
    letterSpacing: -.15,
    color: color,
  );
  static TextStyle body(
    double s, {
    Color? color,
    FontWeight w = FontWeight.w400,
  }) => TextStyle(
    fontFamily: 'sans-serif',
    fontSize: s,
    fontWeight: w,
    height: 1.45,
    color: color,
  );
  static TextStyle micro(
    double s, {
    Color? color,
    FontWeight w = FontWeight.w700,
  }) => TextStyle(
    fontFamily: 'sans-serif',
    fontSize: s,
    fontWeight: w,
    letterSpacing: 1.25,
    height: 1.15,
    color: color,
  );
  static ThemeData get lightTheme =>
      _build(Brightness.light, mist, bay, ink, muted, fuchsia, Colors.white);
  static ThemeData get darkTheme => _build(
    Brightness.dark,
    night,
    nightBay,
    nightInk,
    nightMuted,
    fuchsia,
    night,
  );
  static ThemeData _build(
    Brightness brightness,
    Color scaffold,
    Color surface,
    Color text,
    Color subdued,
    Color primary,
    Color onPrimary,
  ) {
    const radius = BorderRadius.all(Radius.circular(24));
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffold,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
        primary: primary,
        secondary: pewter,
        surface: surface,
      ),
      textTheme:
          (brightness == Brightness.dark
                  ? ThemeData.dark().textTheme
                  : ThemeData.light().textTheme)
              .apply(bodyColor: text, displayColor: text),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: heading(18, color: text),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: body(14, color: subdued),
        border: const OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size(64, 54),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          textStyle: const TextStyle(
            fontFamily: 'sans-serif',
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: text,
        contentTextStyle: body(14, color: mist),
        shape: const RoundedRectangleBorder(borderRadius: radius),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
    );
  }

  static const aspects = ['ease', 'sleep', 'stretch', 'sit'],
      grains = ['smooth', 'even', 'rough'],
      minuteChoices = [13, 19, 27];
  static String aspectLabel(String a) => switch (a) {
    'sleep' => 'Sleep',
    'stretch' => 'Stretch',
    'sit' => 'Sit',
    _ => 'Ease',
  };
  static Color kindTint(String k) => switch (k) {
    'yoga' => fuchsia,
    'breath' => pewter,
    'sleep' => ink,
    'sit' => const Color(0xFF9271A8),
    'mobility' => const Color(0xFF4E8E83),
    _ => muted,
  };
}
