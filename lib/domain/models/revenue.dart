class Revenue {
  final String? id;
  final String source; // 'commissions', 'fees', 'ad_revenue'
  final double amount;
  final DateTime date;

  Revenue({
    this.id,
    required this.source,
    required this.amount,
    required this.date,
  });

  factory Revenue.fromMap(Map<String, dynamic> map, String id) {
    return Revenue(
      id: id,
      source: map['source'],
      amount: map['amount'],
      date: map['date'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'source': source,
      'amount': amount,
      'date': date,
    };
  }
}
