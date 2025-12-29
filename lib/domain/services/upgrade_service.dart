import 'dart:math';
import '../models/weapon.dart';
import '../../core/utils/debug_options.dart'; // 디버그 설정 임포트

class UpgradeResult {
  final Weapon item;
  final bool success;
  final String message;
  final int cost;
  UpgradeResult({required this.item, required this.success, required this.message, required this.cost});
}

class UpgradeService {
  int costForLevel(int level) => (level + 1) * 100;
  
  UpgradeResult enhance(Weapon weapon) {
    // 1. 디버그 모드의 '항상 성공'이 켜져 있으면 true, 아니면 확률 계산
    final bool success = DebugOptions.alwaysSuccess 
        ? true 
        : Random().nextInt(100) < max(10, 100 - (weapon.level * 5));

    // 2. 디버그 모드의 '무료 강화'가 켜져 있으면 비용 0원
    final int cost = DebugOptions.freeUpgrade ? 0 : costForLevel(weapon.level);

    return success 
      ? UpgradeResult(
          item: weapon.copyWith(level: weapon.level + 1), 
          success: true, 
          message: DebugOptions.alwaysSuccess ? "[DEV] 치트 강화 성공!" : "성공!", 
          cost: cost,
        )
      : UpgradeResult(
          item: weapon, 
          success: false, 
          message: "실패...", 
          cost: cost,
        );
  }
}