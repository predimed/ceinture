import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database _db;

  static Future<Database> get database async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  static initDb() async {
    //io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, "qrludo_db.db");
    var theDb = await openDatabase(path,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return theDb;
  }

  static void _onCreate(Database db, int version) async {
    try {
      await db.execute("CREATE TABLE IF NOT EXISTS TESTDB("
          "id INTEGER PRIMARY KEY,"
          " firstDataUpdate INTEGER,"
          " loginRequired INTEGER,"
          " serverPortHL7 INTEGER,"
          " deviceEnabled INTEGER,"
          " patientOperationDateEnabled INTEGER,"
          " patientGlobalIndicatorEnabled INTEGER,"
          " lastDataUpdate INTEGER,"
          " devideMode INTEGER,"
          " deviceEcareTag TEXT,"
          " aboutText TEXT,"
          " projectName TEXT,"
          " projectText TEXT,"
          " patientStatusEnabled INTEGER"
          ")");
    } catch (error) {}
  }

  static void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {} catch (error) {}
  }
}
