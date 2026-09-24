import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/src/data/library.dart';
import 'package:user_screen/src/utils/visual_theme.dart';
import 'package:user_screen/src/widgets/gesso_chrome.dart';

void main() {
  testWidgets('attic tabs show four rooms and report taps', (tester) async {
    var picked = -1;
    await tester.pumpWidget(MaterialApp(
      theme: VisualTheme.lightTheme,
      home: Scaffold(
        body: AtticTabs(index: 0, onSelect: (i) => picked = i),
      ),
    ));

    expect(find.text('Easel'), findsOneWidget);
    expect(find.text('Canvas'), findsOneWidget);
    expect(find.text('Wash'), findsOneWidget);
    expect(find.text('Sketch'), findsOneWidget);

    await tester.tap(find.text('Wash'));
    expect(picked, 2);
  });

  testWidgets('a canvas card renders its session', (tester) async {
    final session = PracticeLibrary.sessions.first;
    await tester.pumpWidget(MaterialApp(
      theme: VisualTheme.lightTheme,
      home: Scaffold(
        body: CanvasCard(session: session, onTap: () {}),
      ),
    ));

    expect(find.text(session.title), findsOneWidget);
    expect(find.text(session.subtitle), findsOneWidget);
  });
}
