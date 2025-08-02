class ProductPlacement {
  final String? id;
  final String name;
  final String description;
  final List<String> productIds;
  final String placementType; // e.g., 'soft_recommendation', 'aggressive_placement'
  final List<Map<String, dynamic>> rules;

  ProductPlacement({
    this.id,
    required this.name,
    required this.description,
    required this.productIds,
    required this.placementType,
    required this.rules,
  });

  factory ProductPlacement.fromMap(Map<String, dynamic> map, String id) {
    return ProductPlacement(
      id: id,
      name: map['name'],
      description: map['description'],
      productIds: List<String>.from(map['productIds']),
      placementType: map['placementType'],
      rules: List<Map<String, dynamic>>.from(map['rules']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'productIds': productIds,
      'placementType': placementType,
      'rules': rules,
    };
  }

  ProductPlacement copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? productIds,
    String? placementType,
    List<Map<String, dynamic>>? rules,
  }) {
    return ProductPlacement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      productIds: productIds ?? this.productIds,
      placementType: placementType ?? this.placementType,
      rules: rules ?? this.rules,
    );
  }
}
