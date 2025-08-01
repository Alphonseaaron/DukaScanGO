import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/restocking_request.dart';

class InventoryServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createRestockingRequest(RestockingRequest request) async {
    await _firestore.collection('restocking_requests').add(request.toMap());
  }

  Future<List<RestockingRequest>> getRestockingRequests() async {
    final snapshot = await _firestore.collection('restocking_requests').get();
    return snapshot.docs
        .map((doc) => RestockingRequest.fromMap(doc.data(), doc.id))
        .toList();
  }
}
