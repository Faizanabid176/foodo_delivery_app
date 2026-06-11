import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../data/repositories/auth/auth_repository.dart';
import '../../../../data/repositories/auth/firebase_auth_repository.dart';

class SignInController extends GetxController {
  SignInController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;
  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    if (_authRepository.currentUser != null) {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  Future<void> signInWithGoogle() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      await _authRepository.signInWithGoogle();
      Get.snackbar(AppStrings.appName, AppStrings.signedInSuccessfully);
      Get.offAllNamed(AppRoutes.home);
    } on AuthRepositoryException catch (error) {
      Get.snackbar(AppStrings.appName, error.message);
    } catch (_) {
      Get.snackbar(AppStrings.appName, AppStrings.errorTitle);
    } finally {
      isLoading.value = false;
    }
  }
}
