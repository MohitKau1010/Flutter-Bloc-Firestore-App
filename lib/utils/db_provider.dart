import 'package:fluttersmallproject/entities/user.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider{
  /// Create a singleton
  /// access anywhere in app...
  DBProvider._();

  static final DBProvider dbProvider = new DBProvider._internal();

  factory DBProvider() {
    return dbProvider;
  }

  DBProvider._internal();

  /// Database <--- is for DatabaseExecutor getting data from it
  Database db;

  Future<Database> get database async {
    if (db != null) return db;
    db = await initDB();
    return db;
  }

  /// sqlite DB
  ///
  /// Get the location of our app directory. This is where files for our app,
  /// and only our app, are stored. Files in this directory are deleted
  /// when the app is deleted.
  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory(); /// getting cache path
    String path = join(documentDirectory.path, 'default.db'); /// join cache path and db name
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {

      /// create database
          /// User is model that is used for store the value.

          await db.execute(
              "CREATE TABLE ${User.tableName} ("
                  "${User.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,"
                  "${User.columnEmailName} TEXT,"
                  "${User.columnTokenName} TEXT)");
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
//      TODO: execute migration script
        },
        onDowngrade: (Database db, int oldVersion, int newVersion) async {
//      TODO: execute migration script
        });
  }

  /// close db after uses..
  Future close() async => db.close();

}