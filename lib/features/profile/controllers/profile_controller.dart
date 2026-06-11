import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../data/repositories/auth/auth_repository.dart';

class ProfileController extends GetxController {
  ProfileController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;
  final currentUser = Rxn<User>();

  User? get user => currentUser.value;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _authRepository.currentUser;
    currentUser.bindStream(_authRepository.authStateChanges);
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    Get.offAllNamed(AppRoutes.signIn);
  }
}
