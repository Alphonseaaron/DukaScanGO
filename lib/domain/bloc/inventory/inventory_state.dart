part of 'inventory_bloc.dart';

@immutable
abstract class InventoryState {
  final List<RestockingRequest> restockingRequests;

  const InventoryState({this.restockingRequests = const []});

  InventoryState copyWith({List<RestockingRequest>? restockingRequests}) {
    return InventoryInitial(
      restockingRequests: restockingRequests ?? this.restockingRequests,
    );
  }
}

class InventoryInitial extends InventoryState {
  const InventoryInitial({List<RestockingRequest> restockingRequests = const []})
      : super(restockingRequests: restockingRequests);
}

class InventoryLoading extends InventoryState {}

class InventorySuccess extends InventoryState {
  final int successCount;
  final int failureCount;
  final List<String> errors;

  InventorySuccess({
    required this.successCount,
    required this.failureCount,
    required this.errors,
  });
}

class InventoryFailure extends InventoryState {
  final String error;

  InventoryFailure(this.error);
}
