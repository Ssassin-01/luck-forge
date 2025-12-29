// lib/domain/models/upgrade_log.dart

class UpgradeLog {
  final String id;
  final String weaponName;
  final int beforeLevel;
  final int afterLevel;
  final bool success;
  final int cost;
  final DateTime timestamp;

  UpgradeLog({
    required this.id,
    required this.weaponName,
    required this.beforeLevel,
    required this.afterLevel,
    required this.success,
    required this.cost,
    required this.timestamp,
  });

  // 요약된 로그 메시지 반환
  String get message {
    final status = success ? '성공' : '실패';
    return '[$status] $weaponName ($beforeLevel -> $afterLevel) | 비용: $cost G';
  }
}