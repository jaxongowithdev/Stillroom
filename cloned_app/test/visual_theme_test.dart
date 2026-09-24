import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/src/utils/visual_theme.dart';

void main() {
  test('light and dark both build', () {
    expect(VisualTheme.lightTheme.brightness, Brightness.light);
    expect(VisualTheme.darkTheme.brightness, Brightness.dark);
    expect(VisualTheme.lightTheme.scaffoldBackgroundColor, VisualTheme.gesso);
  });

  test('kind tints differ', () {
    final colours = ['yoga', 'breath', 'sleep', 'sit', 'mobility'].map(VisualTheme.kindTint).toSet();
    expect(colours.length, 5);
  });

  test('wash labels are human', () {
    expect(VisualTheme.washLabel('sleep'), 'Sleep');
    expect(VisualTheme.washLabel('sit'), 'Sit');
    expect(VisualTheme.washLabel('ease'), 'Ease');
  });
}
