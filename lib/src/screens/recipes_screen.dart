import 'package:fernandez_recipe_app/src/model/recipe.dart';
import 'package:fernandez_recipe_app/src/screens/recipe_screen.dart';
import 'package:fernandez_recipe_app/src/services/recipe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _procedureController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final _recipeService = RecipeService();

  List<Color?> cardColors = [
    Colors.lightBlue[50],
    Colors.orange[50],
    Colors.lightGreen[50],
    Colors.purple[50],
  ];

  List<Recipe> _recipes = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _sortRecipes();
  }

  Future<void> _loadRecipes() async {
    var recipes = await _recipeService.getAllRecipes();
    setState(() {
      _recipes = recipes;
    });
  }

  Future<void> _sortRecipes() async {
    var recipes = await _recipeService.getAllRecipes();
    // recipeRs.sort((a, b) => a.name!.compareTo(b.name!));
    setState(() {
      _recipes = recipes;
    });
  }

  Future<void> _saveRecipe() async {
    Recipe newRecipe = Recipe(
      name: _nameController.text,
      description: _descriptionController.text,
      ingredients: _ingredientsController.text,
      procedure: _procedureController.text,
      time: _timeController.text,
    );

    try {
      await _recipeService.saveRecipe(newRecipe);
      _loadRecipes();

      Fluttertoast.showToast(
        msg: 'Recipe ${newRecipe.name} created successfully',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.lightBlue[50],
        textColor: Colors.black,
        fontSize: 12.0,
      );
      _clearForm();
    } catch (e) {
      print('Error creating recipe: $e');
      Fluttertoast.showToast(
        msg: 'Error creating recipe: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
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

  void _openFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Center(
                child: Text(
              'Add New Recipes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                child: const Text('Save'),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  _saveRecipe();
                  _clearForm();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'My Recipes',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search saved recipes...',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                Recipe recipe = _recipes[index];

                if (_searchQuery.isEmpty ||
                    recipe.name!
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ||
                    recipe.description!
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase())) {
                  return Card(
                    color: cardColors[index % cardColors.length],
                    child: ListTile(
                      onTap: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeScreen(recipeId: recipe.id),
                          ),
                        );
                        print('tapped');
                      },
                      leading: const Icon(Icons.dining),
                      title: Text(recipe.name ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(recipe.description ?? ''),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openFormDialog(context);
        },
        tooltip: 'Add New Recipes Form',
        child: const Icon(Icons.add),
      ),
    );
  }
}
