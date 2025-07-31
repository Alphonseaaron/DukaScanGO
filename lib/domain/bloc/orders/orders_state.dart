part of 'orders_bloc.dart';

enum DeliveryMethod { Delivery, ClickAndCollect }

@immutable
class OrdersState {
  final List<Order> orders;
  final List<ProductCart> products;
  final DeliveryMethod deliveryMethod;

  const OrdersState({
    this.orders = const [],
    this.products = const [],
    this.deliveryMethod = DeliveryMethod.Delivery,
  });

  OrdersState copyWith({
    List<Order>? orders,
    List<ProductCart>? products,
    DeliveryMethod? deliveryMethod,
  }) =>
      OrdersState(
        orders: orders ?? this.orders,
        products: products ?? this.products,
        deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      );
}

class LoadingOrderState extends OrdersState {}

class SuccessOrdersState extends OrdersState {}

class FailureOrdersState extends OrdersState {
  final String error;

  FailureOrdersState(this.error);
}


