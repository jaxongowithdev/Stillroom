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
      mood: 'rose',
      prompt: 'Where did the breath catch on the canvas?',
      body: 'The right hip after the walk.',
      createdAt: '2026-09-24T10:00:00.000',
    );
    final back = JournalEntry.fromMap(entry.toMap());
    expect(back.mood, 'rose');
    expect(back.body, entry.body);
  });

  test('preferences default to a light seventeen-minute ease wash', () {
    final prefs = UserPreferences();
    expect(prefs.wash, 'ease');
    expect(prefs.minutes, 17);
    expect(prefs.theme, 'light');
    expect(prefs.showOnboarding, isTrue);
    expect(UserPreferences.fromMap(prefs.toMap()).tooth, 'even');
  });

  test('engine avoids repeating the last session when it can', () {
    const last = PracticeLog(
      sessionId: 'morning-prime',
      title: 'Morning prime',
      minutes: 17,
      completedAt: '2026-09-24T07:00:00.000',
    );
    final pick = PracticeEngine.pickCanvas(
      prefs: UserPreferences(wash: 'ease', minutes: 17, tooth: 'fine'),
      recent: const [last],
      now: DateTime(2026, 9, 24, 7, 30),
    );
    expect(pick.id, isNot('morning-prime'));
  });

  test('night hour leans toward rest', () {
    final pick = PracticeEngine.pickCanvas(
      prefs: UserPreferences(wash: 'sleep', minutes: 17, tooth: 'fine'),
      recent: const [],
      now: DateTime(2026, 9, 24, 22, 10),
    );
    expect(pick.kind == 'sleep' || pick.aims.contains('sleep'), isTrue);
  });

  test('hour greeting changes across the day', () {
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 8)), 'Morning prime');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 14)), 'High attic');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 19)), 'Dusk wash');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 23)), 'Night gesso');
  });
}
