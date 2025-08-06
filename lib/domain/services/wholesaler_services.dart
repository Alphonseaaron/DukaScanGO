import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/wholesaler.dart';

class WholesalerServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addWholesaler(Wholesaler wholesaler) async {
    await _firestore
        .collection('wholesalers')
        .doc(wholesaler.uid)
        .set(wholesaler.toMap());
  }

  Future<Wholesaler?> getWholesalerById(String uid) async {
    final doc = await _firestore.collection('wholesalers').doc(uid).get();
    if (doc.exists) {
      return Wholesaler.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> updateWholesaler(Wholesaler wholesaler) async {
    await _firestore
        .collection('wholesalers')
        .doc(wholesaler.uid)
        .update(wholesaler.toMap());
  }
}
