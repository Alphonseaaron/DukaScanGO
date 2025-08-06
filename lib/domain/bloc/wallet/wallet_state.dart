part of 'wallet_bloc.dart';

@immutable
abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final Wallet wallet;
  final List<WalletLedgerEntry> ledgerEntries;

  WalletLoaded(this.wallet, this.ledgerEntries);
}

class WalletFailure extends WalletState {
  final String error;

  WalletFailure(this.error);
}
