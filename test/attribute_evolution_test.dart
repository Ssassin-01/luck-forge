import 'package:flutter_test/flutter_test.dart';
import 'package:luck_forge/models/item.dart';
import 'package:luck_forge/services/enhancement_service.dart';

void main() {
  test('adds one attribute at level 10', () {
    final item = Item(id: 'i1', name: 'Wooden Sword', level: 9);
    var idx = 0;
    final seq = [0.0, 0.3]; // success, then pick water
    final service = EnhancementService(rand: () {
      if (idx < seq.length) return seq[idx++];
      return seq.last;
    });

    final result = service.enhance(item);
    expect(result.success, isTrue);
    expect(result.item.level, equals(10));
    expect(result.item.attributes.length, equals(1));
    expect(result.item.attributes.first, equals(Attribute.water));
  });

  test('may add two attributes at level 20 when random selects 2', () {
    final item = Item(id: 'i2', name: 'Wooden Sword', level: 19);
    var idx = 0;
    // sequence: success, choose count (0.6 -> 2), pick1(0.3->water), pick2(0.92->dark)
    final seq = [0.0, 0.6, 0.3, 0.92];
    final service = EnhancementService(rand: () {
      if (idx < seq.length) return seq[idx++];
      return seq.last;
    });

    final result = service.enhance(item);
    expect(result.success, isTrue);
    expect(result.item.level, equals(20));
    expect(result.item.attributes.length, greaterThanOrEqualTo(1));
    // If two attributes added, ensure unique
    if (result.item.attributes.length == 2) {
      expect(result.item.attributes[0], isNot(result.item.attributes[1]));
    }
  });
}
