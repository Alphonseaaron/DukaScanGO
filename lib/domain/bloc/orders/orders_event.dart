part of 'orders_bloc.dart';

@immutable
abstract class OrdersEvent {}

class OnAddNewOrderEvent extends OrdersEvent {
  final Order order;

  OnAddNewOrderEvent(this.order);
}

class OnUpdateStatusOrderEvent extends OrdersEvent {
  final String id;
  final String status;

  OnUpdateStatusOrderEvent(this.id, this.status);
}

class OnGetOrdersByStatusEvent extends OrdersEvent {
  final String status;

  OnGetOrdersByStatusEvent(this.status);
}

class OnGetOrdersByClientEvent extends OrdersEvent {
  final String uid;

  OnGetOrdersByClientEvent(this.uid);
}

class OnSelectDeliveryMethodEvent extends OrdersEvent {
  final DeliveryMethod deliveryMethod;

  OnSelectDeliveryMethodEvent(this.deliveryMethod);
}
