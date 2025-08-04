part of 'wallet_bloc.dart';

@immutable
abstract class WalletEvent {}

class LoadWalletDetailsEvent extends WalletEvent {
  final String walletId;
  LoadWalletDetailsEvent(this.walletId);
}
