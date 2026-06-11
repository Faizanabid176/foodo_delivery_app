// lib/core/middleware/auth_middleware.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final isAuthenticated = FirebaseAuth.instance.currentUser != null;
    return isAuthenticated ? null : const RouteSettings(name: AppRoutes.signIn);
  }
}
