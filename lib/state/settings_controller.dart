import 'package:flutter/foundation.dart';
import '../domain/models/settings_state.dart';
import '../storage/storage_service.dart';

class SettingsController extends ChangeNotifier {
  final StorageService _storage;
  SettingsState _state;

  SettingsController(this._storage, this._state);

  SettingsState get state => _state;

  Future<void> toggleSound(bool value) async {
    _state = _state.copyWith(soundEnabled: value);
    await _storage.saveSettingsState(_state);
    notifyListeners();
  }

  Future<void> toggleHaptic(bool value) async {
    _state = _state.copyWith(hapticEnabled: value);
    await _storage.saveSettingsState(_state);
    notifyListeners();
  }
}
