class Product {
  final String? id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String category;
  final String? status;
  final String? barcode;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    this.status,
    this.barcode,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    List<String>? images,
    String? category,
    String? status,
    String? barcode,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
      category: category ?? this.category,
      status: status ?? this.status,
      barcode: barcode ?? this.barcode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'category': category,
      'status': status,
      'barcode': barcode,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'],
      description: map['description'],
      price: map['price'],
      images: List<String>.from(map['images']),
      category: map['category'],
      status: map['status'],
      barcode: map['barcode'],
    );
  }
}
