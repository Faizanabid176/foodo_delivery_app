import 'dart:async';

import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../data/repositories/auth/auth_repository.dart';

class SplashController extends GetxController {
  SplashController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  void onReady() {
    super.onReady();
    unawaited(_navigateAfterDelay());
  }

  Future<void> _navigateAfterDelay() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    final route =
        _authRepository.currentUser == null ? AppRoutes.signIn : AppRoutes.home;
    Get.offAllNamed(route);
  }
}
