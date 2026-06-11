import 'package:get/get.dart';

import '../../../data/models/cart_item_model.dart';
import '../../../data/models/food_item_model.dart';

class CartController extends GetxController {
  final cartItems = <CartItemModel>[].obs;

  int get itemCount =>
      cartItems.fold(0, (total, item) => total + item.quantity);

  double get subtotal =>
      cartItems.fold(0, (total, item) => total + item.totalPrice);

  double get deliveryFee => cartItems.isEmpty ? 0 : 150;

  double get total => subtotal + deliveryFee;

  void addItem(FoodItemModel foodItem) {
    final index =
        cartItems.indexWhere((item) => item.foodItem.id == foodItem.id);
    if (index == -1) {
      cartItems.add(
        CartItemModel(
          id: foodItem.id,
          foodItem: foodItem,
          quantity: 1,
          selectedOptions: const {},
          specialInstructions: '',
          addedAt: DateTime.now(),
        ),
      );
      return;
    }

    cartItems[index] = cartItems[index].copyWith(
      quantity: cartItems[index].quantity + 1,
    );
  }

  void removeItem(String cartItemId) {
    cartItems.removeWhere((item) => item.id == cartItemId);
  }

  void increaseQuantity(String cartItemId) {
    final index = cartItems.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      cartItems[index] = cartItems[index].copyWith(
        quantity: cartItems[index].quantity + 1,
      );
    }
  }

  void decreaseQuantity(String cartItemId) {
    final index = cartItems.indexWhere((item) => item.id == cartItemId);
    if (index == -1) {
      return;
    }
    final item = cartItems[index];
    if (item.quantity <= 1) {
      removeItem(cartItemId);
      return;
    }
    cartItems[index] = item.copyWith(quantity: item.quantity - 1);
  }

  void clearCart() {
    cartItems.clear();
  }
}
