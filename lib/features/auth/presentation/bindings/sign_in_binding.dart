import 'package:get/get.dart';

import '../../../../data/repositories/auth/auth_repository.dart';
import '../../../../data/repositories/auth/firebase_auth_repository.dart';
import '../controllers/sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => FirebaseAuthRepository());
    Get.lazyPut<SignInController>(
      () => SignInController(authRepository: Get.find<AuthRepository>()),
    );
  }
}
