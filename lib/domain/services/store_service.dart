import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/user.dart';

class StoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<User>> getStores() async {
    final QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('rolId', isEqualTo: '1') // Assuming '1' is for store owner
        .get();
    return snapshot.docs
        .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
