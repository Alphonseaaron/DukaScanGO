import 'package:dukascango/domain/models/product.dart';

class RecommendationService {
  Future<List<Product>> getSoftRecommendations(String productId) async {
    // TODO: Implement backend logic to get real recommendations
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      Product(
        id: '1',
        name: 'Recommended Product 1',
        description: 'Description of recommended product 1',
        price: 10.0,
        images: [],
        category: 'electronics',
      ),
      Product(
        id: '2',
        name: 'Recommended Product 2',
        description: 'Description of recommended product 2',
        price: 20.0,
        images: [],
        category: 'electronics',
      ),
    ];
  }
}
