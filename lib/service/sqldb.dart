import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
    }
    return _db;
  }

  Future<Database> intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'first.db');
    Database mydb = await openDatabase(
      path,
      onCreate: (db, int version) async {
        await db.execute('''
        CREATE TABLE "users" (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          "Task" TEXT NOT NULL,
          "description" TEXT NOT NULL
        )
        ''');
      },
      version: 1,
    );
    return mydb;
  }

  Future<List<Map<String, dynamic>>> readData(String sql, List<String> list) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.rawQuery(sql);
    return response;
  }

  Future<int> insertData(String sql, List<dynamic> arguments) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql, arguments);
    return response;
  }
}

