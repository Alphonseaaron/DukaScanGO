part of 'inventory_bloc.dart';

@immutable
abstract class InventoryEvent {}

class OnBulkUploadFileEvent extends InventoryEvent {
  final String csvString;

  OnBulkUploadFileEvent(this.csvString);
}

class OnGetRestockingRequestsEvent extends InventoryEvent {}

class OnCreateRestockingRequestEvent extends InventoryEvent {
  final RestockingRequest request;

  OnCreateRestockingRequestEvent(this.request);
}
