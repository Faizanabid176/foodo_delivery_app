import 'package:get/get.dart';

import '../../../data/repositories/auth/auth_repository.dart';
import '../../../data/repositories/auth/firebase_auth_repository.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => FirebaseAuthRepository(), fenix: true);
    Get.lazyPut<AuthController>(
      () => AuthController(authRepository: Get.find<AuthRepository>()),
    );
  }
}
