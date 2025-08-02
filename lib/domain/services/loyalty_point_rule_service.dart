import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/loyalty_point_rule.dart';

class LoyaltyPointRuleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLoyaltyPointRule(LoyaltyPointRule rule) async {
    await _firestore.collection('loyalty_point_rules').add(rule.toMap());
  }

  Future<List<LoyaltyPointRule>> getLoyaltyPointRules() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('loyalty_point_rules').get();
    return snapshot.docs
        .map((doc) =>
            LoyaltyPointRule.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updateLoyaltyPointRule(LoyaltyPointRule rule) async {
    await _firestore
        .collection('loyalty_point_rules')
        .doc(rule.id)
        .update(rule.toMap());
  }
}
