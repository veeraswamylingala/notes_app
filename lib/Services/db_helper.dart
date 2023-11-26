import 'package:qurinom_learnings/Models/notes_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  static const table = 'my_notes';

// this opens the database (and creates it if it doesn't exist)
  Future<Database> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  //SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $table(id INTEGER PRIMARY KEY,title TEXT NOT NULL,description TEXT NOT NULL,datetime TEXT NOT NULL)',
    );
  }

  // Inserts a row in the database
  Future<int> insert(Map<String, dynamic> row) async {
    final Database db = await init();
    return await db.insert(table, row);
  }

  // Inserts a row in the database
  Future<int> update({required NotesModel notes, required int? id}) async {
    final Database db = await init();
    return await db.update(table, notes.mapTransaction(),
        where: 'id = ?', whereArgs: [id]);
  }

  // get all rows
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final Database db = await init();
    return await db.query(table);
  }

  //delete single record
  Future<int> deleteRecord({required NotesModel notes}) async {
    final Database db = await init();
    return await db.delete(table, where: 'id = ?', whereArgs: [notes.id]);
  }
}
