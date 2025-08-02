class Role {
  final String? id;
  final String name;
  final List<String> permissions;

  Role({
    this.id,
    required this.name,
    required this.permissions,
  });

  factory Role.fromMap(Map<String, dynamic> map, String id) {
    return Role(
      id: id,
      name: map['name'],
      permissions: List<String>.from(map['permissions']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'permissions': permissions,
    };
  }
}
