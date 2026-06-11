import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../data/models/food_item_model.dart';
import '../../../data/repositories/product/firestore_product_repository.dart';
import '../../../data/repositories/product/product_repository.dart';

class ProductController extends GetxController {
  ProductController({required ProductRepository productRepository})
      : _productRepository = productRepository;

  final ProductRepository _productRepository;
  final allProducts = <FoodItemModel>[].obs;
  final selectedCategory = AppStrings.allCategory.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final categories = const [
    AppStrings.allCategory,
    AppStrings.pizzaCategory,
    AppStrings.burgerCategory,
    AppStrings.dessertCategory,
    AppStrings.drinksCategory,
  ].obs;

  List<FoodItemModel> get filteredProducts {
    final query = searchQuery.value.trim().toLowerCase();
    return allProducts.where((product) {
      final matchesCategory = selectedCategory.value == AppStrings.allCategory ||
          product.category == selectedCategory.value;
      final matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.restaurantName.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList(growable: false);
  }

  @override
  void onReady() {
    super.onReady();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      allProducts.assignAll(await _productRepository.fetchAllProducts());
    } on ProductRepositoryException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = AppStrings.errorTitle;
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void updateSearchQuery(String value) {
    searchQuery.value = value;
  }
}
