import 'package:flutter/material.dart';
import 'package:library_database/my_app_state.dart';
import 'package:provider/provider.dart';

class ReturnPage extends StatefulWidget {
  @override
  State<ReturnPage> createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  String borrowId = '';
  String cardId = '';
  String bookId = '';
  String borrowTime = '';  // in format of 20230322
  List records =[];
  int recordNum = 0;
  var page = Expanded(child: SizedBox());

  void returnBook(var appState, int index) {
    String returnBookId = records[index]['bookid'].toString();
    String returnBorrowId = records[index]['borrowno'].toString();
    var res = appState.sqlConnection.returnBook(returnBookId, returnBorrowId);
    res.then((res) {
      updateRecords(appState);
    });
  }

  Widget procReturn(String raw, int recordIdx, var appState) {
    if (isInt(raw)) {
      return Text(
        '  Returned',
        style: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 15,
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          returnBook(appState, recordIdx);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Color.fromARGB(218, 132, 180, 89),
        ),
        child: Text(
          'Return',
          style: TextStyle(
            color: Color.fromARGB(255, 231, 228, 221),
            fontSize: 15,
          ),
        ),
      );
    }
  }

  void setPage(bool isEmpty, var appState) {
    if (isEmpty) {
      setState(() {
        page = Expanded(child: SizedBox());
      });
    } else {
      setState(() {
        page = Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              dividerThickness: 0,
              columns: [
                DataColumn(label: Text('Borrow ID')),
                DataColumn(label: Text('Book ID')),
                DataColumn(label: Text('Card ID')),
                DataColumn(label: Text('Borrow Time')),
                DataColumn(label: Text('Return Info')),
              ],
              rows: [
                for (var i = 0; i < recordNum; i++)
                  DataRow(
                    cells: [
                      DataCell(Text(records[i]['borrowno'].toString())),
                      DataCell(Text(records[i]['bookid'].toString())),
                      DataCell(Text(records[i]['cardid'].toString())),
                      DataCell(Text(procTime(records[i]['borrowtime'].toString()))),
                      DataCell(procReturn(records[i]['returntime'].toString(), i, appState)),
                    ]
                  )
              ],
            ),
          ),
        );
      });
    }
  }

  bool isInt(var a) {
    try {
      int.parse(a);
      return true;
    } catch (e) {
      return false;
    }
  }

  void updateRecords(var appState) {
    var raw = [borrowId, cardId, bookId, borrowTime];
    Future<List> resultFuture = appState.sqlConnection.findBorrow(raw);
    resultFuture.then((res) {
      setState(() {
        records = res;
        recordNum = res.length;
      });
      setPage(res.isEmpty, appState);
    });
    return;
  }

  final controllerBorrowId = TextEditingController();
  final controllerCardId = TextEditingController();
  final controllerBookId = TextEditingController();
  final controllerBorrowTime = TextEditingController();
  void clearText(var appState) {
    controllerBorrowId.clear();
    controllerCardId.clear();
    controllerBookId.clear();
    controllerBorrowTime.clear();
    borrowId = '';
    cardId = '';
    bookId = '';
    borrowTime = '';
    updateRecords(appState);
  }

  String procTime(String raw) {
    String ret = '';
    ret += raw.substring(0, 4);
    ret += '-';
    ret += raw.substring(4, 6);
    ret += '-';
    ret += raw.substring(6, 8);
    ret += ' ';
    ret += raw.substring(8, 10);
    ret += ':';
    ret += raw.substring(10, 12);
    ret += ':';
    ret += raw.substring(12, 14);
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    if (appState.returnPageInit) {
      updateRecords(appState);
      appState.returnPageInit = false;
    }

    String displayText;
    if (recordNum == 0) {
      displayText = 'There is no borrow record.';
    } else if (recordNum == 1) {
      displayText = 'There is 1 borrow record:';
    } else if (recordNum > 1) {
      displayText = 'There are $recordNum borrow records:';
    } else {
      throw UnimplementedError();
    }

    final textBoxColor = Color.fromARGB(255, 206, 191, 163);

    return Scaffold(
      backgroundColor: Color.fromARGB(0, 1, 1, 1),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  displayText,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Color.fromARGB(255, 61, 61, 61),
                  ),
                ),
              ),
            ],
          ),
          page,
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              clearText(appState);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Color.fromARGB(218, 132, 180, 89),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Clear All Boxes',
                style: TextStyle(
                  color: Color.fromARGB(255, 231, 228, 221),
                  fontSize: 17,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Flexible(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: controllerBorrowId,
                    decoration: InputDecoration(
                      labelText: 'Borrow ID',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: textBoxColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15)
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        borrowId = value;
                        updateRecords(appState);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 20),
              Flexible(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: controllerCardId,
                    decoration: InputDecoration(
                      labelText: 'Card ID',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: textBoxColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15)
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        cardId = value;
                        updateRecords(appState);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Flexible(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: controllerBookId,
                    decoration: InputDecoration(
                      labelText: 'Book ID',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: textBoxColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15)
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        bookId = value;
                        updateRecords(appState);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 20),
              Flexible(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: controllerBorrowTime,
                    decoration: InputDecoration(
                      labelText: 'Borrow Date (20230322)',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: textBoxColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15)
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        borrowTime = value;
                        updateRecords(appState);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 20),
        ],
      )
    );
  }
}
