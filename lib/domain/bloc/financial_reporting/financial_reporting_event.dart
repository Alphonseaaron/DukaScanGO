part of 'financial_reporting_bloc.dart';

@immutable
abstract class FinancialReportingEvent {}

class OnGenerateReportEvent extends FinancialReportingEvent {
  final String reportType;
  final String period;

  OnGenerateReportEvent(this.reportType, this.period);
}
