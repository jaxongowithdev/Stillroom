class UserPreferences {
  final String theme; // light, dark, system
  final String aim; // unwind, sleep, stretch, sit
  final int minutes;
  final String bodyFeel; // tender, even, ready
  final bool showOnboarding;

  UserPreferences({
    this.theme = 'dark',
    this.aim = 'unwind',
    this.minutes = 14,
    this.bodyFeel = 'even',
    this.showOnboarding = true,
  });

  Map<String, dynamic> toMap() => {
        'theme': theme,
        'aim': aim,
        'minutes': minutes,
        'bodyFeel': bodyFeel,
        'showOnboarding': showOnboarding ? 1 : 0,
      };

  factory UserPreferences.fromMap(Map<String, dynamic> map) => UserPreferences(
        theme: map['theme'] as String? ?? 'dark',
        aim: map['aim'] as String? ?? 'unwind',
        minutes: map['minutes'] as int? ?? 14,
        bodyFeel: map['bodyFeel'] as String? ?? 'even',
        showOnboarding: (map['showOnboarding'] as int? ?? 1) == 1,
      );

  UserPreferences copyWith({
    String? theme,
    String? aim,
    int? minutes,
    String? bodyFeel,
    bool? showOnboarding,
  }) {
    return UserPreferences(
      theme: theme ?? this.theme,
      aim: aim ?? this.aim,
      minutes: minutes ?? this.minutes,
      bodyFeel: bodyFeel ?? this.bodyFeel,
      showOnboarding: showOnboarding ?? this.showOnboarding,
    );
  }
}
