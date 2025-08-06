class Product {
  final String? id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String category;
  final String? status;
  final String? barcode;
  final double? costPrice;
  final int? stockQuantity;
  final String? supplier;
  final double? taxRate;
  final int? lowStockThreshold;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    this.status,
    this.barcode,
    this.costPrice,
    this.stockQuantity,
    this.supplier,
    this.taxRate,
    this.lowStockThreshold,
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
    double? costPrice,
    int? stockQuantity,
    String? supplier,
    double? taxRate,
    int? lowStockThreshold,
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
      costPrice: costPrice ?? this.costPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      supplier: supplier ?? this.supplier,
      taxRate: taxRate ?? this.taxRate,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
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
      'costPrice': costPrice,
      'stockQuantity': stockQuantity,
      'supplier': supplier,
      'taxRate': taxRate,
      'lowStockThreshold': lowStockThreshold,
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
      costPrice: map['costPrice'],
      stockQuantity: map['stockQuantity'],
      supplier: map['supplier'],
      taxRate: map['taxRate'],
      lowStockThreshold: map['lowStockThreshold'],
    );
  }
}
