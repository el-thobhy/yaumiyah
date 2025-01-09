import 'package:mutabaah_yaumiyah/model/item_model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteServices {
  static const String _databaseName = 'itemlist.db';
  static const String _tableName = 'item_table';
  static const int _version = 1;

  Future<void> createTables(Database database) async {
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

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<int> insertItem(Item item) async {
    final db = await _initializeDb();

    final data = item.toJson();
    final id = await db.insert(_tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  //GET all Item
  Future<List<Item>> getAllItem() async {
    final db = await _initializeDb();
    final results = await db.query(_tableName, orderBy: "id");

    return results.map((result) => Item.fromJson(result)).toList();
  }

  //get by id
  Future<Item> getItemById(int id) async {
    final db = await _initializeDb();
    final results =
        await db.query(_tableName, where: "id = ?", whereArgs: [id]);

    return results.map((result) => Item.fromJson(result)).first;
  }

  //update item berdasarkan id
  Future<int> updateItem(int id, Item item) async {
    final db = await _initializeDb();

    final data = item.toJson();

    final result = await db.rawUpdate(
        "UPDATE $_tableName SET item_name = ?, description = ?, status = ?, is_deleted = ?, inserted_at =?, updated_at=?",
        [
          item.item_name,
          item.description,
          item.status,
          item.is_deleted,
          item.inserted_at,
          item.updated_at
        ]);

    return result;
  }

  //delete data by id
  Future<int> removeItem(int id) async {
    final db = await _initializeDb();

    final result = await db.delete(_tableName, where: "id= ?", whereArgs: [id]);
    return result;
  }
}
