import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/referral_reward.dart';

class ReferralRewardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _docId = 'referral_reward'; // Use a fixed ID for the reward

  Future<ReferralReward?> getReferralReward() async {
    final DocumentSnapshot doc =
        await _firestore.collection('settings').doc(_docId).get();
    if (doc.exists) {
      return ReferralReward.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updateReferralReward(ReferralReward reward) async {
    await _firestore
        .collection('settings')
        .doc(_docId)
        .set(reward.toMap());
  }
}
