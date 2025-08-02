import 'package:dukascango/domain/models/revenue.dart';
import 'package:dukascango/domain/services/revenue_service.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RevenueScreen extends StatefulWidget {
  @override
  _RevenueScreenState createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  late Future<List<Revenue>> _revenue;

  @override
  void initState() {
    super.initState();
    _revenue = RevenueService().getRevenue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revenue'),
      ),
      body: FutureBuilder<List<Revenue>>(
        future: _revenue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No revenue data found.'));
          } else {
            final revenueData = snapshot.data!
                .groupBy((r) => r.source)
                .map((key, value) => MapEntry(
                    key, value.fold(0.0, (sum, item) => sum + item.amount)));

            final series = [
              charts.Series(
                id: 'Revenue',
                data: revenueData.entries.toList(),
                domainFn: (MapEntry<String, double> revenue, _) => revenue.key,
                measureFn: (MapEntry<String, double> revenue, _) => revenue.value,
                labelAccessorFn: (MapEntry<String, double> revenue, _) =>
                    '${revenue.key}: \$${revenue.value.toStringAsFixed(2)}',
              ),
            ];

            return Padding(
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
            );
          }
        },
      ),
    );
  }
}

extension on List<Revenue> {
  Map<String, double> groupBy(String Function(Revenue) key) {
    return this.fold({}, (Map<String, double> map, Revenue element) {
      final k = key(element);
      map[k] = (map[k] ?? 0) + element.amount;
      return map;
    });
  }
}
