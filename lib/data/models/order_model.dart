import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_item_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled;

  static OrderStatus fromValue(String value) {
    return OrderStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => OrderStatus.pending,
    );
  }
}

class OrderModel {
  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.createdAt,
    this.updatedAt,
    this.deliveryInstructions = '',
    this.stripePaymentIntentId = '',
  });

  final String id;
  final String userId;
  final List<CartItemModel> items;
  final OrderStatus status;
  final String deliveryAddress;
  final String paymentMethod;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String deliveryInstructions;
  final String stripePaymentIntentId;

  OrderModel copyWith({
    String? id,
    String? userId,
    List<CartItemModel>? items,
    OrderStatus? status,
    String? deliveryAddress,
    String? paymentMethod,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? total,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deliveryInstructions,
    String? stripePaymentIntentId,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      status: status ?? this.status,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      stripePaymentIntentId: stripePaymentIntentId ?? this.stripePaymentIntentId,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List? ?? [];
    return OrderModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      items: itemsJson
          .map((item) => CartItemModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false),
      status: OrderStatus.fromValue(json['status'] as String? ?? ''),
      deliveryAddress: json['deliveryAddress'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? '',
      subtotal: (json['subtotal'] as num? ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] as num? ?? 0).toDouble(),
      tax: (json['tax'] as num? ?? 0).toDouble(),
      total: (json['total'] as num? ?? 0).toDouble(),
      createdAt: _dateTimeFromJson(json['createdAt']) ?? DateTime.now(),
      updatedAt: _dateTimeFromJson(json['updatedAt']),
      deliveryInstructions: json['deliveryInstructions'] as String? ?? '',
      stripePaymentIntentId: json['stripePaymentIntentId'] as String? ?? '',
    );
  }

  factory OrderModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};
    return OrderModel.fromJson({...data, 'id': document.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(growable: false),
      'status': status.name,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'total': total,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deliveryInstructions': deliveryInstructions,
      'stripePaymentIntentId': stripePaymentIntentId,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'items': items
          .map(
            (item) => {
              'id': item.id,
              'foodItemId': item.foodItem.id,
              'name': item.foodItem.name,
              'description': item.foodItem.description,
              'category': item.foodItem.category,
              'imageUrl': item.foodItem.imageUrl,
              'price': item.foodItem.price,
              'quantity': item.quantity,
              'totalPrice': item.totalPrice,
              'selectedOptions': item.selectedOptions,
              'specialInstructions': item.specialInstructions,
            },
          )
          .toList(growable: false),
      'status': status.name,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'total': total,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
      'deliveryInstructions': deliveryInstructions,
      'stripePaymentIntentId': stripePaymentIntentId,
    };
  }

  static DateTime? _dateTimeFromJson(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
