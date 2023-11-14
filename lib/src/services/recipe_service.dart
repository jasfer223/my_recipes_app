import 'package:fernandez_recipe_app/src/model/recipe.dart';
import 'package:fernandez_recipe_app/src/repositories/recipes_repository.dart';
import 'package:fernandez_recipe_app/src/repositories/intefaces/irecipes_repository.dart';

class RecipeService {
  IRecipesRepository? _repository;

  RecipeService() {
    _repository = RecipesRepository();
  }

  Future<void> saveRecipe(Recipe recipe) async {
    await _repository!.createRecipe(recipe);
  }

  Future<List<Recipe>> getAllRecipes() async {
    return await _repository!.getRecipes();
  }

  Future<void> deleteRecipe(int id) async {
    await _repository!.deleteRecipe(id);
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _repository!.updateRecipe(recipe);
  }

  Future<Recipe> getRecipeById(int id) async {
    return await _repository!.getRecipeById(id);
  }
}
