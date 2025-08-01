part of 'financial_reporting_bloc.dart';

@immutable
abstract class FinancialReportingState {}

class FinancialReportingInitial extends FinancialReportingState {}

class FinancialReportingLoading extends FinancialReportingState {}

class FinancialReportingSuccess extends FinancialReportingState {
  final Map<String, dynamic> reportData;

  FinancialReportingSuccess(this.reportData);
}

class FinancialReportingFailure extends FinancialReportingState {
  final String error;

  FinancialReportingFailure(this.error);
}
