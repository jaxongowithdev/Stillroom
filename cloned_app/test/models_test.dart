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
      mood: 'glaze',
      prompt: 'Where did the breath catch in the bisque?',
      body: 'The right hip after the walk.',
      createdAt: '2026-09-24T10:00:00.000',
    );
    final back = JournalEntry.fromMap(entry.toMap());
    expect(back.mood, 'glaze');
    expect(back.body, entry.body);
  });

  test('preferences default to a light eighteen-minute ease glaze', () {
    final prefs = UserPreferences();
    expect(prefs.glaze, 'ease');
    expect(prefs.minutes, 18);
    expect(prefs.theme, 'light');
    expect(prefs.showOnboarding, isTrue);
    expect(UserPreferences.fromMap(prefs.toMap()).bisque, 'even');
  });

  test('engine avoids repeating the last session when it can', () {
    const last = PracticeLog(
      sessionId: 'morning-bisque',
      title: 'Morning bisque',
      minutes: 18,
      completedAt: '2026-09-24T07:00:00.000',
    );
    final pick = PracticeEngine.pickBatch(
      prefs: UserPreferences(glaze: 'ease', minutes: 18, bisque: 'soft'),
      recent: const [last],
      now: DateTime(2026, 9, 24, 7, 30),
    );
    expect(pick.id, isNot('morning-bisque'));
  });

  test('night hour leans toward rest', () {
    final pick = PracticeEngine.pickBatch(
      prefs: UserPreferences(glaze: 'sleep', minutes: 18, bisque: 'soft'),
      recent: const [],
      now: DateTime(2026, 9, 24, 22, 10),
    );
    expect(pick.kind == 'sleep' || pick.aims.contains('sleep'), isTrue);
  });

  test('hour greeting changes across the day', () {
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 8)), 'Morning bisque');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 14)), 'High kiln');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 19)), 'Dusk ash');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 23)), 'Night flue');
  });
}
