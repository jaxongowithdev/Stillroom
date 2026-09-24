class UserPreferences {
  final String theme;
  final String wash; // ease, sleep, stretch, sit
  final int minutes;
  final String tooth; // fine, even, coarse
  final bool showOnboarding;

  UserPreferences({
    this.theme = 'light',
    this.wash = 'ease',
    this.minutes = 17,
    this.tooth = 'even',
    this.showOnboarding = true,
  });

  Map<String, dynamic> toMap() => {
        'theme': theme,
        'wash': wash,
        'minutes': minutes,
        'tooth': tooth,
        'showOnboarding': showOnboarding ? 1 : 0,
      };

  factory UserPreferences.fromMap(Map<String, dynamic> map) => UserPreferences(
        theme: map['theme'] as String? ?? 'light',
        wash: map['wash'] as String? ?? 'ease',
        minutes: map['minutes'] as int? ?? 17,
        tooth: map['tooth'] as String? ?? 'even',
        showOnboarding: (map['showOnboarding'] as int? ?? 1) == 1,
      );

  UserPreferences copyWith({
    String? theme,
    String? wash,
    int? minutes,
    String? tooth,
    bool? showOnboarding,
  }) {
    return UserPreferences(
      theme: theme ?? this.theme,
      wash: wash ?? this.wash,
      minutes: minutes ?? this.minutes,
      tooth: tooth ?? this.tooth,
      showOnboarding: showOnboarding ?? this.showOnboarding,
    );
  }
}
