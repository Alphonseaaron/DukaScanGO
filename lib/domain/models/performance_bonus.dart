class PerformanceBonus {
  final String? id;
  final String userId;
  final String description;
  final double amount;
  final DateTime date;

  PerformanceBonus({
    this.id,
    required this.userId,
    required this.description,
    required this.amount,
    required this.date,
  });

  factory PerformanceBonus.fromMap(Map<String, dynamic> map, String id) {
    return PerformanceBonus(
      id: id,
      userId: map['userId'],
      description: map['description'],
      amount: map['amount'],
      date: map['date'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'description': description,
      'amount': amount,
      'date': date,
    };
  }
}
