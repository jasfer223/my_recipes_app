import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'myrecipeapp_db');
    var database = await openDatabase(
      path,
      version: 1, // Increment the version when you make changes to the schema
      onCreate: _onCreatingDatabase,
    );
    return database;
  }

  Future<void> _onCreatingDatabase(Database db, int version) async {
    await db.execute(
        "CREATE TABLE recipes(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, ingredients TEXT, procedure TEXT, time TEXT)");
  }
}
