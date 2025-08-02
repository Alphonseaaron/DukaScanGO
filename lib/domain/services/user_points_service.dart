import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/user_points.dart';

class UserPointsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserPoints(UserPoints userPoints) async {
    await _firestore.collection('user_points').add(userPoints.toMap());
  }

  Future<UserPoints?> getUserPoints(String userId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('user_points')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      return UserPoints.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updateUserPoints(UserPoints userPoints) async {
    await _firestore
        .collection('user_points')
        .doc(userPoints.id)
        .update(userPoints.toMap());
  }
}
