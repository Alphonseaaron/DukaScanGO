import 'package:cloud_firestore/cloud_firestore.dart';

enum LedgerEntryType { credit, debit }
enum LedgerEntryStatus { pending, completed, failed, on_hold }

class WalletLedgerEntry {
  final String id;
  final LedgerEntryType type;
  final double amount;
  final String description;
  final double gatewayFee;
  final double platformFee;
  final LedgerEntryStatus status;
  final Timestamp createdAt;

  WalletLedgerEntry({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.gatewayFee,
    required this.platformFee,
    required this.status,
    required this.createdAt,
  });

  factory WalletLedgerEntry.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WalletLedgerEntry(
      id: doc.id,
      type: LedgerEntryType.values.firstWhere((e) => e.toString() == 'LedgerEntryType.${data['type']}', orElse: () => LedgerEntryType.credit),
      amount: (data['amount'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
      gatewayFee: (data['gatewayFee'] ?? 0.0).toDouble(),
      platformFee: (data['platformFee'] ?? 0.0).toDouble(),
      status: LedgerEntryStatus.values.firstWhere((e) => e.toString() == 'LedgerEntryStatus.${data['status']}', orElse: () => LedgerEntryStatus.pending),
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString().split('.').last,
      'amount': amount,
      'description': description,
      'gatewayFee': gatewayFee,
      'platformFee': platformFee,
      'status': status.toString().split('.').last,
      'createdAt': createdAt,
    };
  }
}
