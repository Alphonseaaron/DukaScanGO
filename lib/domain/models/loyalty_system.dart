class LoyaltySystem {
  final String? id;
  final String name;
  final String description;
  final Map<String, int> pointsRules; // e.g., {'purchase': 10, 'review': 5}
  final List<Map<String, dynamic>> rewards; // e.g., [{'name': 'Discount', 'points': 100}]

  LoyaltySystem({
    this.id,
    required this.name,
    required this.description,
    required this.pointsRules,
    required this.rewards,
  });

  factory LoyaltySystem.fromMap(Map<String, dynamic> map, String id) {
    return LoyaltySystem(
      id: id,
      name: map['name'],
      description: map['description'],
      pointsRules: Map<String, int>.from(map['pointsRules']),
      rewards: List<Map<String, dynamic>>.from(map['rewards']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'pointsRules': pointsRules,
      'rewards': rewards,
    };
  }
}
