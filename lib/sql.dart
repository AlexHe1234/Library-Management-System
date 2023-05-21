// ignore: depend_on_referenced_packages
import 'package:mysql_utils/mysql_utils.dart';

class SQL {
  // ignore: prefer_typing_uninitialized_variables
  var db;

  SQL() {
    db = MysqlUtils(
      settings: {
        'host': '127.0.0.1',
        'port': 3306,
        'user': 'root',
        'password': '1234',
        'db': 'library',
        'maxConnections': 10,
        'secure': true,
        'prefix': '',
        'pool': true,
        'collation': 'utf8mb4_general_ci',
      },
    );
  }

  // test connection
  Future<bool> testConnection() async {
    try {
      await db.getOne(
        table: 'books',
        fields: '*',
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // query book
  Future<List> findBook(List raw) async {
    String bookName = raw[0];
    String author = raw[1];
    String type = raw[2];
    String publisher = raw[3];
    int yearStart = raw[4];
    int yearEnd = raw[5];
    double priceStart = raw[6];
    double priceEnd = raw[7];

    String whereString = '';
    if (bookName.isNotEmpty) {
      whereString += ' bookname=\'$bookName\'';
    }
    if (author.isNotEmpty) {
      if (whereString.isEmpty) {
        whereString += ' author=\'$author\'';
      } else {
        whereString += ' and author=\'$author\'';
      }
    }
    if (type.isNotEmpty) {
      if (whereString.isEmpty) {
        whereString += ' category=\'$type\'';
      } else {
        whereString += ' and category=\'$type\'';
      }
    }
    if (publisher.isNotEmpty) {
      if (whereString.isEmpty) {
        whereString += ' publisher=\'$publisher\'';
      } else {
        whereString += ' and publisher=\'$publisher\'';
      }
    }
    if (yearStart > 0 && yearEnd > 0) {
      if (whereString.isEmpty) {
        whereString += ' publishyear>=$yearStart and publishyear<=$yearEnd';
      } else {
        whereString += ' and publishyear>=$yearStart and publishyear<=$yearEnd';
      }
    }
    if (priceStart >= 0 && priceEnd >= 0) {
      if (whereString.isEmpty) {
        whereString += ' price>=$priceStart and price<=$priceEnd';
      } else {
        whereString += ' and price>=$priceStart and price<=$priceEnd';
      }
    }
    // print(whereString);
    var result = await db.getAll(
      table: 'books',
      fields: '*',
      where: whereString,
    );
    return result;
  }

  bool isInt(var a) {
    try {
      int.parse(a);
      return true;
    } catch (e) {
      return false;
    }
  }

  // find a borrow record
  Future<List> findBorrow(List raw) async {
    String borrowId = raw[0];
    String cardId = raw[1];
    String bookId = raw[2];
    String borrowTime = raw[3];

    String whereString = '';
    if (borrowId.isNotEmpty) {
      if (isInt(borrowId)) {
        whereString += ' borrowno = $borrowId ';
      } else {
        whereString += ' borrowno = -1 ';
      }
    }
    if (cardId.isNotEmpty) {
      if (whereString.isEmpty) {
        if (isInt(cardId)) {
          whereString += ' cardid = $cardId ';
        } else {
          whereString += ' cardid = -1 ';
        }
      } else {
        if (isInt(cardId)) {
          whereString += ' and cardid = $cardId ';
        } else {
          whereString += ' and cardid = -1 ';
        }
      }
    }
    if (bookId.isNotEmpty) {
      if (whereString.isEmpty) {
        if (isInt(bookId)) {
          whereString += ' bookid = $bookId ';
        } else {
          whereString += ' bookid = -1 ';
        }
      } else {
        if (isInt(bookId)) {
          whereString += ' and bookid = $bookId ';
        } else {
          whereString += ' and bookid = -1 ';
        }
      }
    }
    if (borrowTime.length == 8) {
      if (whereString.isNotEmpty) {
        whereString += ' and ';
      }
      if (isInt(borrowTime)) {
        whereString += ' borrowtime >= \'${borrowTime}000000\' ';
        whereString += ' and borrowtime <= \'${borrowTime}235959\' ';
      } else {
        whereString += ' borrowtime = \'xxxxxxxxxxxxxx\' ';
      }
    } else if (borrowTime.isNotEmpty) {
      if (whereString.isNotEmpty) {
        whereString += ' and ';
      }
      whereString += ' borrowtime = \'xxxxxxxxxxxxxx\' ';
    }

    var res = await db.getAll(
      table: 'borrow',
      fields: '*',
      where: whereString,
    );

    return res;
  }

  Future<int> returnBook(String bookId, String borrowId) async {
    DateTime now = DateTime.now();
    String dateString = now.year.toString().padLeft(4, '0');
    dateString += now.month.toString().padLeft(2, '0');
    dateString += now.day.toString().padLeft(2, '0');
    dateString += now.hour.toString().padLeft(2, '0');
    dateString += now.minute.toString().padLeft(2, '0');
    dateString += now.second.toString().padLeft(2, '0');
    await db.update(
      table: 'borrow',
      updateData: {
        'returntime': dateString,
      },
      where: {
        'borrowno': borrowId,
      },
    );
    var findStockRet = await db.getAll(
      table: 'books',
      fields: 'remain',
      where: {
        'bookno': bookId,
      },
    );
    int stock = findStockRet[0]['remain'];
    await db.update(
      table: 'books',
      updateData: {
        'remain': stock + 1,
      },
      where: {
        'bookno': bookId,
      }
    );
    return 1;
  }

  // add a card
  // type = 1 for teacher and 2 for student
  Future<List> register(String name, String dep, String type) async {
    await db.insert(
      table: 'cards',
      insertData: {
        'name': name,
        'department': dep,
        'cardtype': type,
      },
    );
    var result = await db.getAll(
      table: 'cards',
      fields: 'cardid',
      where: 'name = \'$name\' and department = \'$dep\' and cardtype = \'$type\'',
    );
    return result;
  }

  // add a book record
  Future<List> add(String bookName, String author, String category, String publisher, 
    int year, double price, int total, int remain) async {
      await db.insert(
        table: 'books',
        insertData: {
          'bookname': bookName,
          'author': author,
          'category': category,
          'publisher': publisher,
          'publishYear': year,
          'price': price,
          'total': total,
          'remain': remain,
        }
      );
      var whereString = 'bookname = \'$bookName\'';
      whereString += ' and author = \'$author\'';
      whereString += ' and category = \'$category\'';
      whereString += ' and publisher = \'$publisher\'';
      whereString += ' and publishYear = \'$year\'';
      var result = await db.getAll(
        table: 'books',
        fields: 'bookno',
        where: whereString,
      );
      return result;
  }

  // check constrains
  Future<bool> checkBorrow(String bookId, String cardId) async {
    bool validBook = false;
    bool validCard = false;
    var bookRes = await db.getAll(
      table: 'books',
      fields: '*',
      where: 'bookno=$bookId and remain>0',
    );
    if (bookRes.length > 0) {
      validBook = true;
    } else {
      validBook = false;
    }
    var cardRes = await db.getAll(
      table: 'cards',
      fields: '*',
      where: 'cardid=$cardId',
    );
    if (cardRes.length > 0) {
      validCard = true;
    } else {
      validCard = false;
    }
    bool ret = true;
    if (!validBook) {
      ret = false;
    }
    if (!validCard) {
      ret = false;
    }
    return ret;
  }

  // add borrow record and reduce stock
  Future<Object> addBorrow(String bookId, String cardId) async {
    var booksOld = await db.getOne(
      table: 'books',
      fields: 'remain',
      where: {
        'bookno': bookId,
      },
    );
    int stockOld = booksOld['remain'];
    await db.update(
      table: 'books',
      updateData:{
        'remain': stockOld - 1,
      },
      where:{
        'bookno': bookId,
      }
    );
    DateTime now = DateTime.now();
    String dateString = now.year.toString().padLeft(4, '0');
    dateString += now.month.toString().padLeft(2, '0');
    dateString += now.day.toString().padLeft(2, '0');
    dateString += now.hour.toString().padLeft(2, '0');
    dateString += now.minute.toString().padLeft(2, '0');
    dateString += now.second.toString().padLeft(2, '0');
    String returnString = 'yyyymmddhhmmss';
    await db.insert(
      table: 'borrow',
      insertData: {
        'cardid': cardId,
        'bookid': bookId,
        'borrowtime': dateString,
        'returntime': returnString,
      }
    );
    var maxIdRecord = await db.getOne(
      table: 'borrow',
      fields: 'max(borrowno)',
      where: {
        'cardid': cardId,
        'bookid': bookId,
      },
    );
    var maxId = maxIdRecord['max(borrowno)'];
    var ret = await db.getOne(
      table: 'borrow',
      fields: 'borrowno',
      where: {
        'cardid': cardId,
        'bookid': bookId,
        'borrowno': maxId,
      },
    );
    return ret;
  } 
}
