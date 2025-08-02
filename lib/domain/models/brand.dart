class Brand {
  final String? id;
  final String name;
  final String? logoUrl;

  Brand({
    this.id,
    required this.name,
    this.logoUrl,
  });

  factory Brand.fromMap(Map<String, dynamic> map, String id) {
    return Brand(
      id: id,
      name: map['name'],
      logoUrl: map['logoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'logoUrl': logoUrl,
    };
  }

  Brand copyWith({
    String? id,
    String? name,
    String? logoUrl,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }
}
