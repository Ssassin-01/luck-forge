import 'package:flutter/foundation.dart';
import '../domain/models/game_state.dart';
import '../storage/storage_service.dart';
// lib/state/game_controller.dart (기존 코드에 추가)

import '../domain/models/upgrade_log.dart';

class GameController extends ChangeNotifier {

  final List<UpgradeLog> _upgradeLogs = [];
  List<UpgradeLog> get upgradeLogs => List.unmodifiable(_upgradeLogs);

  // 2. 로그 추가 함수
  void addUpgradeLog(UpgradeLog log) {
    _upgradeLogs.insert(0, log); // 최신 로그가 맨 앞으로 오게 추가
    notifyListeners();
    
    // TODO: 여기서 storage_service.dart를 호출해 Hive에 실제 저장할 수 있습니다.
  }

  final StorageService _storage;
  GameState _state;

  GameController(this._storage, this._state);

  GameState get state => _state;

  bool get isOnboarded => _state.nickname.trim().isNotEmpty;

  Future<void> setNickname(String nickname) async {
    _state = _state.copyWith(nickname: nickname.trim());
    await _storage.saveGameState(_state);
    notifyListeners();
  }

  Future<void> addGold(int amount) async {
    _state = _state.copyWith(gold: _state.gold + amount);
    await _storage.saveGameState(_state);
    notifyListeners();
  }
}
