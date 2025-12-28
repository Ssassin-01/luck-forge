import 'dart:math';
import '../models/item.dart';

class EnhancementResult {
  final bool success;
  final Item item;
  final int cost;
  final String message;

  EnhancementResult({required this.success, required this.item, required this.cost, required this.message});
}

class EnhancementService {
  static const List<int> _successRates = [100];
  final Random _random = Random();

  int costForLevel(int level) => 100 * (level + 1);

  int successRateForLevel(int level) {
    int step = level % 10;
    return _successRates[step.clamp(0, _successRates.length - 1)];
  }

  static const Map<Attribute, int> _attributeWeights = {
    Attribute.water: 20, Attribute.fire: 20, Attribute.wind: 20,
    Attribute.light: 10, Attribute.dark: 10,
  };

  EnhancementResult enhance(Item item) {
    if (item.isMaxed) return EnhancementResult(success: false, item: item, cost: 0, message: '최대 강화 단계입니다.');

    final cost = costForLevel(item.level);
    final rate = successRateForLevel(item.level);
    final success = _random.nextDouble() < (rate / 100.0);

    int newLevel = success ? (item.level + 1) : (item.level - 1);
    newLevel = newLevel.clamp(0, item.maxLevel);
    var newItem = item.copyWith(level: newLevel);
    String extraMsg = '';

    // --- 속성 고정 로직 ---
    // 1. 성공해서 레벨이 10의 배수가 되었을 때 (승급 시점)
    // 2. 그리고 아직 아이템에 속성이 없을 때만 새로 부여!
    if (success && (newLevel > 0 && newLevel % 10 == 0)) {
      if (newItem.attributes.isEmpty) {
        final newAttr = _pickRandomAttribute();
        if (newAttr != null) {
          newItem = newItem.copyWith(attributes: [newAttr]);
          extraMsg = ' [신비한 속성 발현!]';
        }
      } else {
        // 이미 속성이 있다면? 아무것도 안 함 (기존 속성 유지)
        extraMsg = ' [속성 공명!]';
      }
    }

    return EnhancementResult(
      success: success,
      item: newItem,
      cost: cost,
      message: success ? '성공! +${newItem.displayLevel}$extraMsg' : '실패... +${newItem.displayLevel}',
    );
  }

  Attribute? _pickRandomAttribute() {
    final totalWeight = _attributeWeights.values.fold(0, (sum, w) => sum + w);
    int r = _random.nextInt(totalWeight);
    int current = 0;
    for (var entry in _attributeWeights.entries) {
      current += entry.value;
      if (r < current) return entry.key;
    }
    return null;
  }
}