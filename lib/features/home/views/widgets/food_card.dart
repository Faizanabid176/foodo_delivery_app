import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../data/models/food_item_model.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({
    required this.foodItem,
    required this.onAddToCart,
    super.key,
  });

  final FoodItemModel foodItem;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: foodItem.imageUrl.isEmpty
                ? const _FoodImagePlaceholder()
                : Image.network(
                    foodItem.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const _FoodImagePlaceholder(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodItem.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  foodItem.restaurantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        CurrencyFormatter.format(foodItem.price),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: onAddToCart,
                      tooltip: AppStrings.addToCart,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodImagePlaceholder extends StatelessWidget {
  const _FoodImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.divider,
      child: Center(
        child: Icon(
          Icons.fastfood,
          color: AppColors.primary,
          size: 42,
        ),
      ),
    );
  }
}
