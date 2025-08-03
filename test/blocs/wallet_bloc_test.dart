import 'package:bloc_test/bloc_test.dart';
import 'package:dukascango/domain/bloc/wallet/wallet_bloc.dart';
import 'package:dukascango/domain/models/wallet_ledger_entry_model.dart';
import 'package:dukascango/domain/models/wallet_model.dart';
import 'package:dukascango/domain/services/wallet_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockWalletService extends Mock implements WalletService {}

void main() {
  group('WalletBloc', () {
    late WalletBloc walletBloc;
    late MockWalletService mockWalletService;

    setUp(() {
      mockWalletService = MockWalletService();
      walletBloc = WalletBloc(walletService: mockWalletService);
    });

    tearDown(() {
      walletBloc.close();
    });

    final wallet = Wallet(
      id: 'wallet1',
      ownerId: 'user1',
      gateway: 'stripe',
      gatewayReference: 'ref1',
      balance: 100.0,
      currency: 'USD',
      commissionPercent: 0.0,
      holdBalance: 10.0,
    );

    final ledgerEntries = [
      WalletLedgerEntry(
        id: 'entry1',
        type: LedgerEntryType.credit,
        amount: 100.0,
        description: 'Initial deposit',
        gatewayFee: 0.0,
        platformFee: 0.0,
        status: LedgerEntryStatus.completed,
        createdAt: Timestamp.now(),
      )
    ];

    blocTest<WalletBloc, WalletState>(
      'emits [WalletLoading, WalletLoaded] when LoadWalletDetailsEvent is added and service returns data',
      build: () {
        when(mockWalletService.getWallet(any)).thenAnswer((_) async => wallet);
        when(mockWalletService.getLedgerEntries(any)).thenAnswer((_) async => ledgerEntries);
        return walletBloc;
      },
      act: (bloc) => bloc.add(LoadWalletDetailsEvent('wallet1')),
      expect: () => [
        isA<WalletLoading>(),
        isA<WalletLoaded>().having((s) => s.wallet, 'wallet', wallet).having((s) => s.ledgerEntries, 'ledgerEntries', ledgerEntries),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'emits [WalletLoading, WalletFailure] when LoadWalletDetailsEvent is added and service throws an exception',
      build: () {
        when(mockWalletService.getWallet(any)).thenThrow(Exception('Failed to load'));
        return walletBloc;
      },
      act: (bloc) => bloc.add(LoadWalletDetailsEvent('wallet1')),
      expect: () => [
        isA<WalletLoading>(),
        isA<WalletFailure>().having((s) => s.error, 'error', 'Exception: Failed to load'),
      ],
    );

     blocTest<WalletBloc, WalletState>(
      'emits [WalletLoading, WalletFailure] when wallet is not found',
      build: () {
        when(mockWalletService.getWallet(any)).thenAnswer((_) async => null);
        return walletBloc;
      },
      act: (bloc) => bloc.add(LoadWalletDetailsEvent('wallet1')),
      expect: () => [
        isA<WalletLoading>(),
        isA<WalletFailure>().having((s) => s.error, 'error', 'Wallet not found'),
      ],
    );
  });
}
