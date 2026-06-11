import '../../models/food_item_model.dart';

abstract class ProductRepository {
  Future<List<FoodItemModel>> fetchAllProducts();

  Future<List<FoodItemModel>> fetchProductsByCategory(String category);
}
