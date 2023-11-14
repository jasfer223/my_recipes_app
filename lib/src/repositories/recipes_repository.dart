import 'package:fernandez_recipe_app/src/database/db_connection.dart';
import 'package:fernandez_recipe_app/src/model/recipe.dart';
import 'package:fernandez_recipe_app/src/repositories/intefaces/irecipes_repository.dart';

class RecipesRepository implements IRecipesRepository {
  final DatabaseConnection _databaseConnection = DatabaseConnection();

  @override
  Future<Recipe> createRecipe(Recipe recipe) async {
    var db = await _databaseConnection.setDatabase();
    recipe.id = await db.insert('recipes', recipe.toMap());
    return recipe;
  }

  @override
  Future<void> deleteRecipe(int id) async {
    var db = await _databaseConnection.setDatabase();
    await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Recipe>> getRecipes() async {
    var db = await _databaseConnection.setDatabase();
    // List<Map<dynamic, dynamic>> maps = await db.query(
    //   'recipes',
    //   columns: ['id', 'name', 'email', 'number'],
    //   orderBy: 'name ASC',
    // );
    List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT id, name, description, ingredients, procedure, time FROM recipes ORDER BY LOWER(name) ASC',
    );
    return List.generate(maps.length, (i) {
      return Recipe.fromMap(maps[i]);
    });
  }

  @override
  Future<Recipe> updateRecipe(Recipe recipe) async {
    var db = await _databaseConnection.setDatabase();
    await db.update('recipes', recipe.toMap(),
        where: 'id = ?', whereArgs: [recipe.id]);
    return recipe;
  }

  @override
  Future<Recipe> getRecipeById(int id) async {
    var db = await _databaseConnection.setDatabase();
    List<Map<String, dynamic>> maps = await db.query(
      'recipes',
      columns: [
        'id',
        'name',
        'description',
        'ingredients',
        'procedure',
        'time'
      ],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Recipe.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }
}
