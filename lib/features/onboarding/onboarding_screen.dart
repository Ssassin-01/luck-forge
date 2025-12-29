import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/game_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.read<GameController>();

    return Scaffold(
      appBar: AppBar(title: const Text('LuckForge - Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('닉네임을 입력해줘!'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLength: 12,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '예) JeongHyeon',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty) return;
                await game.setNickname(name);
              },
              child: const Text('시작하기'),
            ),
          ],
        ),
      ),
    );
  }
}
