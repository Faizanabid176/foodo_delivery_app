import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 88,
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.orderSuccessTitle,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.orderPlaced,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () => Get.offAllNamed(AppRoutes.home),
                child: const Text(AppStrings.homeTitle),
              ),
              TextButton(
                onPressed: () => Get.offAllNamed(AppRoutes.orders),
                child: const Text(AppStrings.viewOrders),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
