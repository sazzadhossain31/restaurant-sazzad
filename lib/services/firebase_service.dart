import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'recipes';

  // 1. Get recipes as a Stream (for reactive, real-time lists)
  Stream<List<RecipeModel>> getRecipesStream() {
    return _firestore.collection(_collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return RecipeModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // 2. Get recipes as a Future (for one-off loads)
  Future<List<RecipeModel>> getRecipesFuture() async {
    try {
      final snapshot = await _firestore.collection(_collectionPath).get();
      return snapshot.docs.map((doc) {
        return RecipeModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw 'Failed to fetch recipes: $e';
    }
  }

  // 3. Get recipes filtered by Category as a Stream
  Stream<List<RecipeModel>> getRecipesByCategoryStream(String category) {
    return _firestore
        .collection(_collectionPath)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return RecipeModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  // 4. Get recipes filtered by Category as a Future
  Future<List<RecipeModel>> getRecipesByCategoryFuture(String category) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionPath)
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) {
        return RecipeModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw 'Failed to fetch recipes for category "$category": $e';
    }
  }

  // 5. Get a single recipe by its document ID
  Future<RecipeModel> getRecipeById(String recipeId) async {
    try {
      final doc = await _firestore
          .collection(_collectionPath)
          .doc(recipeId)
          .get();
      if (!doc.exists) {
        throw 'Recipe not found.';
      }
      return RecipeModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw 'Failed to fetch recipe details: $e';
    }
  }

  // 6. Create / Add a new recipe
  Future<String> addRecipe(RecipeModel recipe) async {
    try {
      final docRef = await _firestore
          .collection(_collectionPath)
          .add(recipe.toMap());
      return docRef.id;
    } catch (e) {
      throw 'Failed to add recipe: $e';
    }
  }

  // 7. Update an existing recipe
  Future<void> updateRecipe(RecipeModel recipe) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(recipe.id)
          .update(recipe.toMap());
    } catch (e) {
      throw 'Failed to update recipe: $e';
    }
  }

  // 8. Delete a recipe
  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _firestore.collection(_collectionPath).doc(recipeId).delete();
    } catch (e) {
      throw 'Failed to delete recipe: $e';
    }
  }
}
