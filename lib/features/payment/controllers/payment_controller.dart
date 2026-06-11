import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../orders/controllers/order_controller.dart';
import '../../../data/repositories/order/firestore_order_repository.dart';

class PaymentController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final Dio _dio = Dio();

  @override
  void onReady() {
    super.onReady();
    initiatePayment();
  }

  Future<void> initiatePayment() async {
    final cartController = Get.find<CartController>();
    final secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
    if (secretKey.isEmpty) {
      errorMessage.value = AppStrings.stripeSecretMissing;
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final amount = (cartController.total * 100).round();
      final response = await _dio.post<Map<String, dynamic>>(
        'https://api.stripe.com/v1/payment_intents',
        data: {
          'amount': amount,
          'currency': 'pkr',
          'payment_method_types[]': 'card',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $secretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      final clientSecret = response.data?['client_secret'] as String? ?? '';
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: AppStrings.appName,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      await Get.find<OrderController>().placeOrder(
        items: cartController.cartItems.toList(growable: false),
        subtotal: cartController.subtotal,
        deliveryFee: cartController.deliveryFee,
        total: cartController.total,
      );
      Get.offAllNamed(AppRoutes.orderSuccess);
    } on OrderRepositoryException catch (error) {
      errorMessage.value = error.message;
    } on StripeException catch (error) {
      errorMessage.value = error.error.localizedMessage ?? AppStrings.paymentFailed;
    } on DioException catch (error) {
      errorMessage.value =
          error.response?.data.toString() ?? error.message ?? AppStrings.paymentFailed;
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
