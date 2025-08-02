import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/user_referral.dart';

class UserReferralService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserReferral(UserReferral userReferral) async {
    await _firestore.collection('user_referrals').add(userReferral.toMap());
  }

  Future<UserReferral?> getUserReferral(String userId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('user_referrals')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      return UserReferral.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<UserReferral?> getUserReferralByCode(String referralCode) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('user_referrals')
        .where('referralCode', isEqualTo: referralCode)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      return UserReferral.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updateUserReferral(UserReferral userReferral) async {
    await _firestore
        .collection('user_referrals')
        .doc(userReferral.id)
        .update(userReferral.toMap());
  }
}
