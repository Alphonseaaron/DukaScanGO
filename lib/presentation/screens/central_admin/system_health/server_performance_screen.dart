import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ServerPerformanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Fetch real data
    final data = [
      TimeData(DateTime(2023, 1, 1, 10, 0), 80),
      TimeData(DateTime(2023, 1, 1, 10, 5), 85),
      TimeData(DateTime(2023, 1, 1, 10, 10), 82),
      TimeData(DateTime(2023, 1, 1, 10, 15), 78),
      TimeData(DateTime(2023, 1, 1, 10, 20), 90),
    ];

    final series = [
      charts.Series(
        id: 'Performance',
        data: data,
        domainFn: (TimeData timeData, _) => timeData.time,
        measureFn: (TimeData timeData, _) => timeData.value,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Server Performance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'CPU Usage (%)',
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
