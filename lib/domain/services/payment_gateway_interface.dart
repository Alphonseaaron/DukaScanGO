import 'package:dukascango/domain/models/payment_gateway_model.dart';

abstract class PaymentGatewayInterface {
  final PaymentGateway gateway;

  PaymentGatewayInterface(this.gateway);

  Future<void> processPayment({
    required double amount,
    required String currency,
    required String customerName,
    required String customerEmail,
    required String txRef,
  });

  Future<void> processWithdrawal({
    required double amount,
    required String currency,
    required String subaccountId, // For Flutterwave
    required String merchantWallet, // For Tingg
  });
}
