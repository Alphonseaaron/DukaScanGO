part of 'wallet_bloc.dart';

@immutable
abstract class WalletEvent {
  const WalletEvent();
}

class LoadWalletDetailsEvent extends WalletEvent {
  final String walletId;
  const LoadWalletDetailsEvent(this.walletId);
}
