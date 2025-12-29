import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 전문 폴더 구조에 따른 임포트 경로
import '../../domain/models/weapon.dart';
import '../../domain/models/upgrade_log.dart'; // 새롭게 추가된 로그 모델
import '../../domain/services/upgrade_service.dart';
import '../../state/game_controller.dart';
import '../../core/utils/debug_options.dart';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({super.key});

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  late Weapon _weapon;
  final _service = UpgradeService();

  @override
  void initState() {
    super.initState();
    // 초기 랜덤 속성 부여 및 무기 생성
    final randomAttr = Attribute.values[Random().nextInt(Attribute.values.length - 1) + 1];
    _weapon = Weapon(id: 'w1', name: '초보자검', attributes: [randomAttr]);
  }

  /// 강화 실행 핸들러
  void _handleUpgrade() {
    final game = context.read<GameController>();
    final cost = _service.costForLevel(_weapon.level);
    final int beforeLevel = _weapon.level; // 로그 기록용 이전 레벨

    // 1. 골드 체크 (디버그 모드 제외)
    if (!DebugOptions.freeUpgrade && game.state.gold < cost) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('골드가 부족합니다!')));
      return;
    }

    // 2. 골드 차감
    if (!DebugOptions.freeUpgrade) game.addGold(-cost);
    
    // 3. 강화 엔진 실행
    final result = _service.enhance(_weapon);

    // 4. 📝 강화 내역(Log) 생성 및 저장
    final newLog = UpgradeLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      weaponName: _weapon.displayName,
      beforeLevel: beforeLevel,
      afterLevel: result.item.level,
      success: result.success,
      cost: result.cost,
      timestamp: DateTime.now(),
    );
    game.addUpgradeLog(newLog); // GameController를 통해 상태에 추가

    // 5. 화면 UI 업데이트
    setState(() { _weapon = result.item; });

    // 6. 결과 피드백 알림
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        backgroundColor: result.success ? Colors.green : Colors.red,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 실시간 데이터 감시 (골드)
    final currentGold = context.watch<GameController>().state.gold;
    final cost = _service.costForLevel(_weapon.level);

    // ✨ 게이지 및 텍스트 빛 강도 계산 (0.1 ~ 1.0)
    double intensity = (_weapon.displayLevel / 10.0).clamp(0.1, 1.0);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('보유 골드: $currentGold', 
                 style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 디버그 모드 인디케이터
            if (DebugOptions.alwaysSuccess)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(8),
                color: Colors.red,
                child: const Text('치트 모드 활성화: 확률 100%', 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            
            // 무기 이름 표시 (발광 효과 포함)
            Text(
              _weapon.displayName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36, 
                fontWeight: FontWeight.w900, 
                color: _weapon.textColor, 
                shadows: _weapon.glowShadows
              ),
            ),
            const SizedBox(height: 10),
            Text('${_weapon.tier}티어 무기 (${_weapon.name})', 
                 style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 50),

            // 📊 점점 빛나는 진화 게이지 영역
            Column(
              children: [
                Container(
                  width: 280,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: intensity,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: _weapon.tierColor,
                        borderRadius: BorderRadius.circular(7),
                        boxShadow: [
                          // 단계가 오를수록 그림자가 더 넓고 진해짐
                          BoxShadow(
                            color: _weapon.tierColor.withOpacity(0.3 + (intensity * 0.6)), 
                            blurRadius: 4.0 + (intensity * 16.0), 
                            spreadRadius: intensity * 2.0,
                          ),
                          if (_weapon.displayLevel >= 7)
                            BoxShadow(
                              color: Colors.white.withOpacity(intensity * 0.5),
                              blurRadius: 2.0,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('진화 에너지: ${(_weapon.displayLevel * 10)}%', 
                  style: TextStyle(
                    color: Color.lerp(Colors.white70, _weapon.tierColor, intensity),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: _weapon.tierColor.withOpacity(intensity), blurRadius: 2)]
                  )),
              ],
            ),

            const SizedBox(height: 80),

            // 강화 실행 버튼
            ElevatedButton(
              onPressed: _handleUpgrade,
              style: ElevatedButton.styleFrom(
                backgroundColor: _weapon.tierColor,
                minimumSize: const Size(220, 70),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
              ),
              child: Text(
                _weapon.displayLevel == 10 ? '티어 승급 시도!' : '강 화 하 기 ($cost G)', 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ),
      ),
      
      // 개발자 모드 제어 버튼
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: DebugOptions.alwaysSuccess ? Colors.red : Colors.grey[800],
        child: const Icon(Icons.bug_report, size: 40, color: Colors.white),
        onPressed: () {
          setState(() {
            DebugOptions.alwaysSuccess = !DebugOptions.alwaysSuccess;
            DebugOptions.freeUpgrade = DebugOptions.alwaysSuccess;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(DebugOptions.alwaysSuccess ? "개발자 모드 ON (확률 100%)" : "개발자 모드 OFF"),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}