import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/repositories/auth/auth_repository.dart';
import '../../../data/repositories/auth/firebase_auth_repository.dart';

class AuthController extends GetxController {
  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

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
      errorMessage.value = '';
      await _authRepository.signInWithGoogle();
      Get.offAllNamed(AppRoutes.home);
    } on AuthRepositoryException catch (error) {
      errorMessage.value = error.message;
      Get.snackbar(AppStrings.signInFailed, error.message);
    } catch (_) {
      errorMessage.value = AppStrings.errorTitle;
      Get.snackbar(AppStrings.signInFailed, AppStrings.errorTitle);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    Get.offAllNamed(AppRoutes.signIn);
  }
}
