import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItemModel {
  const FoodItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.restaurantId,
    required this.restaurantName,
    required this.preparationMinutes,
    required this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final double price;
  final double rating;
  final String restaurantId;
  final String restaurantName;
  final int preparationMinutes;
  final bool isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FoodItemModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? imageUrl,
    double? price,
    double? rating,
    String? restaurantId,
    String? restaurantName,
    int? preparationMinutes,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FoodItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      preparationMinutes: preparationMinutes ?? this.preparationMinutes,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      rating: (json['rating'] as num? ?? 0).toDouble(),
      restaurantId: json['restaurantId'] as String? ?? '',
      restaurantName: json['restaurantName'] as String? ?? '',
      preparationMinutes: (json['preparationMinutes'] as num? ?? 0).toInt(),
      isAvailable: json['isAvailable'] as bool? ?? true,
      createdAt: _dateTimeFromJson(json['createdAt']),
      updatedAt: _dateTimeFromJson(json['updatedAt']),
    );
  }

  factory FoodItemModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};
    return FoodItemModel.fromJson({...data, 'id': document.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'price': price,
      'rating': rating,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'preparationMinutes': preparationMinutes,
      'isAvailable': isAvailable,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
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
