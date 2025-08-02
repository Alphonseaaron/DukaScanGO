import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DatabaseLoadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Fetch real data
    final data = [
      TimeData(DateTime(2023, 1, 1, 10, 0), 50),
      TimeData(DateTime(2023, 1, 1, 10, 5), 60),
      TimeData(DateTime(2023, 1, 1, 10, 10), 55),
      TimeData(DateTime(2023, 1, 1, 10, 15), 65),
      TimeData(DateTime(2023, 1, 1, 10, 20), 70),
    ];

    final series = [
      charts.Series(
        id: 'Load',
        data: data,
        domainFn: (TimeData timeData, _) => timeData.time,
        measureFn: (TimeData timeData, _) => timeData.value,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Database Load'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Database Load (%)',
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
