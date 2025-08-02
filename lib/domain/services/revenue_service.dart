import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/revenue.dart';

class RevenueService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRevenue(Revenue revenue) async {
    await _firestore.collection('revenue').add(revenue.toMap());
  }

  Future<List<Revenue>> getRevenue() async {
    final QuerySnapshot snapshot = await _firestore.collection('revenue').get();
    return snapshot.docs
        .map((doc) => Revenue.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
