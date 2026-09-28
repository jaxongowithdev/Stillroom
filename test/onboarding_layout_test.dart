import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/src/screens/user_screen.dart';
import 'package:user_screen/src/utils/visual_theme.dart';

void main() {
  testWidgets('onboarding lays out and advances through all four pages',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      theme: VisualTheme.lightTheme,
      home: WelcomeView(onFinished: () {}),
    ));
    expect(tester.takeException(), isNull);
    expect(find.text('Make a little\nroom for yourself.'), findsOneWidget);
    for (var page = 0; page < 3; page++) {
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    expect(find.text('Enter Stillroom'), findsOneWidget);
  });
}
