part of 'orders_bloc.dart';

@immutable
abstract class OrdersState {
  final List<Order> orders;
  const OrdersState({this.orders = const []});

  OrdersState copyWith({
    List<Order>? orders,
  }) {
    return OrdersInitial(
      orders: orders ?? this.orders,
    );
  }
}

class OrdersInitial extends OrdersState {
  const OrdersInitial({List<Order> orders = const []}) : super(orders: orders);
}

class LoadingOrderState extends OrdersState {}

class SuccessOrdersState extends OrdersState {}

class FailureOrdersState extends OrdersState {
  final String error;

  FailureOrdersState(this.error);
}
