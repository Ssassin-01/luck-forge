import 'package:flutter/material.dart';

/// 무기 및 장비의 속성을 정의하는 Enum
enum Attribute { none, water, fire, wind, light, dark, time }

/// Attribute에 색상 및 티어별 수식어 기능을 추가하는 확장(Extension)
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

  String getTierName(int tier) {
    final Map<Attribute, List<String>> tierNames = {
      Attribute.water: [' ', '넝실거리는', '출렁이는', '거대한', '대양의', '심해의'],
      Attribute.fire: [' ', '후끈거리는', '화끈거리는', '불타는', '재의', '지옥불의'],
      Attribute.wind: [' ', '휘몰아치는', '날카로운', '폭풍의', '재앙의', '천둥의'],
      Attribute.light: [' ', '빛의', '찬란한', '성스러운', '신성한', '천상의'],
      Attribute.dark: [' ', '어둠의', '그림자의', '심연의', '파멸의', '암흑의'],
      Attribute.none: [' ', ' ', ' ', ' ', ' ', ' '],
      Attribute.time: [' ', '시간의', '시공간의', '차원 파괴자의', '미래 초월자의', '영겁의'],
    };

    final names = tierNames[this] ?? [];
    if (names.isEmpty) return '';
    return names[(tier - 1).clamp(0, names.length - 1)];
  }
}

class Item {
  final String id;
  final String name;
  final int level;
  final int maxLevel;
  final List<Attribute> attributes;

  const Item({
    required this.id,
    required this.name,
    this.level = 0,
    this.maxLevel = 100,
    this.attributes = const [],
  });

  int get tier => (level ~/ 10) + 1;
  int get displayLevel => (level % 10) + 1;

  // --- 추가된 글자색 로직 ---

  /// 티어가 올라감에 따라 흰색에서 속성색으로 변하는 컬러
  Color get textColor {
    if (attributes.isEmpty || attributes.first == Attribute.none) return Colors.white;

    final attrColor = attributes.first.color;
    
    // 티어 진행도 (1티어: 0.0 ~ 6티어: 1.0)
    double tierProgress = (tier - 1) / 5.0; 
    tierProgress = tierProgress.clamp(0.0, 1.0);

    // 흰색에서 속성색으로 선형 보간 (점점 물드는 효과)
    return Color.lerp(Colors.white, attrColor, tierProgress) ?? Colors.white;
  }

  // --- 시각 효과 로직 ---

  List<Shadow> get glowShadows {
    if (attributes.isEmpty || attributes.first == Attribute.none) return [];

    final baseColor = attributes.first.color;
    double intensity = (displayLevel - 1) / 9.0; 
    double blur = 5.0 + (intensity * 15.0); 
    Color glowColor = baseColor.withOpacity(0.3 + (intensity * 0.7));

    return [
      Shadow(blurRadius: blur, color: glowColor),
      if (displayLevel >= 5) 
        Shadow(blurRadius: blur / 2, color: glowColor),
      if (displayLevel == 10) 
        const Shadow(blurRadius: 2.0, color: Colors.white),
    ];
  }

  Color get tierColor {
    switch (tier) {
      case 1: return Colors.grey;
      case 2: return Colors.black;
      case 3: return Colors.green;
      case 4: return Colors.blue;
      case 5: return Colors.purple;
      default: return Colors.orange;
    }
  }

  String get tierName {
    final names = ['목검', '강철검', '황금검', '다이아검', '전설의 검', '신화검'];
    final idx = (tier - 1).clamp(0, names.length - 1);
    return names[idx];
  }

  String get attributePrefix {
    if (attributes.isEmpty) return '';
    final mainAttr = attributes.first;
    if (mainAttr == Attribute.none) return '';
    return '${mainAttr.getTierName(tier)} ';
  }

  String get displayName => '$attributePrefix$tierName';
  String get subTitle => '($name) - $tier티어 $displayLevel단계';

  Item copyWith({String? id, String? name, int? level, int? maxLevel, List<Attribute>? attributes}) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      maxLevel: maxLevel ?? this.maxLevel,
      attributes: attributes ?? this.attributes,
    );
  }

  bool get isMaxed => level >= maxLevel;
}