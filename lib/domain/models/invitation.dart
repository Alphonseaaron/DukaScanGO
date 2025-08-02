import 'package:cloud_firestore/cloud_firestore.dart';

class Invitation {
  final String? id;
  final String storeId;
  final String userId;
  final String role;
  final List<String> permissions;
  final String status; // 'pending', 'accepted', 'declined'
  final DateTime dateInvited;
  final double? reward;

  Invitation({
    this.id,
    required this.storeId,
    required this.userId,
    required this.role,
    required this.permissions,
    required this.status,
    required this.dateInvited,
    this.reward,
  });

  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'userId': userId,
      'role': role,
      'permissions': permissions,
      'status': status,
      'dateInvited': dateInvited,
      'reward': reward,
    };
  }

  factory Invitation.fromMap(Map<String, dynamic> map, String id) {
    return Invitation(
      id: id,
      storeId: map['storeId'],
      userId: map['userId'],
      role: map['role'],
      permissions: List<String>.from(map['permissions']),
      status: map['status'],
      dateInvited: (map['dateInvited'] as Timestamp).toDate(),
      reward: map['reward'],
    );
  }
}
