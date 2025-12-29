import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/game_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return Scaffold(
      appBar: AppBar(title: const Text('LuckForge')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👤 ${game.state.nickname}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('💰 Gold: ${game.state.gold}'),
            Text('💎 Stone: ${game.state.stone}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => game.addGold(100),
              child: const Text('테스트: 골드 +100 (저장됨)'),
            ),
            const SizedBox(height: 8),
            const Text('✅ 앱 껐다 켜도 골드가 유지되면 성공!'),
          ],
        ),
      ),
    );
  }
}
