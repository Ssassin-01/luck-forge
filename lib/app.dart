import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'storage/storage_service.dart';
import 'domain/models/game_state.dart';
import 'domain/models/settings_state.dart';
import 'state/game_controller.dart';
import 'state/settings_controller.dart';

import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';

class App extends StatelessWidget {
  final StorageService storage;
  final GameState initialGameState;
  final SettingsState initialSettingsState;

  const App({
    super.key,
    required this.storage,
    required this.initialGameState,
    required this.initialSettingsState,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GameController(storage, initialGameState),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsController(storage, initialSettingsState),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Consumer<GameController>(
          builder: (context, game, _) {
            return game.isOnboarded
                ? const HomeScreen()
                : const OnboardingScreen();
          },
        ),
      ),
    );
  }
}
