part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final double totalSales;
  final int pendingOrders;
  final int completedOrders;
  final List<Product> lowStockItems;

  DashboardSuccess({
    required this.totalSales,
    required this.pendingOrders,
    required this.completedOrders,
    required this.lowStockItems,
  });
}

class DashboardFailure extends DashboardState {
  final String error;

  DashboardFailure(this.error);
}
