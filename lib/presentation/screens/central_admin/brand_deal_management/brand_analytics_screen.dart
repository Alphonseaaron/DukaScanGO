import 'package:dukascango/domain/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BrandAnalyticsScreen extends StatefulWidget {
  final String brandId;

  const BrandAnalyticsScreen({Key? key, required this.brandId}) : super(key: key);

  @override
  _BrandAnalyticsScreenState createState() => _BrandAnalyticsScreenState();
}

class _BrandAnalyticsScreenState extends State<BrandAnalyticsScreen> {
  late Future<List<SalesData>> _salesVelocity;

  @override
  void initState() {
    super.initState();
    _salesVelocity = AnalyticsService().getSalesVelocityForBrand(widget.brandId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brand Analytics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Sales Velocity',
              style: Theme.of(context).textTheme.headline6,
            ),
            Expanded(
              child: FutureBuilder<List<SalesData>>(
                future: _salesVelocity,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No sales data found.'));
                  } else {
                    final series = [
                      charts.Series(
                        id: 'Sales',
                        data: snapshot.data!,
                        domainFn: (SalesData sales, _) => sales.month,
                        measureFn: (SalesData sales, _) => sales.sales,
                        colorFn: (_, __) =>
                            charts.MaterialPalette.blue.shadeDefault,
                      ),
                    ];
                    return charts.BarChart(
                      series,
                      animate: true,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  final String month;
  final int sales;

  SalesData(this.month, this.sales);
}
