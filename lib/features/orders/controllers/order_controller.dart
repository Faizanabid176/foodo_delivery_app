import 'dart:async';

import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/auth/auth_repository.dart';
import '../../../data/repositories/order/firestore_order_repository.dart';
import '../../../data/repositories/order/order_repository.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../notifications/controllers/notification_controller.dart';

class OrderController extends GetxController {
  OrderController({
    required AuthRepository authRepository,
    required OrderRepository orderRepository,
  })  : _authRepository = authRepository,
        _orderRepository = orderRepository;

  final AuthRepository _authRepository;
  final OrderRepository _orderRepository;
  final orders = <OrderModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  StreamSubscription<List<OrderModel>>? _ordersSubscription;

  OrderModel? get activeOrder {
    final activeOrders = orders.where(
      (order) =>
          order.status != OrderStatus.delivered &&
          order.status != OrderStatus.cancelled,
    );
    return activeOrders.isEmpty ? null : activeOrders.first;
  }

  @override
  void onReady() {
    super.onReady();
    bindUserOrders();
  }

  void bindUserOrders() {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) {
      return;
    }
    _ordersSubscription?.cancel();
    _ordersSubscription = _orderRepository.streamUserOrders(userId).listen(
      (items) {
        _notifyStatusChanges(items);
        orders.assignAll(items);
      },
      onError: (_) => errorMessage.value = AppStrings.errorTitle,
    );
  }

  Future<String> placeOrder({
    required List<CartItemModel> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
    String paymentMethod = AppStrings.paymentTitle,
    String deliveryAddress = AppStrings.currentLocation,
  }) async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) {
      throw const OrderRepositoryException(AppStrings.signInFailed);
    }
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final order = OrderModel(
        id: '',
        userId: userId,
        items: items,
        status: OrderStatus.pending,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        tax: 0,
        total: total,
        createdAt: DateTime.now(),
      );
      final orderId = await _orderRepository.createOrder(order);
      Get.find<CartController>().clearCart();
      if (Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().addNotification(
          title: AppStrings.orderPlaced,
          message: AppStrings.orderPlaced,
        );
      }
      return orderId;
    } on OrderRepositoryException catch (error) {
      errorMessage.value = error.message;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void _notifyStatusChanges(List<OrderModel> updatedOrders) {
    if (!Get.isRegistered<NotificationController>()) {
      return;
    }
    for (final updated in updatedOrders) {
      final previous = orders.firstWhereOrNull((order) => order.id == updated.id);
      if (previous != null && previous.status != updated.status) {
        Get.find<NotificationController>().addNotification(
          title: AppStrings.orderStatusUpdated,
          message: updated.status.label,
          referenceId: updated.id,
        );
      }
    }
  }

  @override
  void onClose() {
    _ordersSubscription?.cancel();
    super.onClose();
  }
}

extension OrderStatusLabel on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return AppStrings.pending;
      case OrderStatus.confirmed:
        return AppStrings.confirmed;
      case OrderStatus.preparing:
        return AppStrings.preparing;
      case OrderStatus.outForDelivery:
        return AppStrings.outForDelivery;
      case OrderStatus.delivered:
        return AppStrings.delivered;
      case OrderStatus.cancelled:
        return AppStrings.cancelled;
    }
  }
}
