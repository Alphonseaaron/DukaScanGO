import 'package.cloud_firestore/cloud_firestore.dart';

class Wallet {
  final String id;
  final String ownerId;
  final String gateway;
  final String gatewayReference;
  final double balance;
  final String currency;
  final double commissionPercent;
  final double holdBalance;

  Wallet({
    required this.id,
    required this.ownerId,
    required this.gateway,
    required this.gatewayReference,
    required this.balance,
    required this.currency,
    required this.commissionPercent,
    required this.holdBalance,
  });

  factory Wallet.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Wallet(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      gateway: data['gateway'] ?? '',
      gatewayReference: data['gatewayReference'] ?? '',
      balance: (data['balance'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'USD',
      commissionPercent: (data['commissionPercent'] ?? 0.0).toDouble(),
      holdBalance: (data['holdBalance'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'gateway': gateway,
      'gatewayReference': gatewayReference,
      'balance': balance,
      'currency': currency,
      'commissionPercent': commissionPercent,
      'holdBalance': holdBalance,
    };
  }
}
