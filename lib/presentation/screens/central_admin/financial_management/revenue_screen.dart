import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RevenueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Fetch real data
    final data = [
      RevenueData('Commissions', 1000),
      RevenueData('Fees', 500),
      RevenueData('Ad Revenue', 200),
    ];

    final series = [
      charts.Series(
        id: 'Revenue',
        data: data,
        domainFn: (RevenueData revenue, _) => revenue.source,
        measureFn: (RevenueData revenue, _) => revenue.amount,
        labelAccessorFn: (RevenueData revenue, _) =>
            '${revenue.source}: \$${revenue.amount}',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Revenue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Platform Revenue',
              style: Theme.of(context).textTheme.headline6,
            ),
            Expanded(
              child: charts.PieChart(
                series,
                animate: true,
                defaultRenderer: charts.ArcRendererConfig(
                  arcRendererDecorators: [
                    charts.ArcLabelDecorator(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RevenueData {
  final String source;
  final int amount;

  RevenueData(this.source, this.amount);
}
