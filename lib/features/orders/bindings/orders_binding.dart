import 'package:get/get.dart';

import '../../../data/repositories/auth/auth_repository.dart';
import '../../../data/repositories/auth/firebase_auth_repository.dart';
import '../../../data/repositories/order/firestore_order_repository.dart';
import '../../../data/repositories/order/order_repository.dart';
import '../controllers/order_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => FirebaseAuthRepository(), fenix: true);
    Get.lazyPut<OrderRepository>(() => FirestoreOrderRepository(), fenix: true);
    Get.lazyPut<OrderController>(
      () => OrderController(
        authRepository: Get.find<AuthRepository>(),
        orderRepository: Get.find<OrderRepository>(),
      ),
      fenix: true,
    );
  }
}
