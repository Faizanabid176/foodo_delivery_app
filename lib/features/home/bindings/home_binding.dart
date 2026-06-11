import 'package:get/get.dart';

import '../../../data/repositories/product/firestore_product_repository.dart';
import '../../../data/repositories/product/product_repository.dart';
import '../../../data/repositories/auth/auth_repository.dart';
import '../../../data/repositories/auth/firebase_auth_repository.dart';
import '../../../data/repositories/order/firestore_order_repository.dart';
import '../../../data/repositories/order/order_repository.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../notifications/controllers/notification_controller.dart';
import '../../orders/controllers/order_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/product_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductRepository>(() => FirestoreProductRepository());
    Get.lazyPut<AuthRepository>(() => FirebaseAuthRepository(), fenix: true);
    Get.lazyPut<OrderRepository>(() => FirestoreOrderRepository(), fenix: true);
    Get.lazyPut<ProductController>(
      () => ProductController(productRepository: Get.find<ProductRepository>()),
    );
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController(), permanent: true);
    }
    Get.lazyPut<NotificationController>(() => NotificationController(), fenix: true);
    Get.lazyPut<OrderController>(
      () => OrderController(
        authRepository: Get.find<AuthRepository>(),
        orderRepository: Get.find<OrderRepository>(),
      ),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(authRepository: Get.find<AuthRepository>()),
      fenix: true,
    );
  }
}
