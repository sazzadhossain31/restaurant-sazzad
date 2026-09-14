import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/recipe_model.dart';

class MenuService {
  final AssetBundle bundle;
  MenuService({AssetBundle? bundle}) : bundle = bundle ?? rootBundle;

  Future<List<RecipeModel>> loadMenu() async {
    final data = jsonDecode(await bundle.loadString('assets/data/menu.json'));
    if (data is! Map<String, dynamic> || data['recipes'] is! List) {
      throw const FormatException('Menu must contain a recipes array.');
    }
    final ids = <String>{};
    return (data['recipes'] as List).map((entry) {
      if (entry is! Map<String, dynamic> ||
          entry['id'] is! String ||
          (entry['id'] as String).isEmpty ||
          !ids.add(entry['id'])) {
        throw const FormatException(
          'Each menu item needs a unique, nonempty id.',
        );
      }
      for (final field in ['title', 'category', 'restaurant', 'imageUrl']) {
        if (entry[field] is! String ||
            (entry[field] as String).trim().isEmpty) {
          throw FormatException('Invalid menu field: $field');
        }
      }
      for (final field in [
        'price',
        'cookTimeMinutes',
        'servings',
        'calories',
      ]) {
        if (entry[field] is! num ||
            !(entry[field] as num).isFinite ||
            entry[field] < 0) {
          throw FormatException('Invalid menu field: $field');
        }
      }
      return RecipeModel.fromMap(entry, entry['id']);
    }).toList();
  }
}
