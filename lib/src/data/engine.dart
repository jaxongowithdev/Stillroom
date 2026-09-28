import '../models/practice_models.dart';
import '../models/user_preferences.dart';
import 'library.dart';

class PracticeEngine {
  static PracticeSession pickWalk({
    required UserPreferences prefs,
    required List<PracticeLog> recent,
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now();
    final hour = clock.hour;
    final used = recent.take(3).map((l) => l.sessionId).toSet();

    var pool = PracticeLibrary.sessions.where((s) {
      final fitsTime = s.minutes <= prefs.minutes + 10;
      final fitsGrain = prefs.grain != 'smooth' || s.level != 'rough';
      return fitsTime && fitsGrain;
    }).toList();
    if (pool.isEmpty) pool = List.of(PracticeLibrary.sessions);

    pool.sort((a, b) =>
        _score(b, prefs, hour, used).compareTo(_score(a, prefs, hour, used)));
    return pool.first;
  }

  static int _score(
      PracticeSession s, UserPreferences prefs, int hour, Set<String> used) {
    var n = 0;
    if (s.aims.contains(prefs.aspect)) n += 5;
    if (s.level == prefs.grain) n += 3;
    if ((s.minutes - prefs.minutes).abs() <= 2) n += 2;
    if (hour < 11 && s.id.contains('morning')) n += 3;
    if (hour >= 20 && (s.kind == 'sleep' || s.aims.contains('sleep'))) n += 4;
    if (hour >= 11 && hour < 17 && s.kind == 'mobility') n += 3;
    if (prefs.aspect == 'sleep' && s.kind == 'sleep') n += 4;
    if (prefs.aspect == 'sit' && (s.kind == 'sit' || s.kind == 'breath')) {
      n += 3;
    }
    if (used.contains(s.id)) n -= 6;
    return n;
  }

  static String hourGreeting(DateTime now) {
    final h = now.hour;
    if (h < 11) return 'Good morning';
    if (h < 17) return 'A little reset';
    if (h < 21) return 'Ease into evening';
    return 'Good night';
  }

  static String lessonOfDay(DateTime now) {
    const lessons = [
      'The exhale can be your teacher. Let the inhale arrive on its own.',
      'A bent knee is still the lesson. Depth is never a grade.',
      'Bring attention back once, as gently as you would guide a child.',
      'Thirteen minutes counts. You do not need a free hour to care for yourself.',
      'A worry can wait overnight. You may know where it is without carrying it.',
      'Breathe into the back of the body. Your chest has nothing to prove.',
      'Leave something unfinished. The room will be here tomorrow.',
    ];
    return lessons[now.day % lessons.length];
  }
}
