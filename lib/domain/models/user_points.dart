class UserPoints {
  final String? id;
  final String userId;
  final int points;

  UserPoints({
    this.id,
    required this.userId,
    required this.points,
  });

  factory UserPoints.fromMap(Map<String, dynamic> map, String id) {
    return UserPoints(
      id: id,
      userId: map['userId'],
      points: map['points'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'points': points,
    };
  }
}
