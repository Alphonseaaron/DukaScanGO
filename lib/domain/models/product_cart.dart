
class ProductCart {

  String uidProduct;
  String imageProduct;
  String nameProduct;
  double price;
  int quantity;

  ProductCart({
    required this.uidProduct,
    required this.imageProduct,
    required this.nameProduct,
    required this.price,
    required this.quantity
  });

  ProductCart copyWith({
    String? uidProduct,
    String? imageProduct,
    String? nameProduct,
    double? price,
    int? quantity,
  }) {
    return ProductCart(
      uidProduct: uidProduct ?? this.uidProduct,
      imageProduct: imageProduct ?? this.imageProduct,
      nameProduct: nameProduct ?? this.nameProduct,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uidProduct" : this.uidProduct,
      "price" : this.price,
      "quantity" : this.quantity
    };
  }

}