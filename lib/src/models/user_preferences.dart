class UserPreferences {
  final String theme;
  final String aspect; // ease, sleep, stretch, sit
  final int minutes;
  final String grain; // smooth, even, rough
  final bool showOnboarding;

  UserPreferences({
    this.theme = 'light',
    this.aspect = 'ease',
    this.minutes = 19,
    this.grain = 'even',
    this.showOnboarding = true,
  });

  Map<String, dynamic> toMap() => {
        'theme': theme,
        'aspect': aspect,
        'minutes': minutes,
        'grain': grain,
        'showOnboarding': showOnboarding ? 1 : 0,
      };

  factory UserPreferences.fromMap(Map<String, dynamic> map) => UserPreferences(
        theme: map['theme'] as String? ?? 'light',
        aspect: map['aspect'] as String? ?? 'ease',
        minutes: map['minutes'] as int? ?? 19,
        grain: map['grain'] as String? ?? 'even',
        showOnboarding: (map['showOnboarding'] as int? ?? 1) == 1,
      );

  UserPreferences copyWith({
    String? theme,
    String? aspect,
    int? minutes,
    String? grain,
    bool? showOnboarding,
  }) {
    return UserPreferences(
      theme: theme ?? this.theme,
      aspect: aspect ?? this.aspect,
      minutes: minutes ?? this.minutes,
      grain: grain ?? this.grain,
      showOnboarding: showOnboarding ?? this.showOnboarding,
    );
  }
}
