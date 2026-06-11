import '../../models/order_model.dart';

abstract class OrderRepository {
  Future<String> createOrder(OrderModel order);

  Stream<List<OrderModel>> streamUserOrders(String userId);

  Future<void> updateOrderStatus(String orderId, OrderStatus status);
}
