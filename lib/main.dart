import 'package:flutter/material.dart';
import 'app.dart';
import 'storage/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  await storage.init();

  final game = await storage.loadGameState();
  final settings = await storage.loadSettingsState();

  runApp(
    App(
      storage: storage,
      initialGameState: game,
      initialSettingsState: settings,
    ),
  );
}
