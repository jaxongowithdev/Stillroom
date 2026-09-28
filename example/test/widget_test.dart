import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/src/data/library.dart';
import 'package:user_screen/src/utils/visual_theme.dart';
import 'package:user_screen/src/widgets/stoa_chrome.dart';

void main() {
  testWidgets('stoa columns show four rooms and report taps', (tester) async {
    var picked = -1;
    await tester.pumpWidget(MaterialApp(
      theme: VisualTheme.lightTheme,
      home: Scaffold(
        body: StoaColon(index: 0, onSelect: (i) => picked = i),
      ),
    ));

    expect(find.text('I'), findsOneWidget);
    expect(find.text('II'), findsOneWidget);
    expect(find.text('III'), findsOneWidget);
    expect(find.text('IV'), findsOneWidget);
    expect(find.text('Walk'), findsOneWidget);
    expect(find.text('Range'), findsOneWidget);
    expect(find.text('Shade'), findsOneWidget);
    expect(find.text('Tablet'), findsOneWidget);

    await tester.tap(find.text('Shade'));
    expect(picked, 2);
  });

  testWidgets('a bay card renders its session', (tester) async {
    final session = PracticeLibrary.sessions.first;
    await tester.pumpWidget(MaterialApp(
      theme: VisualTheme.lightTheme,
      home: Scaffold(
        body: BayCard(session: session, onTap: () {}),
      ),
    ));

    expect(find.text(session.title), findsOneWidget);
    expect(find.text(session.subtitle), findsOneWidget);
  });
}
