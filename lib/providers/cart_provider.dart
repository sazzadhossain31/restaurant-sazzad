import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';

class CartItem {
  final RecipeModel recipe;
  int quantity;

  CartItem({required this.recipe, required this.quantity});
}

class CartProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  final Map<String, CartItem> _items = {};

  CartProvider(this._prefs) {
    _loadCart();
  }

  Map<String, CartItem> get items => {..._items};

  int get itemCount {
    int total = 0;
    _items.forEach((key, item) {
      total += item.quantity;
    });
    return total;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.recipe.price * item.quantity;
    });
    return total;
  }

  bool get isEmpty => _items.isEmpty;

  // Load cart items from SharedPreferences
  void _loadCart() {
    try {
      final String? cartJson = _prefs.getString('json_menu_cart_v1');
      if (cartJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(cartJson);
        decoded.forEach((key, val) {
          final int quantity = val['quantity'] ?? 1;
          final Map<String, dynamic> recipeMap = val['recipe'] ?? {};
          final String recipeId = val['recipeId'] ?? '';
          _items[key] = CartItem(
            recipe: RecipeModel.fromMap(recipeMap, recipeId),
            quantity: quantity,
          );
        });
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  // Save cart items to SharedPreferences as encoded JSON
  void _saveCart() {
    try {
      final Map<String, dynamic> toEncode = {};
      _items.forEach((key, item) {
        toEncode[key] = {
          'quantity': item.quantity,
          'recipeId': item.recipe.id,
          'recipe': item.recipe.toMap(),
        };
      });
      _prefs.setString('json_menu_cart_v1', jsonEncode(toEncode));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  void addItem(RecipeModel recipe, {int quantity = 1}) {
    // Stable menu IDs keep cart entries consistent across reloads.
    if (recipe.id.isEmpty || quantity < 1) return;
    final String key = recipe.id;
    if (_items.containsKey(key)) {
      _items.update(
        key,
        (existingItem) => CartItem(
          recipe: existingItem.recipe,
          quantity: existingItem.quantity + quantity,
        ),
      );
    } else {
      _items.putIfAbsent(
        key,
        () => CartItem(recipe: recipe, quantity: quantity),
      );
    }
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(String recipeIdOrTitle, int quantity) {
    if (_items.containsKey(recipeIdOrTitle)) {
      if (quantity <= 0) {
        _items.remove(recipeIdOrTitle);
      } else {
        _items[recipeIdOrTitle]!.quantity = quantity;
      }
      _saveCart();
      notifyListeners();
    }
  }

  void removeItem(String recipeIdOrTitle) {
    _items.remove(recipeIdOrTitle);
    _saveCart();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }
}
