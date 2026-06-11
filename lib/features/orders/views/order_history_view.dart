import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../controllers/order_controller.dart';

class OrderHistoryView extends GetView<OrderController> {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return AppErrorWidget(message: controller.errorMessage.value);
        }
        if (controller.orders.isEmpty) {
          return const EmptyStateWidget(
            title: AppStrings.noOrders,
            message: AppStrings.emptyStateMessage,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              tileColor: Theme.of(context).colorScheme.surface,
              title: Text('${AppStrings.ordersTitle} #${order.id}'),
              subtitle: Text(order.status.label),
              trailing: Text(CurrencyFormatter.format(order.total)),
              onTap: () => Get.toNamed(
                AppRoutes.orderDetails,
                arguments: order,
              ),
            );
          },
        );
      },
    );
  }
}
