import 'package:dukascango/domain/models/product.dart';

class SuggestionService {
  Future<List<Product>> getProductSuggestions(List<String> productIds) async {
    // TODO: Implement backend logic to get real suggestions
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      Product(
        id: '3',
        name: 'Suggested Product 1',
        description: 'Description of suggested product 1',
        price: 30.0,
        images: [],
        category: 'electronics',
      ),
      Product(
        id: '4',
        name: 'Suggested Product 2',
        description: 'Description of suggested product 2',
        price: 40.0,
        images: [],
        category: 'electronics',
      ),
    ];
  }
}
