part of 'payments_bloc.dart';

import 'package:dukascango/domain/models/payment_gateway_model.dart';

@immutable
abstract class PaymentsEvent {}

// Existing events for compatibility
class OnSelectTypePaymentMethodEvent extends PaymentsEvent {
  final String typePayment;
  final IconData icon;
  final Color color;

  OnSelectTypePaymentMethodEvent(this.typePayment, this.icon, this.color);
}
class OnClearTypePaymentMethodEvent extends PaymentsEvent {}


// New events for the payment flow
class LoadPaymentGatewaysEvent extends PaymentsEvent {
  final String userCountryCode;
  LoadPaymentGatewaysEvent(this.userCountryCode);
}

class SelectPaymentGatewayEvent extends PaymentsEvent {
  final PaymentGateway gateway;
  SelectPaymentGatewayEvent(this.gateway);
}

class ProcessPaymentEvent extends PaymentsEvent {
  final double amount;
  final String currency;
  final String customerName;
  final String customerEmail;
  final String txRef;
  final String walletId;

  ProcessPaymentEvent({
    required this.amount,
    required this.currency,
    required this.customerName,
    required this.customerEmail,
    required this.txRef,
    required this.walletId,
  });
}

class RequestWithdrawalEvent extends PaymentsEvent {
  final double amount;
  final String currency;
  final String subaccountId;
  final String merchantWallet;
  final String walletId;

  RequestWithdrawalEvent({
    required this.amount,
    required this.currency,
    required this.subaccountId,
    required this.merchantWallet,
    required this.walletId,
  });
}