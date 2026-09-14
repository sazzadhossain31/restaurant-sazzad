class RecipeModel {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final int cookTimeMinutes;
  final int servings;
  final List<String> ingredients;
  final List<String> instructions;
  final double price;
  final int calories;
  final String restaurant;

  RecipeModel({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.cookTimeMinutes,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    required this.price,
    required this.calories,
    required this.restaurant,
  });

  // Factory constructor to create a RecipeModel from a Map / Firestore document
  factory RecipeModel.fromMap(Map<String, dynamic> map, String documentId) {
    return RecipeModel(
      id: documentId,
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      cookTimeMinutes: (map['cookTimeMinutes'] as num?)?.toInt() ?? 0,
      servings: (map['servings'] as num?)?.toInt() ?? 0,
      ingredients: List<String>.from(map['ingredients'] ?? const []),
      instructions: List<String>.from(map['instructions'] ?? const []),
      price: (map['price'] as num?)?.toDouble() ?? 0,
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      restaurant: map['restaurant'] ?? '',
    );
  }

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'imageUrl': imageUrl,
      'cookTimeMinutes': cookTimeMinutes,
      'servings': servings,
      'ingredients': ingredients,
      'instructions': instructions,
      'price': price,
      'calories': calories,
      'restaurant': restaurant,
    };
  }
}
