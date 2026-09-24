import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/src/data/library.dart';
import 'package:user_screen/src/utils/visual_theme.dart';
import 'package:user_screen/src/widgets/kiln_chrome.dart';

void main() {
  testWidgets('the kiln rail shows four rooms and reports taps', (tester) async {
    var picked = -1;
    await tester.pumpWidget(MaterialApp(
      theme: VisualTheme.lightTheme,
      home: Scaffold(
        body: Align(
          alignment: Alignment.centerRight,
          child: KilnRail(index: 0, onSelect: (i) => picked = i),
        ),
      ),
    ));

    expect(find.text('HEARTH'), findsOneWidget);
    expect(find.text('BATCH'), findsOneWidget);
    expect(find.text('ASH'), findsOneWidget);
    expect(find.text('FOLIO'), findsOneWidget);

    await tester.tap(find.text('ASH'));
    expect(picked, 2);
  });

  testWidgets('a kiln card renders its session', (tester) async {
    final session = PracticeLibrary.sessions.first;
    await tester.pumpWidget(MaterialApp(
      theme: VisualTheme.lightTheme,
      home: Scaffold(
        body: KilnCard(session: session, onTap: () {}),
      ),
    ));

    expect(find.text(session.title), findsOneWidget);
    expect(find.text(session.subtitle), findsOneWidget);
  });
}
