import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/src/data/engine.dart';
import 'package:user_screen/src/data/library.dart';
import 'package:user_screen/src/models/practice_models.dart';
import 'package:user_screen/src/models/user_preferences.dart';

void main() {
  test('every session id is unique and steps add up', () {
    final ids = PracticeLibrary.sessions.map((s) => s.id).toSet();
    expect(ids.length, PracticeLibrary.sessions.length);
    for (final session in PracticeLibrary.sessions) {
      expect(session.steps, isNotEmpty);
      expect(session.totalSeconds, greaterThan(0));
    }
  });

  test('journal survives a map round trip', () {
    const entry = JournalEntry(
      id: 2,
      mood: 'fuchsia',
      prompt: 'Where did the breath catch between the columns?',
      body: 'The right hip after the walk.',
      createdAt: '2026-09-24T10:00:00.000',
    );
    final back = JournalEntry.fromMap(entry.toMap());
    expect(back.mood, 'fuchsia');
    expect(back.body, entry.body);
  });

  test('preferences default to a light nineteen-minute ease walk', () {
    final prefs = UserPreferences();
    expect(prefs.aspect, 'ease');
    expect(prefs.minutes, 19);
    expect(prefs.theme, 'light');
    expect(prefs.showOnboarding, isTrue);
    expect(UserPreferences.fromMap(prefs.toMap()).grain, 'even');
  });

  test('engine avoids repeating the last session when it can', () {
    const last = PracticeLog(
      sessionId: 'morning-walk',
      title: 'Morning walk',
      minutes: 19,
      completedAt: '2026-09-24T07:00:00.000',
    );
    final pick = PracticeEngine.pickWalk(
      prefs: UserPreferences(aspect: 'ease', minutes: 19, grain: 'smooth'),
      recent: const [last],
      now: DateTime(2026, 9, 24, 7, 30),
    );
    expect(pick.id, isNot('morning-walk'));
  });

  test('night hour leans toward rest', () {
    final pick = PracticeEngine.pickWalk(
      prefs: UserPreferences(aspect: 'sleep', minutes: 19, grain: 'smooth'),
      recent: const [],
      now: DateTime(2026, 9, 24, 22, 10),
    );
    expect(pick.kind == 'sleep' || pick.aims.contains('sleep'), isTrue);
  });

  test('hour greeting changes across the day', () {
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 8)), 'Morning walk');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 14)), 'High range');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 19)), 'Dusk shade');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 23)), 'Night colonnade');
  });
}
