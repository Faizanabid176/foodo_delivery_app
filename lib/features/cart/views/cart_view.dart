import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.cartItems.isEmpty) {
          return const EmptyStateWidget();
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...controller.cartItems.map(
              (item) => Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: AppColors.error,
                  child: const Icon(Icons.delete, color: AppColors.surface),
                ),
                onDismissed: (_) => controller.removeItem(item.id),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 58,
                      height: 58,
                      child: item.foodItem.imageUrl.isEmpty
                          ? const ColoredBox(
                              color: AppColors.divider,
                              child: Icon(Icons.fastfood),
                            )
                          : Image.network(item.foodItem.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  title: Text(item.foodItem.name),
                  subtitle: Text(CurrencyFormatter.format(item.totalPrice)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => controller.decreaseQuantity(item.id),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        onPressed: () => controller.increaseQuantity(item.id),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.orderSummary,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      label: AppStrings.subtotal,
                      value: controller.subtotal,
                    ),
                    _SummaryRow(
                      label: AppStrings.deliveryFee,
                      value: controller.deliveryFee,
                    ),
                    const Divider(),
                    _SummaryRow(label: AppStrings.total, value: controller.total),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Get.toNamed(AppRoutes.payment),
                      child: const Text(AppStrings.proceedToPayment),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(CurrencyFormatter.format(value)),
        ],
      ),
    );
  }
}
