class GameState {
  final String nickname;
  final int gold;
  final int stone;

  const GameState({
    required this.nickname,
    required this.gold,
    required this.stone,
  });

  factory GameState.initial() =>
      const GameState(nickname: '', gold: 1000, stone: 10);

  GameState copyWith({String? nickname, int? gold, int? stone}) {
    return GameState(
      nickname: nickname ?? this.nickname,
      gold: gold ?? this.gold,
      stone: stone ?? this.stone,
    );
  }

  Map<String, dynamic> toJson() => {
    'nickname': nickname,
    'gold': gold,
    'stone': stone,
  };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
    nickname: (json['nickname'] ?? '') as String,
    gold: (json['gold'] ?? 0) as int,
    stone: (json['stone'] ?? 0) as int,
  );
}
