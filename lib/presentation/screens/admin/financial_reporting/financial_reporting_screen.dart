import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dukascango/domain/bloc/financial_reporting/financial_reporting_bloc.dart';
import 'package:dukascango/presentation/components/components.dart';

class FinancialReportingScreen extends StatefulWidget {
  @override
  _FinancialReportingScreenState createState() =>
      _FinancialReportingScreenState();
}

class _FinancialReportingScreenState extends State<FinancialReportingScreen> {
  String _selectedPeriod = 'Daily';
  String _selectedReport = 'Sales & Revenue';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: 'Financial Reporting'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: _selectedPeriod,
                  items: ['Daily', 'Weekly', 'Monthly']
                      .map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPeriod = value;
                      });
                    }
                  },
                ),
                DropdownButton<String>(
                  value: _selectedReport,
                  items: [
                    'Sales & Revenue',
                    // Other reports can be added here
                  ]
                      .map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedReport = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<FinancialReportingBloc>(context)
                    .add(OnGenerateReportEvent(_selectedReport, _selectedPeriod));
              },
              child: const Text('Generate Report'),
            ),
            const SizedBox(height: 20),
            const TextCustom(
                text: 'Report',
                fontSize: 20,
                fontWeight: FontWeight.bold),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<FinancialReportingBloc, FinancialReportingState>(
                builder: (context, state) {
                  if (state is FinancialReportingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is FinancialReportingFailure) {
                    return Text(state.error,
                        style: const TextStyle(color: Colors.red));
                  }
                  if (state is FinancialReportingSuccess) {
                    return _buildReport(state.reportData);
                  }
                  return const Text('No report generated yet.');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReport(Map<String, dynamic> data) {
    return ListView(
      children: data.entries
          .map((entry) => ListTile(
                title: Text(entry.key),
                trailing: Text(entry.value.toString()),
              ))
          .toList(),
    );
  }
}
