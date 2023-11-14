import 'package:fernandez_recipe_app/src/model/recipe.dart';
import 'package:fernandez_recipe_app/src/screens/recipes_screen.dart';
import 'package:fernandez_recipe_app/src/services/recipe_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecipeScreen extends StatefulWidget {
  final int? recipeId;

  const RecipeScreen({
    required this.recipeId,
    Key? key,
  }) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _procedureController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final _recipeService = RecipeService();

  Recipe _recipe = Recipe();

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    var recipe = await _recipeService.getRecipeById(widget.recipeId!);
    setState(() {
      _recipe = recipe;
    });
  }

  Future<void> _updateRecipe(Recipe recipe) async {
    try {
      await _recipeService.updateRecipe(recipe);
      // Show a toast notification indicating successful recipe update
      Fluttertoast.showToast(
        msg: 'Recipe ${recipe.name} updated successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.lightBlue[50],
        textColor: Colors.black,
        fontSize: 16.0,
      );
    } catch (e) {
      // Handle errors, such as showing an error message to the user
      print('Error updating recipe: $e');
      // Show an error toast notification
      Fluttertoast.showToast(
        msg: 'Error updating recipe: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _ingredientsController.clear();
    _procedureController.clear();
    _timeController.clear();
  }

  void _openUpdateFormDialog(BuildContext context, Recipe recipe) {
    _nameController.text = recipe.name ?? '';
    _descriptionController.text = recipe.description ?? '';
    _ingredientsController.text = recipe.ingredients ?? '';
    _procedureController.text = recipe.procedure ?? '';
    _timeController.text = recipe.time ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Center(
                child: Text(
              'Update ${_recipe.name ?? ''}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 20,
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 20,
                  controller: _ingredientsController,
                  decoration: const InputDecoration(labelText: 'Ingredients'),
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 20,
                  controller: _procedureController,
                  decoration: const InputDecoration(labelText: 'Procedure'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Update'),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  // Create a new recipe object with updated values
                  Recipe updatedRecipe = Recipe(
                    id: recipe.id,
                    name: _nameController.text,
                    description: _descriptionController.text,
                    ingredients: _ingredientsController.text,
                    procedure: _procedureController.text,
                    time: _timeController.text,
                  );
                  _updateRecipe(updatedRecipe);
                  _loadRecipe();
                  _clearForm();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  _clearForm();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteRecipeById(int id) async {
    try {
      await _recipeService.deleteRecipe(id);
      Fluttertoast.showToast(
        msg: 'Recipe ${_recipe.name} deleted successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.lightBlue[50],
        textColor: Colors.black,
        fontSize: 16.0,
      );
    } catch (e) {
      print('Error deleting recipe: $e');

      Fluttertoast.showToast(
        msg: 'Error deleting recipe: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RecipesScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _openUpdateFormDialog(context, _recipe);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              _deleteRecipeById(_recipe.id!);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RecipesScreen()),
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
        title: Center(
          child: Text(
            _recipe.name ?? '',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[50],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(
                        10.0), // Optional: Adjust the padding as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description:',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          _recipe.description ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ingredients:',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          _recipe.ingredients ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[50],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Procedure:',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          _recipe.procedure ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(
                        10.0), // Optional: Adjust the padding as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Time:',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          _recipe.time ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
