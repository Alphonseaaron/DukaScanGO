import 'package:cloud_firestore/cloud_firestore.dart';

class RestockingRequest {
  final String? id;
  final String productId;
  final String productName;
  final int currentQuantity;
  final int lowStockThreshold;
  final String status; // e.g., 'pending', 'approved', 'ordered'
  final DateTime dateRequested;
  final String requestorId;

  RestockingRequest({
    this.id,
    required this.productId,
    required this.productName,
    required this.currentQuantity,
    required this.lowStockThreshold,
    required this.status,
    required this.dateRequested,
    required this.requestorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'currentQuantity': currentQuantity,
      'lowStockThreshold': lowStockThreshold,
      'status': status,
      'dateRequested': dateRequested,
      'requestorId': requestorId,
    };
  }

  factory RestockingRequest.fromMap(Map<String, dynamic> map, String id) {
    return RestockingRequest(
      id: id,
      productId: map['productId'],
      productName: map['productName'],
      currentQuantity: map['currentQuantity'],
      lowStockThreshold: map['lowStockThreshold'],
      status: map['status'],
      dateRequested: (map['dateRequested'] as Timestamp).toDate(),
      requestorId: map['requestorId'],
    );
  }
}
