import 'dart:math';
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
    
    final random = Random();
    final availableAttributes = Attribute.values.where((a) => a != Attribute.none).toList();
    final randomAttribute = availableAttributes[random.nextInt(availableAttributes.length)];

    // 1. 여기서 const를 제거했습니다. (랜덤 ID와 속성 때문)
    _item = Item(
      id: 'sword_${DateTime.now().millisecondsSinceEpoch}', 
      name: '낡은 목검', 
      level: 0, 
      maxLevel: 100,
      attributes: [randomAttribute],
    );
    
    _service = EnhancementService();
  }

  void _tryEnhance() {
    final result = _service.enhance(_item);
    setState(() { 
      _item = result.item; 
    });

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('LUCK FORGE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _item.displayName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 38,
                // 2. FontWeight.black 대신 w900 사용
                fontWeight: FontWeight.w900, 
                color: _item.textColor,
                shadows: _item.glowShadows,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _item.subTitle,
              // 3. withOpacity 대신 최신 문법인 withValues 사용
              style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.5)),
            ),
            
            const SizedBox(height: 60),
            
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                // 여기도 최신 문법으로 수정
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStat('성공 확률', nextChance),
                  Container(width: 1, height: 40, color: Colors.white10, margin: const EdgeInsets.symmetric(horizontal: 30)),
                  _buildStat('필요 골드', nextCost),
                ],
              ),
            ),
            
            const SizedBox(height: 60),

            SizedBox(
              width: 240,
              height: 70,
              child: ElevatedButton(
                onPressed: _item.isMaxed ? null : _tryEnhance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _item.tierColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  _item.displayLevel == 10 ? '티어 승급 시도!' : '강 화 하 기',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
      // 4. 모든 withOpacity를 withValues로 수정
      Text(l, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
      const SizedBox(height: 5),
      Text(v, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
    ],
  );
}