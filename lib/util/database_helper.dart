import 'dart:async';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;
  final String tableUser = "userTable";
  final String columnId = "id";
  final String columnUsername = "username";
  final String columnPassword = "password";

  Future<Database?> get db async {
    // ignore: unnecessary_null_comparison
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(
        documentDirectory.path, "maindb.db"); //home://Directory/files/maindb.db
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  /*
      id | username | password
      ------------------------
      1  | Pradip   | 123
      2  | Rajni    | 456

  */
  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableUser($columnId INTEGER PRIMARY KEY, $columnUsername  TEXT, $columnPassword TEXT)");
  }

  //CRUD - CREATE, READ, UPDATE, DELETE:

  //Insertion:
  Future<int> saveUser(User user) async {
    var dbClient = await db;
    Future<int> res = dbClient!.insert(tableUser, user.toMap());
    return res;
  }

  //Get Users:
  Future<List> getAllUsers() async {
    var dbClient = await db;
    var result = await dbClient!.rawQuery("SELECT * FROM $tableUser");
    return result.toList();
  }

  //Count number of User:
  Future<int?> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient!.rawQuery("SELECT COUNT(*) from $tableUser"));
  }

  //Get Single User:
  Future<User?> getUser(int id) async {
    var dbClient = await db;
    var result = await dbClient!
        .rawQuery("SELECT * FROM $tableUser WHERE $columnId = $id");
    // ignore: unrelated_type_equality_checks
    if (result == 0) {
      return null;
    }
    return User.fromMap(result.first);
  }

  //Delete User:
  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient!
        .delete(tableUser, where: "$columnId = ?", whereArgs: [id]);
  }

  //Update User:
  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient!.update(tableUser, user.toMap(),
        where: "$columnId=?", whereArgs: [user.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient!.close();
  }
}
