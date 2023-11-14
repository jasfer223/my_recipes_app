class Recipe {
  int? id;
  String? name;
  String? description;
  String? ingredients;
  String? procedure;
  String? time;

  Recipe({
    this.id,
    this.name,
    this.description,
    this.ingredients,
    this.procedure,
    this.time,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'procedure': procedure,
      'time': time,
    };
    return map;
  }

  factory Recipe.fromMap(Map<dynamic, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      ingredients: map['ingredients'],
      procedure: map['procedure'],
      time: map['time'],
    );
  }
}
