import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/order_model.dart';
import 'order_repository.dart';

class OrderRepositoryException implements Exception {
  const OrderRepositoryException(this.message, [this.code]);

  final String message;
  final String? code;

  @override
  String toString() {
    return code == null ? message : '$message ($code)';
  }
}

class FirestoreOrderRepository implements OrderRepository {
  FirestoreOrderRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection('orders');

  @override
  Future<String> createOrder(OrderModel order) async {
    try {
      final document = order.id.isEmpty ? _orders.doc() : _orders.doc(order.id);
      final orderWithId = order.copyWith(id: document.id);
      await document.set(orderWithId.toJson());
      return document.id;
    } on FirebaseException catch (error) {
      throw OrderRepositoryException(
        error.message ?? 'Unable to create order.',
        error.code,
      );
    } catch (_) {
      throw const OrderRepositoryException('Unable to create order.');
    }
  }

  @override
  Stream<List<OrderModel>> streamUserOrders(String userId) {
    try {
      return _orders
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map(OrderModel.fromFirestore)
                .toList(growable: false),
          )
          .handleError((Object error) {
        if (error is FirebaseException) {
          throw OrderRepositoryException(
            error.message ?? 'Unable to stream user orders.',
            error.code,
          );
        }
        throw const OrderRepositoryException('Unable to stream user orders.');
      });
    } catch (_) {
      throw const OrderRepositoryException('Unable to stream user orders.');
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _orders.doc(orderId).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (error) {
      throw OrderRepositoryException(
        error.message ?? 'Unable to update order status.',
        error.code,
      );
    } catch (_) {
      throw const OrderRepositoryException('Unable to update order status.');
    }
  }
}
