import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:dukascango/domain/models/order.dart' as order_model;

class OrdersServices {
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;

  Future<void> addOrder(order_model.Order order) async {
    await _firestore.collection('orders').add(order.toMap());
  }

  Future<List<order_model.Order>> getOrdersByStatus(String status) async {
    final firestore.QuerySnapshot snapshot = await _firestore
        .collection('orders')
        .where('status', isEqualTo: status)
        .get();
    return snapshot.docs
        .map((doc) => order_model.Order.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<order_model.Order?> getOrderById(String id) async {
    final firestore.DocumentSnapshot doc =
        await _firestore.collection('orders').doc(id).get();
    if (doc.exists) {
      return order_model.Order.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updateOrderStatus(String id, String status) async {
    await _firestore.collection('orders').doc(id).update({'status': status});
  }

  Future<List<order_model.Order>> getOrdersByClient(String uid) async {
    final firestore.QuerySnapshot snapshot = await _firestore
        .collection('orders')
        .where('clientId', isEqualTo: uid)
        .get();
    return snapshot.docs
        .map((doc) => order_model.Order.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<double> getSalesTotal() async {
    final firestore.QuerySnapshot snapshot = await _firestore
        .collection('orders')
        .where('status', isEqualTo: 'completed')
        .get();
    double total = 0;
    for (var doc in snapshot.docs) {
      total += doc['total'];
    }
    return total;
  }

  Future<List<order_model.Order>> getOrdersByPaymentType(String paymentType) async {
    final firestore.QuerySnapshot snapshot = await _firestore
        .collection('orders')
        .where('paymentType', isEqualTo: paymentType)
        .get();
    return snapshot.docs
        .map((doc) => order_model.Order.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<List<order_model.Order>> getOrdersByDateRange(DateTime start, DateTime end) async {
    final firestore.QuerySnapshot snapshot = await _firestore
        .collection('orders')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get();
    return snapshot.docs
        .map((doc) => order_model.Order.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
