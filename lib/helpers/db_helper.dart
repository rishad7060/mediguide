import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'cashier_pos.db'),
        onCreate: createTable, onOpen: (dbPath) {}, version: 1);
  }

  static Future<void> createTable(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Users (id_local INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, auth TEXT , weight INTEGER, calories INTEGER)');
    await db.execute(
        'CREATE TABLE Medicines(id_local INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, form TEXT NOT NULL, frequency TEXT NOT NULL, date TEXT NOT NUll, time TEXT NOT NUll)');
  }

  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getByWhere(
      String table, String where, List whereArgs) async {
    final db = await DBHelper.database();
    return db.query(table, where: where, whereArgs: whereArgs);
  }

  static Future<int> update(String table, String? where, List? whereArgs,
      Map<String, dynamic> values) async {
    final db = await DBHelper.database();
    return db.update(table, values, where: where, whereArgs: whereArgs);
  }

  static Future<int> delete(String table, String where, List whereArgs) async {
    final db = await DBHelper.database();
    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  static Future<List<Map<String, dynamic>>> customQuery(
      String sql, List<dynamic>? args) async {
    final db = await DBHelper.database();
    return db.rawQuery(sql, args);
  }
}
