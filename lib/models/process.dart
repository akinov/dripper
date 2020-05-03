import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String columnId = 'id';
final String columnRecipeId = 'recipe_id';
final String columnType = 'type';
final String columnDuration = 'duration';
final String columnWater = 'water';

enum ProcessType { Bloom, Wait, Pour, Stir, Other }

class Process {
  int id;
  int recipeId;
  int type = 0;
  int duration;
  int water;

  String get typeText {
    return ProcessType.values[type].toString().split('.')[1];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnRecipeId: recipeId,
      columnType: type,
      columnDuration: duration,
      columnWater: water,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Process();

  Process.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    recipeId = map[columnRecipeId];
    type = map[columnType];
    duration = map[columnDuration];
    water = map[columnWater];
  }
}

class ProcessProvider {
  static Database _db;
  static String _tableName = 'todo2';

  Process fromMap(Map<String, dynamic> map) {
    return Process.fromMap(map);
  }

  Future<Process> save(Process process) async {
    Database dbClient = await db;
    if (process.id == null) {
      process.id = await dbClient.insert(_tableName, process.toMap());
    } else {
      await dbClient.update(_tableName, process.toMap(),
          where: 'id = ?', whereArgs: [process.id]);
    }

    return process;
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
  $columnRecipeId integer not null,
  $columnType integer not null,
  $columnDuration integer not null,
  $columnWater integer)
''');
  }

  Future<Process> find(int id) async {
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

  Future<List<Process>> recipedBy(int recipeId) async {
    Database dbClient = await db;
    List<Map> result = await dbClient
        .query(_tableName, where: '$columnRecipeId = ?', whereArgs: [recipeId]);
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
