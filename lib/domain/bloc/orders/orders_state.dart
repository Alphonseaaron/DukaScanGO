part of 'orders_bloc.dart';

@immutable
class OrdersState {
  final List<Order> orders;
  final List<ProductCart> products;

  const OrdersState({
    this.orders = const [],
    this.products = const [],
  });

  OrdersState copyWith({
    List<Order>? orders,
    List<ProductCart>? products,
  }) =>
      OrdersState(
        orders: orders ?? this.orders,
        products: products ?? this.products,
      );
}

class LoadingOrderState extends OrdersState {}

class SuccessOrdersState extends OrdersState {}

class FailureOrdersState extends OrdersState {
  final String error;

  FailureOrdersState(this.error);
}


