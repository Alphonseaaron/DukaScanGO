part of 'orders_bloc.dart';

@immutable
abstract class OrdersEvent {}

class OnGetOrdersByStatusEvent extends OrdersEvent {
  final String status;

  OnGetOrdersByStatusEvent(this.status);
}

class OnUpdateStatusOrderEvent extends OrdersEvent {
  final String id;
  final String status;

  OnUpdateStatusOrderEvent(this.id, this.status);
}

class OnAddNewOrderEvent extends OrdersEvent {
  final Order order;

  OnAddNewOrderEvent(this.order);
}

class OnGetOrdersByClientEvent extends OrdersEvent {
  final String uid;

  OnGetOrdersByClientEvent(this.uid);
}

class OnGetOrdersByPaymentTypeEvent extends OrdersEvent {
  final String paymentType;

  OnGetOrdersByPaymentTypeEvent(this.paymentType);
}
