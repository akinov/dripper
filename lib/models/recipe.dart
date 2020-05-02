import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String columnId = 'id';
final String columnName = 'name';
final String columnCoffee = 'coffee';
final String columnWater = 'water';

class Recipe {
  int id;
  String name;
  int coffee;
  int water;

  String get ratio {
    String ratio = '0.0';
    if (coffee != null && water != null) {
      ratio = (water.toDouble() / coffee).toStringAsFixed(1);
    }
    return '1:$ratio';
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnCoffee: coffee,
      columnWater: water,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Recipe();

  Recipe.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    coffee = map[columnCoffee];
    water = map[columnWater];
  }
}

class RecipeProvider {
  static Database _db;
  static String _tableName = 'todo';

  Recipe fromMap(Map<String, dynamic> map) {
    return Recipe.fromMap(map);
  }

  Future<Recipe> save(Recipe recipe) async {
    Database dbClient = await db;
    if (recipe.id == null) {
      recipe.id = await dbClient.insert(_tableName, recipe.toMap());
    } else {
      await dbClient.update(_tableName, recipe.toMap(),
          where: 'id = ?', whereArgs: [recipe.id]);
    }

    return recipe;
  }

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    var theDb = await openDatabase(join(await getDatabasesPath(), _tableName),
        version: 1, onCreate: onCreate);
    return theDb;
  }

  void onCreate(Database db, int version) async {
    await db.execute('''
create table $_tableName ( 
  $columnId integer primary key autoincrement, 
  $columnName text not null,
  $columnCoffee integer not null,
  $columnWater integer not null)
''');
  }

  Future<Recipe> find(int id) async {
    Database dbClient = await db;
    List<Map> maps =
        await dbClient.query(_tableName, where: 'id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    Database dbClient = await db;
    return await dbClient.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Recipe>> all() async {
    Database dbClient = await db;
    List<Map> result = await dbClient.query(_tableName);
    return List.generate(result.length, (index) => fromMap(result[index]));
  }

  Future close() async {
    Database dbClient = await db;
    return await dbClient.close();
  }

  Future dropTable() async {
    Database dbClient = await db;
    await dbClient.execute('DROP TABLE IF EXISTS $_tableName');
  }
}
