class UserPreferences {
  final String theme;
  final String glaze; // ease, sleep, stretch, sit
  final int minutes;
  final String bisque; // soft, even, fired
  final bool showOnboarding;

  UserPreferences({
    this.theme = 'light',
    this.glaze = 'ease',
    this.minutes = 18,
    this.bisque = 'even',
    this.showOnboarding = true,
  });

  Map<String, dynamic> toMap() => {
        'theme': theme,
        'glaze': glaze,
        'minutes': minutes,
        'bisque': bisque,
        'showOnboarding': showOnboarding ? 1 : 0,
      };

  factory UserPreferences.fromMap(Map<String, dynamic> map) => UserPreferences(
        theme: map['theme'] as String? ?? 'light',
        glaze: map['glaze'] as String? ?? 'ease',
        minutes: map['minutes'] as int? ?? 18,
        bisque: map['bisque'] as String? ?? 'even',
        showOnboarding: (map['showOnboarding'] as int? ?? 1) == 1,
      );

  UserPreferences copyWith({
    String? theme,
    String? glaze,
    int? minutes,
    String? bisque,
    bool? showOnboarding,
  }) {
    return UserPreferences(
      theme: theme ?? this.theme,
      glaze: glaze ?? this.glaze,
      minutes: minutes ?? this.minutes,
      bisque: bisque ?? this.bisque,
      showOnboarding: showOnboarding ?? this.showOnboarding,
    );
  }
}
