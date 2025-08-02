import 'package:dukascango/presentation/screens/central_admin/brand_deal_management/brand_analytics_screen.dart';

class AnalyticsService {
  Future<List<SalesData>> getSalesVelocityForBrand(String brandId) async {
    // TODO: Implement backend logic to calculate real sales velocity
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      SalesData('Jan', 100),
      SalesData('Feb', 120),
      SalesData('Mar', 150),
      SalesData('Apr', 130),
      SalesData('May', 160),
    ];
  }
}
