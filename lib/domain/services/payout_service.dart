import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/payout.dart';

class PayoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPayout(Payout payout) async {
    await _firestore.collection('payouts').add(payout.toMap());
  }

  Future<List<Payout>> getPayouts() async {
    final QuerySnapshot snapshot = await _firestore.collection('payouts').get();
    return snapshot.docs
        .map((doc) => Payout.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updatePayoutStatus(String id, String status) async {
    await _firestore.collection('payouts').doc(id).update({'status': status});
  }
}
