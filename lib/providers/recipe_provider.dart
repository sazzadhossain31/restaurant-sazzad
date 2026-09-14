import 'package:flutter/foundation.dart';
import '../models/recipe_model.dart';
import '../services/menu_service.dart';

class RecipeProvider with ChangeNotifier {
  final MenuService _service;
  List<RecipeModel> _recipes = [];
  bool _isLoading = false;
  bool _disposed = false;
  String? _errorMessage;
  String _selectedCategory = 'All';

  RecipeProvider({MenuService? service}) : _service = service ?? MenuService() {
    refreshRecipes();
  }
  List<RecipeModel> get allRecipes => List.unmodifiable(_recipes);
  List<RecipeModel> get recipes => _selectedCategory == 'All'
      ? allRecipes
      : _recipes.where((r) => r.category == _selectedCategory).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  List<String> get categories => [
    'All',
    ...(_recipes.map((r) => r.category).toSet().toList()..sort()),
  ];
  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> refreshRecipes() async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _recipes = await _service.loadMenu();
      if (!categories.contains(_selectedCategory)) _selectedCategory = 'All';
    } catch (_) {
      _errorMessage = 'The menu could not be loaded. Please try again.';
    } finally {
      _isLoading = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
