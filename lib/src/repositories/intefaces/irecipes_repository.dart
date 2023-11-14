import 'package:fernandez_recipe_app/src/model/recipe.dart';

abstract class IRecipesRepository {
  Future<List<Recipe>> getRecipes();
  Future<Recipe> createRecipe(Recipe recipe);
  Future<Recipe> updateRecipe(Recipe recipe);
  Future<void> deleteRecipe(int id);
  Future<Recipe> getRecipeById(int id);
}
