import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String columnId = 'id';
final String columnRecipeId = 'recipe_id';
final String columnType = 'type';
final String columnDuration = 'duration';
final String columnWater = 'water';
final String columnStep = 'step';
final String columnNote = 'note';

enum ProcessType { Bloom, Wait, Pour, Stir, Other }

class Process {
  int id;
  int recipeId;
  int type = 0;
  int duration;
  int water;
  int step = 1;
  String note = '';
  int inSeconds;
  int totalWater;

  String get typeText {
    return ProcessType.values[type].toString().split('.')[1];
  }

  String get titleForList {
    List<String> result = ['Duration ' + duration.toString() + 's'];
    if (type != 1) {
      result.add('Water ' + water.toString() + 'ml');
    }
    return result.join(', ');
  }

  String get textForTimer {
    switch (ProcessType.values[type]) {
      case ProcessType.Bloom:
        return 'Pour ${water.toString()}g of water ${duration.toString()} seconds and wait to bloom';
      case ProcessType.Wait:
        return 'Wait for ${duration.toString()} seconds';
      case ProcessType.Pour:
        return 'Pour ${water.toString()}g of water ${duration.toString()} seconds';
      case ProcessType.Stir:
        return 'Stir for ${duration.toString()} seconds';
      case ProcessType.Other:
        return '${duration.toString()} seconds $note';
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnRecipeId: recipeId,
      columnType: type,
      columnDuration: duration,
      columnWater: water,
      columnStep: step,
      columnNote: note,
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
    step = map[columnStep];
    note = map[columnNote];
  }
}

class ProcessProvider {
  static Database _db;
  static String _tableName = 'todo3';

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

  Future onCreate(Database db, int version) async {
    await db.execute('''
create table $_tableName ( 
  $columnId integer primary key autoincrement, 
  $columnRecipeId integer not null,
  $columnType integer not null,
  $columnDuration integer not null,
  $columnStep integer not null,
  $columnNote text not null,
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
    List<Map> result = await dbClient.query(_tableName,
        where: '$columnRecipeId = ?',
        whereArgs: [recipeId],
        orderBy: columnStep);
    return List.generate(result.length, (index) => fromMap(result[index]));
  }

  Future close() async {
    Database dbClient = await db;
    _db = null;
    return await dbClient.close();
  }

  Future reCreateTable() async {
    Database dbClient = await db;
    await dbClient.execute('DROP TABLE IF EXISTS $_tableName');
    await onCreate(dbClient, 1);
  }
}
