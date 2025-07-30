class User {
  final String uid;
  final String name;
  final String lastname;
  final String email;
  final String? phone;
  final String? image;
  final String rolId;
  final String? notificationToken;

  User({
    required this.uid,
    required this.name,
    required this.lastname,
    required this.email,
    this.phone,
    this.image,
    required this.rolId,
    this.notificationToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'image': image,
      'rolId': rolId,
      'notificationToken': notificationToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      name: map['name'],
      lastname: map['lastname'],
      email: map['email'],
      phone: map['phone'],
      image: map['image'],
      rolId: map['rolId'],
      notificationToken: map['notificationToken'],
    );
  }
}
