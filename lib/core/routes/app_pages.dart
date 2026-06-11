// lib/core/routes/app_pages.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_strings.dart';
import '../middleware/auth_middleware.dart';
import '../../features/auth/bindings/auth_binding.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/home/views/home_view.dart';
import '../../features/notifications/bindings/notifications_binding.dart';
import '../../features/notifications/views/notifications_view.dart';
import '../../features/orders/bindings/orders_binding.dart';
import '../../features/orders/views/order_detail_view.dart';
import '../../features/orders/views/order_history_view.dart';
import '../../features/payment/bindings/payment_binding.dart';
import '../../features/payment/views/order_success_view.dart';
import '../../features/payment/views/payment_view.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/splash/bindings/splash_binding.dart';
import '../../features/splash/views/splash_view.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final unknownRoute = GetPage(
    name: '/not-found',
    page: () => const FoodoRoutePage(title: AppStrings.notFoundTitle),
  );

  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const FoodoRoutePage(title: AppStrings.onboardingTitle),
      binding: FoodoRouteBinding(),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => const LoginView(),
      binding: AuthBinding(),
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
      page: () => const HomeView(),
      binding: HomeBinding(),
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
      page: () => const PaymentView(),
      binding: PaymentBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.orderSuccess,
      page: () => const OrderSuccessView(),
      binding: OrdersBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => const Scaffold(
        appBar: null,
        body: OrderHistoryView(),
      ),
      binding: OrdersBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.orderDetails,
      page: () => const OrderDetailView(),
      binding: OrdersBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const Scaffold(
        appBar: null,
        body: ProfileView(),
      ),
      binding: ProfileBinding(),
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
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
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
