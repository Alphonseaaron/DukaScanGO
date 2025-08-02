class UserReferral {
  final String? id;
  final String userId;
  final String referralCode;
  final List<String> referredUserIds;

  UserReferral({
    this.id,
    required this.userId,
    required this.referralCode,
    required this.referredUserIds,
  });

  factory UserReferral.fromMap(Map<String, dynamic> map, String id) {
    return UserReferral(
      id: id,
      userId: map['userId'],
      referralCode: map['referralCode'],
      referredUserIds: List<String>.from(map['referredUserIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'referralCode': referralCode,
      'referredUserIds': referredUserIds,
    };
  }
}
