import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant/domain/models/order.dart';

class OrdersServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addOrder(Order order) async {
    await _firestore.collection('orders').add(order.toMap());
  }

  Future<List<Order>> getOrdersByStatus(String status) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('orders')
        .where('status', isEqualTo: status)
        .get();
    return snapshot.docs
        .map((doc) => Order.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<Order?> getOrderById(String id) async {
    final DocumentSnapshot doc =
        await _firestore.collection('orders').doc(id).get();
    if (doc.exists) {
      return Order.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updateOrderStatus(String id, String status) async {
    await _firestore.collection('orders').doc(id).update({'status': status});
  }

  Future<List<Order>> getOrdersByClient(String uid) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('orders')
        .where('clientId', isEqualTo: uid)
        .get();
    return snapshot.docs
        .map((doc) => Order.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
