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
      mood: 'fog',
      prompt: 'Where did the breath fog the glass?',
      body: 'The right hip after the walk.',
      createdAt: '2026-09-24T10:00:00.000',
    );
    final back = JournalEntry.fromMap(entry.toMap());
    expect(back.mood, 'fog');
    expect(back.body, entry.body);
  });

  test('preferences default to a dark fourteen-minute unwind', () {
    final prefs = UserPreferences();
    expect(prefs.aim, 'unwind');
    expect(prefs.minutes, 14);
    expect(prefs.theme, 'dark');
    expect(prefs.showOnboarding, isTrue);
    expect(UserPreferences.fromMap(prefs.toMap()).bodyFeel, 'even');
  });

  test('engine avoids repeating the last session when it can', () {
    const last = PracticeLog(
      sessionId: 'dawn-wick',
      title: 'Dawn wick',
      minutes: 14,
      completedAt: '2026-09-24T07:00:00.000',
    );
    final pick = PracticeEngine.pickLamp(
      prefs: UserPreferences(aim: 'unwind', minutes: 14, bodyFeel: 'tender'),
      recent: const [last],
      now: DateTime(2026, 9, 24, 7, 30),
    );
    expect(pick.id, isNot('dawn-wick'));
  });

  test('night hour leans toward rest', () {
    final pick = PracticeEngine.pickLamp(
      prefs: UserPreferences(aim: 'sleep', minutes: 14, bodyFeel: 'tender'),
      recent: const [],
      now: DateTime(2026, 9, 24, 22, 10),
    );
    expect(pick.kind == 'sleep' || pick.aims.contains('sleep'), isTrue);
  });

  test('hour greeting changes across the day', () {
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 8)), 'Dawn wick');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 14)), 'High glass');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 19)), 'Lamp hour');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 23)), 'Ember night');
  });
}
