class ReferralReward {
  final String? id;
  final double amount;

  ReferralReward({
    this.id,
    required this.amount,
  });

  factory ReferralReward.fromMap(Map<String, dynamic> map, String id) {
    return ReferralReward(
      id: id,
      amount: map['amount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
    };
  }
}
