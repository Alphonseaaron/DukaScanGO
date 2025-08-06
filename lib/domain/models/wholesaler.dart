class Wholesaler {
  final String uid;
  final String businessName;
  final String contactPerson;
  final List<String> deliveryAreas;
  final String paymentDetails;

  Wholesaler({
    required this.uid,
    required this.businessName,
    required this.contactPerson,
    required this.deliveryAreas,
    required this.paymentDetails,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'businessName': businessName,
      'contactPerson': contactPerson,
      'deliveryAreas': deliveryAreas,
      'paymentDetails': paymentDetails,
    };
  }

  factory Wholesaler.fromMap(Map<String, dynamic> map) {
    return Wholesaler(
      uid: map['uid'],
      businessName: map['businessName'],
      contactPerson: map['contactPerson'],
      deliveryAreas: List<String>.from(map['deliveryAreas']),
      paymentDetails: map['paymentDetails'],
    );
  }
}
