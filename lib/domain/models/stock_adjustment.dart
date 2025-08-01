import 'package:cloud_firestore/cloud_firestore.dart';

class StockAdjustment {
  final String? id;
  final String productId;
  final int oldQuantity;
  final int newQuantity;
  final String reason;
  final DateTime date;
  final String userId;

  StockAdjustment({
    this.id,
    required this.productId,
    required this.oldQuantity,
    required this.newQuantity,
    required this.reason,
    required this.date,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'oldQuantity': oldQuantity,
      'newQuantity': newQuantity,
      'reason': reason,
      'date': date,
      'userId': userId,
    };
  }

  factory StockAdjustment.fromMap(Map<String, dynamic> map, String id) {
    return StockAdjustment(
      id: id,
      productId: map['productId'],
      oldQuantity: map['oldQuantity'],
      newQuantity: map['newQuantity'],
      reason: map['reason'],
      date: (map['date'] as Timestamp).toDate(),
      userId: map['userId'],
    );
  }
}
