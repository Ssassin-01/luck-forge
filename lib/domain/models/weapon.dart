import 'package:flutter/material.dart';

enum Attribute { none, water, fire, wind, light, dark, time }

extension AttributeExt on Attribute {
  Color get color {
    switch (this) {
      case Attribute.water: return Colors.blueAccent;
      case Attribute.fire: return Colors.redAccent;
      case Attribute.wind: return Colors.greenAccent;
      case Attribute.light: return Colors.amberAccent;
      case Attribute.dark: return Colors.deepPurpleAccent;
      case Attribute.time: return Colors.cyanAccent;
      case Attribute.none: return Colors.transparent;
    }
  }

  String getModifier(int tier) {
    final Map<Attribute, List<String>> modifiers = {
      Attribute.water: [' ', '넝실거리는', '출렁이는', '거대한', '대양의', '심해의'],
      Attribute.fire: [' ', '후끈거리는', '화끈거리는', '불타는', '재의', '지옥불의'],
      Attribute.wind: [' ', '휘몰아치는', '날카로운', '폭풍의', '재앙의', '천둥의'],
      Attribute.light: [' ', '빛의', '찬란한', '성스러운', '신성한', '천상의'],
      Attribute.dark: [' ', '어둠의', '그림자의', '심연의', '파멸의', '암흑의'],
      Attribute.time: [' ', '시간의', '시공간의', '차원 파괴자의', '미래 초월자의', '영겁의'],
      Attribute.none: [' ', ' ', ' ', ' ', ' ', ' '],
    };
    return modifiers[this]![(tier - 1).clamp(0, 5)];
  }
}

class Weapon {
  final String id;
  final String name; // 사용자가 지어준 고유 이름 (예: 초보자의 칼)
  final int level;
  final int maxLevel;
  final List<Attribute> attributes;

  const Weapon({
    required this.id,
    required this.name,
    this.level = 0,
    this.maxLevel = 100,
    this.attributes = const [],
  });

  // 0~9레벨은 1티어, 10~19레벨은 2티어...
  int get tier => (level ~/ 10) + 1;
  // 각 티어 내에서 1~10단계 표시
  int get displayLevel => (level % 10) + 1;

  // --- 핵심: 티어별 무기 진화 이름 ---
  String get baseNameByTier {
    const names = ['목검', '철검', '강철검', '황금검', '다이아검', '전설의 검'];
    return names[(tier - 1).clamp(0, names.length - 1)];
  }

  String get displayName {
    final prefix = attributes.isNotEmpty ? attributes.first.getModifier(tier) : '';
    return '$prefix $baseNameByTier'.trim();
  }

  // 시각적 효과 로직
  Color get tierColor {
    final colors = [Colors.grey, Colors.brown, Colors.blueGrey, Colors.amber, Colors.cyan, Colors.purple];
    return colors[(tier - 1).clamp(0, colors.length - 1)];
  }

  Color get textColor {
    if (attributes.isEmpty) return Colors.white;
    double progress = ((tier - 1) / 5.0).clamp(0.0, 1.0);
    return Color.lerp(Colors.white, attributes.first.color, progress) ?? Colors.white;
  }

  List<Shadow> get glowShadows {
    if (attributes.isEmpty) return [];
    double intensity = (displayLevel - 1) / 9.0;
    return [
      Shadow(blurRadius: 5.0 + (intensity * 15), color: attributes.first.color.withValues(alpha: 0.5 + (intensity * 0.5))),
    ];
  }

  Weapon copyWith({int? level}) => Weapon(id: id, name: name, level: level ?? this.level, attributes: attributes);
}