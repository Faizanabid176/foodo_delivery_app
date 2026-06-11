import 'package:cloud_firestore/cloud_firestore.dart';

import 'food_item_model.dart';

class CartItemModel {
  const CartItemModel({
    required this.id,
    required this.foodItem,
    required this.quantity,
    required this.selectedOptions,
    required this.specialInstructions,
    required this.addedAt,
  });

  final String id;
  final FoodItemModel foodItem;
  final int quantity;
  final Map<String, dynamic> selectedOptions;
  final String specialInstructions;
  final DateTime addedAt;

  double get totalPrice => foodItem.price * quantity;

  CartItemModel copyWith({
    String? id,
    FoodItemModel? foodItem,
    int? quantity,
    Map<String, dynamic>? selectedOptions,
    String? specialInstructions,
    DateTime? addedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final foodItemJson = json['foodItem'] == null
        ? {
            'id': json['foodItemId'] ?? json['id'],
            'name': json['name'],
            'description': json['description'],
            'category': json['category'],
            'imageUrl': json['imageUrl'],
            'price': json['price'],
            'rating': json['rating'],
            'restaurantId': json['restaurantId'],
            'restaurantName': json['restaurantName'],
            'preparationMinutes': json['preparationMinutes'],
            'preparationTime': json['preparationTime'],
            'isAvailable': json['isAvailable'],
          }
        : Map<String, dynamic>.from(json['foodItem'] as Map? ?? {});
    return CartItemModel(
      id: json['id'] as String? ?? '',
      foodItem: FoodItemModel.fromJson(foodItemJson),
      quantity: (json['quantity'] as num? ?? 1).toInt(),
      selectedOptions: Map<String, dynamic>.from(
        json['selectedOptions'] as Map? ?? {},
      ),
      specialInstructions: json['specialInstructions'] as String? ?? '',
      addedAt: _dateTimeFromJson(json['addedAt']) ?? DateTime.now(),
    );
  }

  factory CartItemModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};
    return CartItemModel.fromJson({...data, 'id': document.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodItem': foodItem.toJson(),
      'quantity': quantity,
      'selectedOptions': selectedOptions,
      'specialInstructions': specialInstructions,
      'addedAt': addedAt,
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
