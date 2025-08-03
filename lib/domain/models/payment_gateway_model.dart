import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentGateway {
  final String id;
  final String name;
  final Map<String, dynamic> apiConfig;
  final List<String> allowedCountries;

  PaymentGateway({
    required this.id,
    required this.name,
    required this.apiConfig,
    required this.allowedCountries,
  });

  factory PaymentGateway.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PaymentGateway(
      id: doc.id,
      name: data['name'] ?? '',
      apiConfig: Map<String, dynamic>.from(data['apiConfig'] ?? {}),
      allowedCountries: List<String>.from(data['allowedCountries'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'apiConfig': apiConfig,
      'allowedCountries': allowedCountries,
    };
  }
}
