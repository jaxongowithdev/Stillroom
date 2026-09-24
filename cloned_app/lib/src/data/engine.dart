import '../models/practice_models.dart';
import '../models/user_preferences.dart';
import 'library.dart';

class PracticeEngine {
  static PracticeSession pickBatch({
    required UserPreferences prefs,
    required List<PracticeLog> recent,
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now();
    final hour = clock.hour;
    final used = recent.take(3).map((l) => l.sessionId).toSet();

    var pool = PracticeLibrary.sessions.where((s) {
      final fitsTime = s.minutes <= prefs.minutes + 10;
      final fitsBisque = prefs.bisque != 'soft' || s.level != 'fired';
      return fitsTime && fitsBisque;
    }).toList();
    if (pool.isEmpty) pool = List.of(PracticeLibrary.sessions);

    pool.sort((a, b) => _score(b, prefs, hour, used).compareTo(_score(a, prefs, hour, used)));
    return pool.first;
  }

  static int _score(PracticeSession s, UserPreferences prefs, int hour, Set<String> used) {
    var n = 0;
    if (s.aims.contains(prefs.glaze)) n += 5;
    if (s.level == prefs.bisque) n += 3;
    if ((s.minutes - prefs.minutes).abs() <= 2) n += 2;
    if (hour < 11 && s.id.contains('morning')) n += 3;
    if (hour >= 20 && (s.kind == 'sleep' || s.aims.contains('sleep'))) n += 4;
    if (hour >= 11 && hour < 17 && s.kind == 'mobility') n += 3;
    if (prefs.glaze == 'sleep' && s.kind == 'sleep') n += 4;
    if (prefs.glaze == 'sit' && (s.kind == 'sit' || s.kind == 'breath')) n += 3;
    if (used.contains(s.id)) n -= 6;
    return n;
  }

  static String hourGreeting(DateTime now) {
    final h = now.hour;
    if (h < 11) return 'Morning bisque';
    if (h < 17) return 'High kiln';
    if (h < 21) return 'Dusk ash';
    return 'Night flue';
  }

  static String lessonOfDay(DateTime now) {
    const lessons = [
      'The cool is the teacher. Let the heat be ordinary.',
      'A bent knee is still the lesson. Depth is not a grade.',
      'Walk the mind back once, the way you would a child — without a speech.',
      'A twelve-minute batch is a complete practice. Do not wait for a free hour.',
      'The flue can hold a worry overnight. You may know where it is and not carry it.',
      'Breathe in the back of the body. The chest does not have to perform.',
      'Leave one pot unglazed. The kiln is still there.',
    ];
    return lessons[now.day % lessons.length];
  }
}
