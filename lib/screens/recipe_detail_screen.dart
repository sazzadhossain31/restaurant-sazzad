import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/food_widgets.dart';

class RecipeDetailScreen extends StatefulWidget {
  final RecipeModel recipe;
  const RecipeDetailScreen({super.key, required this.recipe});
  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    final r = widget.recipe;
    final favorites = context.watch<FavoritesProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(r.category),
        actions: [
          IconButton(
            tooltip: 'Toggle favorite',
            onPressed: () => favorites.toggleFavorite(r.id),
            icon: Icon(
              favorites.isFavorite(r.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: AppTheme.orange,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: FoodImage(
                      url: r.imageUrl,
                      height: MediaQuery.sizeOf(context).width < 600
                          ? 260
                          : 390,
                    ),
                  ),
                  Positioned(
                    left: 18,
                    bottom: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.orange,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        r.category.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Text(
                r.restaurant.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.orange,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              Text(r.title, style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: const Icon(Icons.schedule, size: 18),
                    label: Text('${r.cookTimeMinutes} min'),
                  ),
                  Chip(
                    avatar: const Icon(
                      Icons.local_fire_department_outlined,
                      size: 18,
                    ),
                    label: Text('${r.calories} kcal'),
                  ),
                  Chip(
                    avatar: const Icon(Icons.people_outline, size: 18),
                    label: Text('${r.servings} servings'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Artisanal Ingredients',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: r.ingredients
                    .map(
                      (i) => Chip(
                        label: Text(i),
                        backgroundColor: AppTheme.lavender,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 28),
              Text(
                "Chef's Culinary Preparation",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...r.instructions.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppTheme.orange,
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            height: 1.6,
                            color: AppTheme.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: const Color(0xFF252529),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          IconButton.outlined(
                            tooltip: 'Decrease quantity',
                            onPressed: _quantity > 1
                                ? () => setState(() => _quantity--)
                                : null,
                            icon: const Icon(Icons.remove),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton.outlined(
                            tooltip: 'Increase quantity',
                            onPressed: () => setState(() => _quantity++),
                            icon: const Icon(Icons.add),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                '\$${(r.price * _quantity).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24,
                                  color: AppTheme.orange,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.orange,
                          foregroundColor: AppTheme.ink,
                        ),
                        onPressed: () {
                          context.read<CartProvider>().addItem(
                            r,
                            quantity: _quantity,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '$_quantity × ${r.title} added to your dining bag',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_bag_outlined),
                        label: const Text('Add to bag'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
