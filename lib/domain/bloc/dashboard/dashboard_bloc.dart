import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dukascango/domain/models/product.dart';
import 'package:dukascango/domain/services/orders_services.dart';
import 'package:dukascango/domain/services/products_services.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final OrdersServices _ordersServices = OrdersServices();
  final ProductsServices _productsServices = ProductsServices();

  DashboardBloc() : super(DashboardInitial()) {
    on<FetchDashboardData>(_onFetchDashboardData);
  }

  Future<void> _onFetchDashboardData(
      FetchDashboardData event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final totalSales = await _ordersServices.getSalesTotal();
      final pendingOrders = await _ordersServices.getOrdersByStatus('pending');
      final completedOrders = await _ordersServices.getOrdersByStatus('completed');
      final lowStockItems = await _productsServices.getLowStockItems();

      emit(DashboardSuccess(
        totalSales: totalSales,
        pendingOrders: pendingOrders.length,
        completedOrders: completedOrders.length,
        lowStockItems: lowStockItems,
      ));
    } catch (e) {
      emit(DashboardFailure(e.toString()));
    }
  }
}
