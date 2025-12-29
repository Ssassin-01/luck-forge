import 'package:flutter/foundation.dart';
import '../domain/models/game_state.dart';
import '../storage/storage_service.dart';

class GameController extends ChangeNotifier {
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
