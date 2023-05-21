import 'package:flutter/material.dart';
import 'sql.dart';

class MyAppState extends ChangeNotifier {
  var version = 'Library Management System 0.0.0';
  var sqlStatus = false;
  void setSqlStatus(bool status) {
    sqlStatus = status;
    notifyListeners();
  }
  String registerId = '';
  void setRegisterId(int id, String name, String dep, String type) {
    registerId = 'SUCCESS: Added Card ID ${id.toString()} for $type: $name at $dep dep.';
    notifyListeners();
  }
  String addId = '';
  void setAddId(int id, String bookName) {
    addId = 'SUCCESS: Added Book ID ${id.toString()} for Book \'$bookName\'';
    notifyListeners();
  }
  String borrowId = '';
  void setBorrowId(int id, String cardId, String bookId) {
    borrowId = 'SUCCESS: Borrow ID $id for Card $cardId with Book $bookId';
    notifyListeners();
  }
  var sqlConnection = SQL();
  bool firstCheck = true;

  bool findPageInit = true;
  bool returnPageInit = true;

  String helpString = '';
}