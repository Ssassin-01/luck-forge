import 'package:hive_flutter/hive_flutter.dart';
import '../domain/models/game_state.dart';
import '../domain/models/settings_state.dart';

class StorageService {
  static const String _boxName = 'luckforge';
  static const String _gameKey = 'gameState';
  static const String _settingsKey = 'settingsState';

  late Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  Future<GameState> loadGameState() async {
    final raw = _box.get(_gameKey);
    if (raw is Map) return GameState.fromJson(Map<String, dynamic>.from(raw));
    return GameState.initial();
  }

  Future<void> saveGameState(GameState state) async {
    await _box.put(_gameKey, state.toJson());
  }

  Future<SettingsState> loadSettingsState() async {
    final raw = _box.get(_settingsKey);
    if (raw is Map) {
      return SettingsState.fromJson(Map<String, dynamic>.from(raw));
    }
    return SettingsState.initial();
  }

  Future<void> saveSettingsState(SettingsState state) async {
    await _box.put(_settingsKey, state.toJson());
  }

  Future<void> resetGame() async {
    await _box.delete(_gameKey);
  }

  Future<void> resetAll() async {
    await _box.clear();
  }
}
