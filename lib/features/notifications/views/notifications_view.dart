import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../controllers/notification_controller.dart';

class NotificationsView extends GetView<NotificationController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notificationsTitle),
        actions: [
          Obx(
            () => Badge(
              isLabelVisible: controller.unreadCount > 0,
              label: Text('${controller.unreadCount}'),
              child: IconButton(
                onPressed: controller.markAllAsRead,
                tooltip: AppStrings.markAllRead,
                icon: const Icon(Icons.done_all),
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.notifications.isEmpty) {
            return const EmptyStateWidget(
              title: AppStrings.noNotifications,
              message: AppStrings.emptyStateMessage,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return ListTile(
                tileColor: notification.isRead
                    ? AppColors.surface
                    : AppColors.primary.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                leading: const Icon(Icons.notifications_outlined),
                title: Text(notification.title),
                subtitle: Text(notification.message),
                onTap: () => controller.markAsRead(notification.id),
              );
            },
          );
        },
      ),
    );
  }
}
