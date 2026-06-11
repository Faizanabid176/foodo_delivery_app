import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/food_item_model.dart';
import 'product_repository.dart';

class ProductRepositoryException implements Exception {
  const ProductRepositoryException(this.message, [this.code]);

  final String message;
  final String? code;

  @override
  String toString() {
    return code == null ? message : '$message ($code)';
  }
}

class FirestoreProductRepository implements ProductRepository {
  FirestoreProductRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  @override
  Future<List<FoodItemModel>> fetchAllProducts() async {
    try {
      final snapshot = await _products
          .where('isAvailable', isEqualTo: true)
          .orderBy('name')
          .get();
      return snapshot.docs.map(FoodItemModel.fromFirestore).toList(growable: false);
    } on FirebaseException catch (error) {
      throw ProductRepositoryException(
        error.message ?? 'Unable to fetch products.',
        error.code,
      );
    } catch (_) {
      throw const ProductRepositoryException('Unable to fetch products.');
    }
  }

  @override
  Future<List<FoodItemModel>> fetchProductsByCategory(String category) async {
    try {
      final snapshot = await _products
          .where('category', isEqualTo: category)
          .where('isAvailable', isEqualTo: true)
          .orderBy('name')
          .get();
      return snapshot.docs.map(FoodItemModel.fromFirestore).toList(growable: false);
    } on FirebaseException catch (error) {
      throw ProductRepositoryException(
        error.message ?? 'Unable to fetch products by category.',
        error.code,
      );
    } catch (_) {
      throw const ProductRepositoryException('Unable to fetch products by category.');
    }
  }
}
