part of 'payments_bloc.dart';

enum PaymentStatus { initial, loading, processing, success, failure }

@immutable
class PaymentsState {
  final PaymentStatus status;
  final List<PaymentGateway> gateways;
  final PaymentGateway? selectedGateway;
  final String? error;

  // Keeping old state for compatibility for now
  final String typePaymentMethod;
  final IconData iconPayment;
  final Color colorPayment;

  const PaymentsState({
    this.status = PaymentStatus.initial,
    this.gateways = const [],
    this.selectedGateway,
    this.error,
    this.typePaymentMethod = 'CREDIT CARD',
    this.iconPayment = FontAwesomeIcons.creditCard,
    this.colorPayment = const Color(0xff002C8B),
  });

  PaymentsState copyWith({
    PaymentStatus? status,
    List<PaymentGateway>? gateways,
    PaymentGateway? selectedGateway,
    String? error,
    String? typePaymentMethod,
    IconData? iconPayment,
    Color? colorPayment,
  }) {
    return PaymentsState(
      status: status ?? this.status,
      gateways: gateways ?? this.gateways,
      selectedGateway: selectedGateway ?? this.selectedGateway,
      error: error ?? this.error,
      typePaymentMethod: typePaymentMethod ?? this.typePaymentMethod,
      iconPayment: iconPayment ?? this.iconPayment,
      colorPayment: colorPayment ?? this.colorPayment,
    );
  }
}
