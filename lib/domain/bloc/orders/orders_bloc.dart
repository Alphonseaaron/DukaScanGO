import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dukascango/domain/models/order.dart';
import 'package:dukascango/domain/services/orders_services.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersServices _ordersServices = OrdersServices();

  OrdersBloc() : super(const OrdersInitial()) {
    on<OnGetOrdersByStatusEvent>(_onGetOrdersByStatus);
    on<OnUpdateStatusOrderEvent>(_onUpdateStatusOrder);
    on<OnAddNewOrderEvent>(_onAddNewOrder);
    on<OnGetOrdersByClientEvent>(_onGetOrdersByClient);
    on<OnGetOrdersByPaymentTypeEvent>(_onGetOrdersByPaymentType);
  }

  Future<void> _onGetOrdersByStatus(
      OnGetOrdersByStatusEvent event, Emitter<OrdersState> emit) async {
    try {
      emit(LoadingOrderState());
      final orders = await _ordersServices.getOrdersByStatus(event.status);
      emit(state.copyWith(orders: orders));
    } catch (e) {
      emit(FailureOrdersState(e.toString()));
    }
  }

  Future<void> _onUpdateStatusOrder(
      OnUpdateStatusOrderEvent event, Emitter<OrdersState> emit) async {
    try {
      emit(LoadingOrderState());
      await _ordersServices.updateOrderStatus(event.id, event.status);
      emit(SuccessOrdersState());
    } catch (e) {
      emit(FailureOrdersState(e.toString()));
    }
  }

  Future<void> _onAddNewOrder(
      OnAddNewOrderEvent event, Emitter<OrdersState> emit) async {
    try {
      emit(LoadingOrderState());
      await _ordersServices.addOrder(event.order);
      emit(SuccessOrdersState());
    } catch (e) {
      emit(FailureOrdersState(e.toString()));
    }
  }

  Future<void> _onGetOrdersByClient(
      OnGetOrdersByClientEvent event, Emitter<OrdersState> emit) async {
    try {
      emit(LoadingOrderState());
      final orders = await _ordersServices.getOrdersByClient(event.uid);
      emit(state.copyWith(orders: orders));
    } catch (e) {
      emit(FailureOrdersState(e.toString()));
    }
  }

  Future<void> _onGetOrdersByPaymentType(
      OnGetOrdersByPaymentTypeEvent event, Emitter<OrdersState> emit) async {
    try {
      emit(LoadingOrderState());
      final orders = await _ordersServices.getOrdersByPaymentType(event.paymentType);
      emit(state.copyWith(orders: orders));
    } catch (e) {
      emit(FailureOrdersState(e.toString()));
    }
  }
}
