import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dukascango/domain/models/payment_gateway_model.dart';
import 'package:dukascango/domain/models/wallet_ledger_entry_model.dart';
import 'package:dukascango/domain/services/payment_gateway_manager.dart';
import 'package:dukascango/domain/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'payments_event.dart';
part 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  final PaymentGatewayManager _paymentGatewayManager;
  final WalletService _walletService;

  PaymentsBloc({
    required PaymentGatewayManager paymentGatewayManager,
    required WalletService walletService,
  })  : _paymentGatewayManager = paymentGatewayManager,
        _walletService = walletService,
        super(const PaymentsState()) {
    on<OnSelectTypePaymentMethodEvent>(_onSelectTypePayment);
    on<OnClearTypePaymentMethodEvent>(_onClearTypePaymentMethod);
    on<LoadPaymentGatewaysEvent>(_onLoadPaymentGateways);
    on<SelectPaymentGatewayEvent>(_onSelectPaymentGateway);
    on<ProcessPaymentEvent>(_onProcessPayment);
    on<RequestWithdrawalEvent>(_onRequestWithdrawal);
  }

  Future<void> _onSelectTypePayment(OnSelectTypePaymentMethodEvent event, Emitter<PaymentsState> emit) async {
    emit(state.copyWith(
      typePaymentMethod: event.typePayment,
      iconPayment: event.icon,
      colorPayment: event.color,
    ));
  }

  Future<void> _onClearTypePaymentMethod(OnClearTypePaymentMethodEvent event, Emitter<PaymentsState> emit) async {
    emit(state.copyWith(typePaymentMethod: 'CREDIT CARD'));
  }

  Future<void> _onLoadPaymentGateways(LoadPaymentGatewaysEvent event, Emitter<PaymentsState> emit) async {
    emit(state.copyWith(status: PaymentStatus.loading));
    try {
      await _paymentGatewayManager.loadGateways();
      final gatewayInterface = _paymentGatewayManager.getGatewayForCountry(event.userCountryCode);
      emit(state.copyWith(
        status: PaymentStatus.success,
        gateways: _paymentGatewayManager.gateways,
        selectedGateway: gatewayInterface?.gateway,
      ));
    } catch (e) {
      emit(state.copyWith(status: PaymentStatus.failure, error: e.toString()));
    }
  }

  void _onSelectPaymentGateway(SelectPaymentGatewayEvent event, Emitter<PaymentsState> emit) {
    emit(state.copyWith(selectedGateway: event.gateway));
  }

  Future<void> _onProcessPayment(ProcessPaymentEvent event, Emitter<PaymentsState> emit) async {
    if (state.selectedGateway == null) {
      emit(state.copyWith(status: PaymentStatus.failure, error: 'No payment gateway selected'));
      return;
    }

    emit(state.copyWith(status: PaymentStatus.processing));
    try {
      final gateway = _paymentGatewayManager.getGatewayImplementation(state.selectedGateway!);
      if (gateway == null) {
        throw Exception('Gateway implementation not found');
      }

      await gateway.processPayment(
        amount: event.amount,
        currency: event.currency,
        customerName: event.customerName,
        customerEmail: event.customerEmail,
        txRef: event.txRef,
      );

      final ledgerEntry = WalletLedgerEntry(
        id: '', // Firestore will generate this
        type: LedgerEntryType.credit,
        amount: event.amount,
        description: 'Payment from ${event.customerName}',
        gatewayFee: 0, // Calculate this based on gateway response
        platformFee: 0, // Calculate this based on your business logic
        status: LedgerEntryStatus.completed,
        createdAt: Timestamp.now(),
      );
      await _walletService.addLedgerEntry(event.walletId, ledgerEntry);

      emit(state.copyWith(status: PaymentStatus.success));
    } catch (e) {
      emit(state.copyWith(status: PaymentStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onRequestWithdrawal(RequestWithdrawalEvent event, Emitter<PaymentsState> emit) async {
     if (state.selectedGateway == null) {
      emit(state.copyWith(status: PaymentStatus.failure, error: 'No payment gateway selected'));
      return;
    }

    emit(state.copyWith(status: PaymentStatus.processing));
    try {
      final gateway = _paymentGatewayManager.getGatewayImplementation(state.selectedGateway!);
       if (gateway == null) {
        throw Exception('Gateway implementation not found');
      }

      await gateway.processWithdrawal(
        amount: event.amount,
        currency: event.currency,
        subaccountId: event.subaccountId,
        merchantWallet: event.merchantWallet,
      );

       final ledgerEntry = WalletLedgerEntry(
        id: '', // Firestore will generate this
        type: LedgerEntryType.debit,
        amount: event.amount,
        description: 'Withdrawal',
        gatewayFee: 0, // Calculate this
        platformFee: 0, // Calculate this
        status: LedgerEntryStatus.completed,
        createdAt: Timestamp.now(),
      );
      await _walletService.addLedgerEntry(event.walletId, ledgerEntry);

      emit(state.copyWith(status: PaymentStatus.success));
    } catch (e) {
      emit(state.copyWith(status: PaymentStatus.failure, error: e.toString()));
    }
  }
}
