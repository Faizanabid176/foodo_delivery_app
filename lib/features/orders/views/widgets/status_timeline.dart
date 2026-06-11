import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/order_model.dart';
import '../../controllers/order_controller.dart';

class StatusTimeline extends StatelessWidget {
  const StatusTimeline({required this.status, super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final steps = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];
    final currentIndex = steps.indexOf(status);

    return Column(
      children: [
        for (var index = 0; index < steps.length; index++)
          ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  index <= currentIndex ? AppColors.success : AppColors.divider,
              child: Icon(
                index <= currentIndex ? Icons.check : Icons.circle_outlined,
                color: AppColors.surface,
              ),
            ),
            title: Text(steps[index].label),
          ),
      ],
    );
  }
}
