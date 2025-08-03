import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dukascango/domain/models/payment_gateway_model.dart';
import 'package:dukascango/domain/services/flutterwave_gateway.dart';
import 'package:dukascango/domain/services/payment_gateway_interface.dart';
import 'package:dukascango/domain/services/tingg_gateway.dart';

class PaymentGatewayManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<PaymentGateway> _gateways = [];

  List<PaymentGateway> get gateways => _gateways;

  Future<void> loadGateways() async {
    try {
      final snapshot = await _firestore.collection('gateways').get();
      _gateways = snapshot.docs.map((doc) => PaymentGateway.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error loading gateways: $e');
      // Handle error, maybe load from a local cache or default config
    }
  }

  PaymentGatewayInterface? getGatewayForCountry(String countryCode) {
    final gatewayModel = _gateways.firstWhere(
      (g) => g.allowedCountries.contains(countryCode.toUpperCase()),
      orElse: () => _gateways.first, // Fallback to the first gateway as default
    );

    return _getGatewayImplementation(gatewayModel);
  }

  PaymentGatewayInterface? _getGatewayImplementation(PaymentGateway gateway) {
    switch (gateway.name.toLowerCase()) {
      case 'flutterwave':
        return FlutterwaveGateway(gateway);
      case 'tingg':
        return TinggGateway(gateway);
      default:
        return null; // Or a default/dummy gateway
    }
  }
}
