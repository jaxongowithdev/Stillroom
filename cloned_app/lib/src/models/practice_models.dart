class PracticeStep {
  final String title;
  final String cue;
  final int seconds;

  const PracticeStep({required this.title, required this.cue, required this.seconds});
}

class PracticeSession {
  final String id;
  final String title;
  final String subtitle;
  final String kind;
  final int minutes;
  final String level;
  final List<String> aims;
  final String teaching;
  final List<PracticeStep> steps;

  const PracticeSession({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.kind,
    required this.minutes,
    required this.level,
    required this.aims,
    required this.teaching,
    required this.steps,
  });

  int get totalSeconds => steps.fold(0, (sum, s) => sum + s.seconds);
}

class BreathPattern {
  final String id;
  final String name;
  final String teaching;
  final List<BreathPhase> phases;
  final int rounds;

  const BreathPattern({
    required this.id,
    required this.name,
    required this.teaching,
    required this.phases,
    required this.rounds,
  });
}

class BreathPhase {
  final String label;
  final int seconds;
  const BreathPhase({required this.label, required this.seconds});
}

class PoseCard {
  final String id;
  final String name;
  final String aka;
  final String setup;
  final String breath;
  final String ifThis;

  const PoseCard({
    required this.id,
    required this.name,
    required this.aka,
    required this.setup,
    required this.breath,
    required this.ifThis,
  });
}

class PracticeLog {
  final int? id;
  final String sessionId;
  final String title;
  final int minutes;
  final String completedAt;

  const PracticeLog({
    this.id,
    required this.sessionId,
    required this.title,
    required this.minutes,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() => {
        'sessionId': sessionId,
        'title': title,
        'minutes': minutes,
        'completedAt': completedAt,
      };

  factory PracticeLog.fromMap(Map<String, dynamic> map) => PracticeLog(
        id: map['id'] as int?,
        sessionId: map['sessionId'] as String? ?? '',
        title: map['title'] as String? ?? '',
        minutes: map['minutes'] as int? ?? 0,
        completedAt: map['completedAt'] as String? ?? '',
      );
}

class JournalEntry {
  final int? id;
  final String mood;
  final String prompt;
  final String body;
  final String createdAt;

  const JournalEntry({
    this.id,
    required this.mood,
    required this.prompt,
    required this.body,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'mood': mood,
        'prompt': prompt,
        'body': body,
        'createdAt': createdAt,
      };

  factory JournalEntry.fromMap(Map<String, dynamic> map) => JournalEntry(
        id: map['id'] as int?,
        mood: map['mood'] as String? ?? 'ember',
        prompt: map['prompt'] as String? ?? '',
        body: map['body'] as String? ?? '',
        createdAt: map['createdAt'] as String? ?? '',
      );
}
