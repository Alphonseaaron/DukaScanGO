import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String? id;
  final String clientId;
  final String? deliveryId;
  final String address;
  final double total;
  final String paymentType;
  final String status;
  final DateTime date;
  final List<OrderDetail> details;

  Order({
    this.id,
    required this.clientId,
    this.deliveryId,
    required this.address,
    required this.total,
    required this.paymentType,
    required this.status,
    required this.date,
    required this.details,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'deliveryId': deliveryId,
      'address': address,
      'total': total,
      'paymentType': paymentType,
      'status': status,
      'date': date,
      'details': details.map((e) => e.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    return Order(
      id: id,
      clientId: map['clientId'],
      deliveryId: map['deliveryId'],
      address: map['address'],
      total: map['total'],
      paymentType: map['paymentType'],
      status: map['status'],
      date: (map['date'] as Timestamp).toDate(),
      details: List<OrderDetail>.from(
          map['details']?.map((x) => OrderDetail.fromMap(x))),
    );
  }
}

class OrderDetail {
  final String productId;
  final String productName;
  final double price;
  final int quantity;

  OrderDetail({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
    };
  }

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      productId: map['productId'],
      productName: map['productName'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }
}
