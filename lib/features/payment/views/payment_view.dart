import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.paymentTitle)),
      body: Obx(
        () {
          if (controller.errorMessage.value.isNotEmpty) {
            return AppErrorWidget(
              message: controller.errorMessage.value,
              onRetry: controller.initiatePayment,
            );
          }
          return const LoadingWidget(message: AppStrings.processingPayment);
        },
      ),
    );
  }
}
