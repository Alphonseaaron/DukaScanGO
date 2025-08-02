import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/loyalty_system.dart';

class LoyaltySystemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLoyaltySystem(LoyaltySystem loyaltySystem) async {
    await _firestore.collection('loyalty_systems').add(loyaltySystem.toMap());
  }

  Future<List<LoyaltySystem>> getLoyaltySystems() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('loyalty_systems').get();
    return snapshot.docs
        .map((doc) =>
            LoyaltySystem.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updateLoyaltySystem(LoyaltySystem loyaltySystem) async {
    await _firestore
        .collection('loyalty_systems')
        .doc(loyaltySystem.id)
        .update(loyaltySystem.toMap());
  }
}
