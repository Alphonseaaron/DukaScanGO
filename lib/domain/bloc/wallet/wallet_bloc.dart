import 'package:bloc/bloc.dart';
import 'package:dukascango/domain/models/wallet_ledger_entry_model.dart';
import 'package:dukascango/domain/models/wallet_model.dart';
import 'package:dukascango/domain/services/wallet_service.dart';
import 'package:meta/meta.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletService _walletService;

  WalletBloc({required WalletService walletService})
      : _walletService = walletService,
        super(WalletInitial()) {
    on<LoadWalletDetailsEvent>(_onLoadWalletDetails);
  }

  Future<void> _onLoadWalletDetails(LoadWalletDetailsEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    try {
      final wallet = await _walletService.getWallet(event.walletId);
      if (wallet == null) {
        emit(WalletFailure('Wallet not found'));
        return;
      }
      final ledgerEntries = await _walletService.getLedgerEntries(event.walletId);
      emit(WalletLoaded(wallet, ledgerEntries));
    } catch (e) {
      emit(WalletFailure(e.toString()));
    }
  }
}
