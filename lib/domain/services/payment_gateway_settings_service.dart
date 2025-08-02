import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/payment_gateway_settings.dart';

class PaymentGatewaySettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPaymentGatewaySettings(
      PaymentGatewaySettings settings) async {
    await _firestore
        .collection('payment_gateway_settings')
        .add(settings.toMap());
  }

  Future<List<PaymentGatewaySettings>> getPaymentGatewaySettings() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('payment_gateway_settings').get();
    return snapshot.docs
        .map((doc) => PaymentGatewaySettings.fromMap(
            doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updatePaymentGatewaySettings(
      PaymentGatewaySettings settings) async {
    await _firestore
        .collection('payment_gateway_settings')
        .doc(settings.id)
        .update(settings.toMap());
  }
}
