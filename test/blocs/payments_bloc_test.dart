import 'package:bloc_test/bloc_test.dart';
import 'package:dukascango/domain/bloc/payments/payments_bloc.dart';
import 'package:dukascango/domain/models/payment_gateway_model.dart';
import 'package:dukascango/domain/services/payment_gateway_manager.dart';
import 'package:dukascango/domain/services/wallet_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'payments_bloc_test.mocks.dart';

@GenerateMocks([PaymentGatewayManager, WalletService])
void main() {
  group('PaymentsBloc', () {
    late PaymentsBloc paymentsBloc;
    late MockPaymentGatewayManager mockPaymentGatewayManager;
    late MockWalletService mockWalletService;

    setUp(() {
      mockPaymentGatewayManager = MockPaymentGatewayManager();
      mockWalletService = MockWalletService();
      paymentsBloc = PaymentsBloc(
        paymentGatewayManager: mockPaymentGatewayManager,
        walletService: mockWalletService,
      );
    });

    tearDown(() {
      paymentsBloc.close();
    });

    final gateway = PaymentGateway(
      id: 'gw1',
      name: 'flutterwave',
      apiConfig: {},
      allowedCountries: ['NG'],
    );

    blocTest<PaymentsBloc, PaymentsState>(
      'emits [loading, success] when LoadPaymentGatewaysEvent is added',
      build: () {
        when(mockPaymentGatewayManager.loadGateways()).thenAnswer((_) async => {});
        when(mockPaymentGatewayManager.getGatewayForCountry(any)).thenReturn(gateway as dynamic);
        return paymentsBloc;
      },
      act: (bloc) => bloc.add(const LoadPaymentGatewaysEvent('NG')),
      expect: () => [
        isA<PaymentsState>().having((s) => s.status, 'status', PaymentStatus.loading),
        isA<PaymentsState>()
            .having((s) => s.status, 'status', PaymentStatus.success)
            .having((s) => s.gateways, 'gateways', [gateway])
            .having((s) => s.selectedGateway, 'selectedGateway', gateway as dynamic),
      ],
    );
  });
}
