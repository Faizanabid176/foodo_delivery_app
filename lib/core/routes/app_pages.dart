// lib/core/routes/app_pages.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_strings.dart';
import '../middleware/auth_middleware.dart';
import '../../features/auth/presentation/bindings/sign_in_binding.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final unknownRoute = GetPage(
    name: '/not-found',
    page: () => const FoodoRoutePage(title: AppStrings.notFoundTitle),
  );

  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const FoodoRoutePage(title: AppStrings.appName),
      binding: FoodoRouteBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const FoodoRoutePage(title: AppStrings.onboardingTitle),
      binding: FoodoRouteBinding(),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => const SignInPage(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const FoodoRoutePage(title: AppStrings.signUpTitle),
      binding: FoodoRouteBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const FoodoRoutePage(title: AppStrings.forgotPasswordTitle),
      binding: FoodoRouteBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const FoodoRoutePage(title: AppStrings.homeTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.restaurants,
      page: () => const FoodoRoutePage(title: AppStrings.restaurantsTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.restaurantDetails,
      page: () => const FoodoRoutePage(title: AppStrings.restaurantDetailsTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.foodDetails,
      page: () => const FoodoRoutePage(title: AppStrings.foodDetailsTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const FoodoRoutePage(title: AppStrings.searchTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => const FoodoRoutePage(title: AppStrings.favoritesTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const FoodoRoutePage(title: AppStrings.cartTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const FoodoRoutePage(title: AppStrings.checkoutTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.payment,
      page: () => const FoodoRoutePage(title: AppStrings.paymentTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.orderSuccess,
      page: () => const FoodoRoutePage(title: AppStrings.orderSuccessTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => const FoodoRoutePage(title: AppStrings.ordersTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.orderDetails,
      page: () => const FoodoRoutePage(title: AppStrings.orderDetailsTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const FoodoRoutePage(title: AppStrings.profileTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const FoodoRoutePage(title: AppStrings.editProfileTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.addresses,
      page: () => const FoodoRoutePage(title: AppStrings.addressesTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.addAddress,
      page: () => const FoodoRoutePage(title: AppStrings.addAddressTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const FoodoRoutePage(title: AppStrings.notificationsTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const FoodoRoutePage(title: AppStrings.settingsTitle),
      binding: FoodoRouteBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}

class FoodoRouteBinding extends Bindings {
  @override
  void dependencies() {}
}

class FoodoRoutePage extends StatelessWidget {
  const FoodoRoutePage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
