import 'package:flutter/material.dart';

enum Attribute { none, water, fire, wind, light, dark }

extension AttributeExt on Attribute {
  String getTierName(int tier) {
    final Map<Attribute, List<String>> tierNames = {
      Attribute.water: [' ','넝실거리는', '출렁이는', '거대한', '대양의', '심해의'],
      Attribute.fire: [' ','후끈거리는', '화끈거리는', '불타는', '재의', '지옥불의'],
      Attribute.wind: [' ','휘몰아치는', '날카로운', '폭풍의', '재앙의', '천둥의'],
      Attribute.light: [' ','빛의', '찬란한', '성스러운', '신성한', '천상의'],
      Attribute.dark: [' ', '어둠의', '그림자의', '심연의', '파멸의', '암흑의'],
      Attribute.none: [' ', '묵직한', '무거운', '단단한', '강력한', '전설적인'],
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
    final names = ['목검', '강철검', '황금검', '다이아검', '전설의 검','신화검'];
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