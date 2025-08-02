class Campaign {
  final String? id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final String? brandId;
  final String? featuredStoreId;

  Campaign({
    this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.budget,
    this.brandId,
    this.featuredStoreId,
  });

  factory Campaign.fromMap(Map<String, dynamic> map, String id) {
    return Campaign(
      id: id,
      name: map['name'],
      description: map['description'],
      startDate: map['startDate'].toDate(),
      endDate: map['endDate'].toDate(),
      budget: map['budget'],
      brandId: map['brandId'],
      featuredStoreId: map['featuredStoreId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'budget': budget,
      'brandId': brandId,
      'featuredStoreId': featuredStoreId,
    };
  }

  Campaign copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    double? budget,
    String? brandId,
    String? featuredStoreId,
  }) {
    return Campaign(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      budget: budget ?? this.budget,
      brandId: brandId ?? this.brandId,
      featuredStoreId: featuredStoreId ?? this.featuredStoreId,
    );
  }
}
