import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/order_model.dart';
import 'widgets/status_timeline.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as OrderModel?;
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.orderDetailsTitle)),
      body: order == null
          ? const Center(child: Text(AppStrings.errorTitle))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  '${AppStrings.ordersTitle} #${order.id}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                StatusTimeline(status: order.status),
                const SizedBox(height: 16),
                Text(
                  AppStrings.orderSummary,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                for (final item in order.items)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.foodItem.name),
                    subtitle: Text('${item.quantity}'),
                    trailing: Text(CurrencyFormatter.format(item.totalPrice)),
                  ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(AppStrings.total),
                  trailing: Text(CurrencyFormatter.format(order.total)),
                ),
              ],
            ),
    );
  }
}
