import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/views/cart_view.dart';
import '../../notifications/controllers/notification_controller.dart';
import '../../orders/views/order_history_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/product_controller.dart';
import 'widgets/food_card.dart';

class HomeView extends GetView<ProductController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = 0.obs;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.deliverTo,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              AppStrings.currentLocation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        actions: [
          Obx(
            () => Badge(
              isLabelVisible:
                  Get.find<NotificationController>().unreadCount > 0,
              label: Text('${Get.find<NotificationController>().unreadCount}'),
              child: IconButton(
                onPressed: () => Get.toNamed(AppRoutes.notifications),
                icon: const Icon(Icons.notifications_outlined),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(
        () => IndexedStack(
          index: selectedIndex.value,
          children: const [
            _HomeContent(),
            OrderHistoryView(),
            CartView(),
            ProfileView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () {
          final cartController = Get.find<CartController>();
          final cartItemCount = cartController.itemCount;
          return NavigationBar(
          selectedIndex: selectedIndex.value,
          onDestinationSelected: (index) => selectedIndex.value = index,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: AppStrings.homeNav,
            ),
            const NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: AppStrings.ordersNav,
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: cartItemCount > 0,
                label: Text('$cartItemCount'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: cartItemCount > 0,
                label: Text('$cartItemCount'),
                child: const Icon(Icons.shopping_cart),
              ),
              label: AppStrings.cartNav,
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: AppStrings.profileNav,
            ),
          ],
        );
        },
      ),
    );
  }
}

class _HomeContent extends GetView<ProductController> {
  const _HomeContent();

  static DateTime? _lastAddToCartMessageAt;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.loadProducts,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            onChanged: controller.updateSearchQuery,
            decoration: const InputDecoration(
              hintText: AppStrings.searchHint,
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: Obx(
              () => ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  final selected = controller.selectedCategory.value == category;
                  return ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    selectedColor: AppColors.primary,
                    onSelected: (_) => controller.selectCategory(category),
                    labelStyle: TextStyle(
                      color: selected ? AppColors.surface : AppColors.textPrimary,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return const SizedBox(height: 320, child: LoadingWidget());
            }
            if (controller.errorMessage.value.isNotEmpty) {
              return AppErrorWidget(
                message: controller.errorMessage.value,
                onRetry: controller.loadProducts,
              );
            }
            final products = controller.filteredProducts;
            if (products.isEmpty) {
              return const SizedBox(height: 320, child: EmptyStateWidget());
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return FoodCard(
                  foodItem: product,
                  onAddToCart: () {
                    Get.find<CartController>().addItem(product);
                    _showAddToCartMessage();
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }

  void _showAddToCartMessage() {
    final now = DateTime.now();
    final lastShownAt = _lastAddToCartMessageAt;
    if (lastShownAt != null &&
        now.difference(lastShownAt) < const Duration(milliseconds: 900)) {
      return;
    }
    _lastAddToCartMessageAt = now;
    Get.closeAllSnackbars();
    Get.snackbar(
      AppStrings.appName,
      AppStrings.addedToCart,
      duration: const Duration(milliseconds: 900),
    );
  }
}
