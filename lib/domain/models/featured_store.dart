class FeaturedStore {
  final String? id;
  final String storeId;
  final String tier;

  FeaturedStore({
    this.id,
    required this.storeId,
    required this.tier,
  });

  factory FeaturedStore.fromMap(Map<String, dynamic> map, String id) {
    return FeaturedStore(
      id: id,
      storeId: map['storeId'],
      tier: map['tier'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'tier': tier,
    };
  }

  FeaturedStore copyWith({
    String? id,
    String? storeId,
    String? tier,
  }) {
    return FeaturedStore(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      tier: tier ?? this.tier,
    );
  }
}
