import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ApiResponseTimesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Fetch real data
    final data = [
      TimeData(DateTime(2023, 1, 1, 10, 0), 200),
      TimeData(DateTime(2023, 1, 1, 10, 5), 250),
      TimeData(DateTime(2023, 1, 1, 10, 10), 220),
      TimeData(DateTime(2023, 1, 1, 10, 15), 280),
      TimeData(DateTime(2023, 1, 1, 10, 20), 300),
    ];

    final series = [
      charts.Series(
        id: 'Response Times',
        data: data,
        domainFn: (TimeData timeData, _) => timeData.time,
        measureFn: (TimeData timeData, _) => timeData.value,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('API Response Times'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'API Response Times (ms)',
              style: Theme.of(context).textTheme.headline6,
            ),
            Expanded(
              child: charts.TimeSeriesChart(
                series,
                animate: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeData {
  final DateTime time;
  final int value;

  TimeData(this.time, this.value);
}
