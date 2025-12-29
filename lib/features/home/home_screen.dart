import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/game_controller.dart';
import '../upgrade/upgrade_screen.dart'; // 목표 구조에 따른 경로

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // GameController 상태 감시
    final game = context.watch<GameController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Luck Forge', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 정보 영역
            _buildUserStats(game),
            
            const SizedBox(height: 30),
            
            // 골드 획득 테스트 버튼
            ElevatedButton.icon(
              onPressed: () => game.addGold(100),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('무료 골드 받기 (+100)'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
            
            const SizedBox(height: 15),

            // --- 강화소 입장 버튼 (핵심) ---
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // 다크한 강화소 느낌
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UpgradeScreen()),
                  );
                },
                child: const Text('⚒️ 장비 강화소 입장', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStats(GameController game) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(child: Icon(Icons.person)),
              const SizedBox(width: 15),
              Text(game.state.nickname, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('💰 Gold', '${game.state.gold}'),
              _buildStatItem('💎 Stone', '${game.state.stone}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}