import 'package:get/get.dart';

import '../../../data/models/notification_model.dart';

class NotificationController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  DateTime? _lastNotificationMessageAt;

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  void addNotification({
    required String title,
    required String message,
    String referenceId = '',
  }) {
    notifications.insert(
      0,
      NotificationModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        userId: '',
        title: title,
        message: message,
        type: NotificationType.order,
        isRead: false,
        createdAt: DateTime.now(),
        referenceId: referenceId,
      ),
    );
    _showNotificationMessage(title: title, message: message);
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((item) => item.id == id);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
    }
  }

  void markAllAsRead() {
    notifications.assignAll(
      notifications
          .map((notification) => notification.copyWith(isRead: true))
          .toList(growable: false),
    );
  }

  void _showNotificationMessage({
    required String title,
    required String message,
  }) {
    final now = DateTime.now();
    final lastShownAt = _lastNotificationMessageAt;
    if (lastShownAt != null &&
        now.difference(lastShownAt) < const Duration(milliseconds: 900)) {
      return;
    }
    _lastNotificationMessageAt = now;
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      duration: const Duration(milliseconds: 1400),
    );
  }
}
