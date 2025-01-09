import 'package:flutter/material.dart';
import 'package:mutabaah_yaumiyah/model/item_model.dart';
import 'package:mutabaah_yaumiyah/services/sqlite_services.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final SqliteServices _services;

  LocalDatabaseProvider(this._services);

  String _message = "";
  String get message => _message;

  List<Item>? _itemList;
  List<Item>? get itemList => _itemList;

  Item? _item;
  Item? get item => _item;

  //fungsi untuk menyimpan data item
  Future<void> saveItemValue(Item value) async {
    try {
      final result = await _services.insertItem(value);
      final isError = result == 0;

      if (isError) {
        _message = "Failed to Save your data";
        notifyListeners();
      } else {
        _message = "Your data is saved";
        notifyListeners();
      }
    } catch (e) {
      _message = "Failed to save your data";
      notifyListeners();
    }
  }

  Future<void> loadAllItemValue() async {
    try {
      _itemList = await _services.getAllItem();
      _message = "All of your data is loaded";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load your data";
      notifyListeners();
    }
  }

  //get by id
  Future<void> loadItemByid(int id) async {
    try {
      _item = await _services.getItemById(id);
      _message = "Your data is loaded";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load data";
      notifyListeners();
    }
  }

  //update data
  Future<void> updateItemById(int id, Item value) async {
    try {
      final result = await _services.updateItem(id, value);
      final isEmptyRowUpdated = result == 0;

      if (isEmptyRowUpdated) {
        _message = "Failed to Update data";
        notifyListeners();
      } else {
        _message = "Your data us updated";
        notifyListeners();
      }
    } catch (e) {
      _message = "Failed to update your data";
      notifyListeners();
    }
  }

  //delete data by id
  Future<void> deleteValueById(int id) async {
    try {
      await _services.removeItem(id);

      _message = "your data has removed";
      notifyListeners();
    } catch (e) {
      _message = "Failed to remove your data";
      notifyListeners();
    }
  }
}
