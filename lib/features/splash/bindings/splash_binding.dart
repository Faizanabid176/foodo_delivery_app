import 'package:get/get.dart';

import '../../../data/repositories/auth/auth_repository.dart';
import '../../../data/repositories/auth/firebase_auth_repository.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => FirebaseAuthRepository(), fenix: true);
    Get.lazyPut<SplashController>(
      () => SplashController(authRepository: Get.find<AuthRepository>()),
    );
  }
}
