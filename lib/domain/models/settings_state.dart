class SettingsState {
  final bool soundEnabled;
  final bool hapticEnabled;

  const SettingsState({
    required this.soundEnabled,
    required this.hapticEnabled,
  });

  factory SettingsState.initial() =>
      const SettingsState(soundEnabled: true, hapticEnabled: true);

  SettingsState copyWith({bool? soundEnabled, bool? hapticEnabled}) {
    return SettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
    'soundEnabled': soundEnabled,
    'hapticEnabled': hapticEnabled,
  };

  factory SettingsState.fromJson(Map<String, dynamic> json) => SettingsState(
    soundEnabled: (json['soundEnabled'] ?? true) as bool,
    hapticEnabled: (json['hapticEnabled'] ?? true) as bool,
  );
}
