import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/src/data/library.dart';
import 'package:user_screen/src/utils/visual_theme.dart';
import 'package:user_screen/src/widgets/brume_chrome.dart';

void main() {
  testWidgets('the wick bar shows three rooms and reports taps', (tester) async {
    var picked = -1;
    await tester.pumpWidget(MaterialApp(
      theme: VisualTheme.darkTheme,
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: WickBar(index: 0, onSelect: (i) => picked = i),
        ),
      ),
    ));

    expect(find.text('LAMP'), findsOneWidget);
    expect(find.text('LESSONS'), findsOneWidget);
    expect(find.text('PAGES'), findsOneWidget);

    await tester.tap(find.text('PAGES'));
    expect(picked, 2);
  });

  testWidgets('a lamp card renders its session', (tester) async {
    final session = PracticeLibrary.sessions.first;
    await tester.pumpWidget(MaterialApp(
      theme: VisualTheme.darkTheme,
      home: Scaffold(
        body: LampCard(session: session, onTap: () {}),
      ),
    ));

    expect(find.text(session.title), findsOneWidget);
    expect(find.text(session.subtitle), findsOneWidget);
  });
}
