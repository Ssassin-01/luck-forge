import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/enhancement_service.dart';

class EnhancementScreen extends StatefulWidget {
  const EnhancementScreen({super.key});
  @override
  State<EnhancementScreen> createState() => _EnhancementScreenState();
}

class _EnhancementScreenState extends State<EnhancementScreen> {
  late Item _item;
  late EnhancementService _service;

  @override
  void initState() {
    super.initState();
    _item = const Item(id: 'sword_001', name: '낡은 목검', level: 0, maxLevel: 70);
    _service = EnhancementService();
  }

  void _tryEnhance() {
    final result = _service.enhance(_item);
    setState(() { _item = result.item; });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${result.message} (비용: ${result.cost})'),
        backgroundColor: result.success ? Colors.green : Colors.red,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nextChance = _item.isMaxed ? '-' : '${_service.successRateForLevel(_item.level)}%';
    final nextCost = _item.isMaxed ? '-' : '${_service.costForLevel(_item.level)}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Luck Forge', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이템 이름
            Text(
              _item.displayName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: _item.tierColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            // 티어 정보
            Text(
              _item.subTitle,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 50),
            
            // 정보 패널
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStat('확률', nextChance),
                  const SizedBox(width: 40),
                  _buildStat('골드', nextCost),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // 강화 버튼
            SizedBox(
              width: 220,
              height: 64,
              child: ElevatedButton(
                onPressed: _item.isMaxed ? null : _tryEnhance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _item.tierColor,
                  foregroundColor: Colors.white,
                  elevation: 5,
                  // 수정된 부분: .withOpacity 대신 .withAlpha 사용 (또는 .withValues)
                  shadowColor: _item.tierColor.withAlpha(128), // 255의 절반인 128이 약 0.5 opacity
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: Text(
                  _item.displayLevel == 10 ? '티어 승급!' : '강화하기',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String l, String v) => Column(
    children: [
      Text(l, style: const TextStyle(color: Colors.grey)),
      Text(v, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    ],
  );
}