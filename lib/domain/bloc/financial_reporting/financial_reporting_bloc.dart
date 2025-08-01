import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dukascango/domain/services/orders_services.dart';
import 'package:meta/meta.dart';
import 'package:dukascango/domain/models/order.dart';

part 'financial_reporting_event.dart';
part 'financial_reporting_state.dart';

class FinancialReportingBloc
    extends Bloc<FinancialReportingEvent, FinancialReportingState> {
  final OrdersServices _ordersServices = OrdersServices();

  FinancialReportingBloc() : super(FinancialReportingInitial()) {
    on<OnGenerateReportEvent>(_onGenerateReport);
  }

  Future<void> _onGenerateReport(
      OnGenerateReportEvent event, Emitter<FinancialReportingState> emit) async {
    emit(FinancialReportingLoading());
    try {
      final now = DateTime.now();
      DateTime start;
      DateTime end;

      switch (event.period) {
        case 'Daily':
          start = DateTime(now.year, now.month, now.day);
          end = start.add(const Duration(days: 1));
          break;
        case 'Weekly':
          start = now.subtract(Duration(days: now.weekday - 1));
          start = DateTime(start.year, start.month, start.day);
          end = start.add(const Duration(days: 7));
          break;
        case 'Monthly':
          start = DateTime(now.year, now.month, 1);
          end = DateTime(now.year, now.month + 1, 1);
          break;
        default:
          start = DateTime(now.year, now.month, now.day);
          end = start.add(const Duration(days: 1));
      }

      final orders = await _ordersServices.getOrdersByDateRange(start, end);

      if (event.reportType == 'Sales & Revenue') {
        double grossSales = 0;
        double netSales = 0;
        double taxes = 0;
        double discounts = 0; // Assuming no discounts for now

        for (final order in orders) {
          if (order.status == 'completed') {
            grossSales += order.total;
          }
        }

        // Assuming tax is included in the price and tax rate is on the product
        // This is a simplification. A real implementation would need more details.
        // For now, I'll assume net sales = gross sales and taxes are not calculated.
        netSales = grossSales;
        taxes = 0;

        emit(FinancialReportingSuccess({
          'Gross Sales': grossSales,
          'Net Sales': netSales,
          'Taxes': taxes,
          'Discounts': discounts,
        }));
      }
    } catch (e) {
      emit(FinancialReportingFailure(e.toString()));
    }
  }
}
