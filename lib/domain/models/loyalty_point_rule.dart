class LoyaltyPointRule {
  final String? id;
  final String action; // 'purchase', 'review'
  final int points;

  LoyaltyPointRule({
    this.id,
    required this.action,
    required this.points,
  });

  factory LoyaltyPointRule.fromMap(Map<String, dynamic> map, String id) {
    return LoyaltyPointRule(
      id: id,
      action: map['action'],
      points: map['points'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'points': points,
    };
  }
}
