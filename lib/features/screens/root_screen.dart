import 'package:flutter/material.dart';
// 1. 파일 경로는 목표 구조에 맞게 유지합니다.
import '../upgrade/upgrade_screen.dart'; 

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luck Forge', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('강화의 세계에 오신 것을 환영합니다!'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
              ),
              // 2. 클래스 이름을 EnhancementScreen에서 UpgradeScreen으로 일치시킵니다.
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const UpgradeScreen()),
              ),
              child: const Text('강화소 입장 (Upgrade)', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}