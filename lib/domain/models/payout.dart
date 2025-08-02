class Payout {
  final String? id;
  final String userId;
  final String userType; // 'store', 'wholesaler', 'agent'
  final double amount;
  final String status; // 'pending', 'completed', 'failed'
  final DateTime date;

  Payout({
    this.id,
    required this.userId,
    required this.userType,
    required this.amount,
    required this.status,
    required this.date,
  });

  factory Payout.fromMap(Map<String, dynamic> map, String id) {
    return Payout(
      id: id,
      userId: map['userId'],
      userType: map['userType'],
      amount: map['amount'],
      status: map['status'],
      date: map['date'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userType': userType,
      'amount': amount,
      'status': status,
      'date': date,
    };
  }
}
