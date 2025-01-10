import 'dart:io';

import 'package:mutabaah_yaumiyah/model/item_model.dart';
import 'package:sqflite/sqflite.dart' as mobile;
import 'package:sqlite3/sqlite3.dart' as windows;

class SqliteServices {
  static const String _databaseName = 'itemlist.db';
  static const String _tableName = 'item_table';
  static const int _version = 1;

  mobile.Database? _mobileDb;
  windows.Database? _windowsDb;

  Future<void> createTables(mobile.Database database) async {
    await database.execute(
      """
        CREATE TABLE $_tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          item_name TEXT NULL,
          description TEXT NULL,
          status TEXT NULL,
          is_deleted INTEGER NULL,
          inserted_at TEXT NULL,
          updated_at TEXT NULL    
        )
      """,
    );
  }

  void createTablesWindows(windows.Database database) {
    database.execute(
      """
        CREATE TABLE IF NOT EXISTS $_tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          item_name TEXT NULL,
          description TEXT NULL,
          status TEXT NULL,
          is_deleted INTEGER NULL,
          inserted_at TEXT NULL,
          updated_at TEXT NULL    
        )
      """,
    );
  }

  String _getDatabasePath() {
    final directory = Directory.current.path;
    return '$directory/$_databaseName';
  }

  windows.Database _initializeDbWindows() {
    final dbPath = _getDatabasePath();
    final dbFile = File(dbPath);

    final database = windows.sqlite3.open(dbFile.path);

    //create table
    createTablesWindows(database);
    return database;
  }

  Future<mobile.Database> _initializeDb() async {
    return mobile.openDatabase(
      _databaseName,
      version: _version,
      onCreate: (mobile.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<int> insertItem(Item item) async {
    var id = 0;
    if (Platform.isAndroid) {
      final db = await _initializeDb();
      id = await db.rawInsert(
          "INSERT INTO $_tableName(item_name, description, status, is_deleted, inserted_at) VALUES(?,?,?,?,?)",
          [
            item.item_name,
            item.description,
            item.status,
            item.is_deleted,
            item.inserted_at,
          ]);
    } else if (Platform.isWindows) {
      final dbWindows = _initializeDbWindows();
      final statement = dbWindows.prepare(
          "INSERT INTO $_tableName (item_name, description, status, is_deleted, inserted_at) values (?,?,?,?,?)");
      statement.execute([
        item.item_name,
        item.description,
        item.status,
        item.is_deleted,
        item.inserted_at,
      ]);
      statement.dispose();
      id = 1;
    }
    return id;
  }

  //GET all Item
  Future<List<Item>> getAllItem() async {
    if (Platform.isAndroid) {
      final db = await _initializeDb();
      final results = await db.query(_tableName, orderBy: "id");

      return results.map((result) => Item.fromJson(result)).toList();
    } else if (Platform.isWindows) {
      final dbWindows = _initializeDbWindows();
      final resultsWindows = dbWindows.select("SELECT * FROM $_tableName");
      return resultsWindows.map((row) => Item.fromJson(row)).toList();
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  //get by id
  Future<Item> getItemById(int id) async {
    if (Platform.isAndroid) {
      final db = await _initializeDb();
      final results =
          await db.query(_tableName, where: "id = ?", whereArgs: [id]);

      return results.map((result) => Item.fromJson(result)).first;
    } else if (Platform.isWindows) {
      final dbWindows = _initializeDbWindows();
      final resultWindows =
          dbWindows.select("SELECT * FROM $_tableName WHERE id = ?", [id]);
      if (resultWindows.isNotEmpty) {
        return Item.fromJson(resultWindows.first);
      } else {
        throw Exception("Item not found");
      }
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  //update item berdasarkan id
  Future<int> updateItem(int id, Item item) async {
    if (Platform.isAndroid) {
      final db = await _initializeDb();
      final result = await db.rawUpdate(
          "UPDATE $_tableName SET item_name = ?, description = ?, status = ?, is_deleted = ?, updated_at=? WHERE id = $id",
          [
            item.item_name,
            item.description,
            item.status,
            item.is_deleted,
            item.updated_at
          ]);

      return result;
    } else if (Platform.isWindows) {
      final dbWindows = _initializeDbWindows();
      final statement = dbWindows.prepare(
          "UPDATE $_tableName SET item_name = ?, description = ?, status = ?, is_deleted = ?, updated_at=? WHERE id = $id");
      statement.execute([
        item.item_name,
        item.description,
        item.status,
        item.is_deleted,
        item.updated_at,
      ]);

      statement.dispose();
      return 1;
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  //delete data by id
  Future<int> removeItem(int id) async {
    if (Platform.isAndroid) {
      final db = await _initializeDb();

      final result =
          await db.delete(_tableName, where: "id= ?", whereArgs: [id]);
      return result;
    } else if (Platform.isWindows) {
      final dbWindows = _initializeDbWindows();
      final statement =
          dbWindows.prepare("DELETE FROM $_tableName WHERE id = ?");
      statement.execute([id]);
      statement.dispose();
      return 1;
    } else {
      throw UnsupportedError("Unsupported Platmonth");
    }
  }

  Future<void> closeDb() async {
    if (_mobileDb != null) {
      await _mobileDb!.close();
      _mobileDb = null;
    }
    if (_windowsDb != null) {
      _windowsDb!.dispose();
      _windowsDb = null;
    }
  }
}
