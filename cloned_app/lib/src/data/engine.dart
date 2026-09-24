import '../models/practice_models.dart';
import '../models/user_preferences.dart';
import 'library.dart';

class PracticeEngine {
  static PracticeSession pickLamp({
    required UserPreferences prefs,
    required List<PracticeLog> recent,
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now();
    final hour = clock.hour;
    final used = recent.take(3).map((l) => l.sessionId).toSet();

    var pool = PracticeLibrary.sessions.where((s) {
      final fitsTime = s.minutes <= prefs.minutes + 8;
      final fitsBody = prefs.bodyFeel != 'tender' || s.level != 'ready';
      return fitsTime && fitsBody;
    }).toList();
    if (pool.isEmpty) pool = List.of(PracticeLibrary.sessions);

    pool.sort((a, b) => _score(b, prefs, hour, used).compareTo(_score(a, prefs, hour, used)));
    return pool.first;
  }

  static int _score(PracticeSession s, UserPreferences prefs, int hour, Set<String> used) {
    var n = 0;
    if (s.aims.contains(prefs.aim)) n += 5;
    if (s.level == prefs.bodyFeel) n += 3;
    if ((s.minutes - prefs.minutes).abs() <= 2) n += 2;
    if (hour < 11 && s.id.contains('dawn')) n += 3;
    if (hour >= 20 && (s.kind == 'sleep' || s.aims.contains('sleep'))) n += 4;
    if (hour >= 11 && hour < 17 && s.kind == 'mobility') n += 3;
    if (prefs.aim == 'sleep' && s.kind == 'sleep') n += 4;
    if (prefs.aim == 'sit' && (s.kind == 'sit' || s.kind == 'breath')) n += 3;
    if (used.contains(s.id)) n -= 6;
    return n;
  }

  static String hourGreeting(DateTime now) {
    final h = now.hour;
    if (h < 11) return 'Dawn wick';
    if (h < 17) return 'High glass';
    if (h < 21) return 'Lamp hour';
    return 'Ember night';
  }

  static String lessonOfDay(DateTime now) {
    const lessons = [
      'The empty is the teacher. Let the fill be ordinary.',
      'A bent knee is still the lesson. Depth is not a grade.',
      'Walk the mind back once, the way you would a child — without a speech.',
      'An eight-minute glass is a complete practice. Do not wait for a free hour.',
      'The sill can hold a worry overnight. You may know where it is and not carry it.',
      'Breathe in the back of the body. The chest does not have to perform.',
      'Dim the lamp a little. The room is still there.',
    ];
    return lessons[now.day % lessons.length];
  }
}
