class User {
  final String uid;
  final String name;
  final String lastname;
  final String email;
  final String? phone;
  final String? image;
  final String rolId;
  final String? notificationToken;
  final String? country;
  final String? countryCode;
  final String? dialingCode;
  final String? flag;
  final Map<String, dynamic>? currency;
  final Map<String, dynamic>? geo;

  User({
    required this.uid,
    required this.name,
    required this.lastname,
    required this.email,
    this.phone,
    this.image,
    required this.rolId,
    this.notificationToken,
    this.country,
    this.countryCode,
    this.dialingCode,
    this.flag,
    this.currency,
    this.geo,
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
      'country': country,
      'countryCode': countryCode,
      'dialingCode': dialingCode,
      'flag': flag,
      'currency': currency,
      'geo': geo,
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
      country: map['country'],
      countryCode: map['countryCode'],
      dialingCode: map['dialingCode'],
      flag: map['flag'],
      currency: map['currency'],
      geo: map['geo'],
    );
  }

  User copyWith({
    String? uid,
    String? name,
    String? lastname,
    String? email,
    String? phone,
    String? image,
    String? rolId,
    String? notificationToken,
    String? country,
    String? countryCode,
    String? dialingCode,
    String? flag,
    Map<String, dynamic>? currency,
    Map<String, dynamic>? geo,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      rolId: rolId ?? this.rolId,
      notificationToken: notificationToken ?? this.notificationToken,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      dialingCode: dialingCode ?? this.dialingCode,
      flag: flag ?? this.flag,
      currency: currency ?? this.currency,
      geo: geo ?? this.geo,
    );
  }
}
