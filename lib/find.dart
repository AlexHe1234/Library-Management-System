import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_app_state.dart';

class FindPage extends StatefulWidget {
  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  String bookName = '';
  String author = '';
  String type = '';
  String publisher = '';
  String yearRange = '';
  String priceRange = '';
  int recordNum = 0;
  List records = [];
  var page = Expanded(child: SizedBox());

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
                DataColumn(label: Text('Index')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Author')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Publisher')),
                DataColumn(label: Text('Year')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Stock')),
                DataColumn(label: Text('Total')),
              ],
              rows: [
                for (var i = 0; i < recordNum; i++)
                  DataRow(
                    cells: [
                      DataCell(Text(records[i]['bookno'].toString())),
                      DataCell(Text(records[i]['bookname'])),
                      DataCell(Text(records[i]['author'])),
                      DataCell(Text(records[i]['category'])),
                      DataCell(Text(records[i]['publisher'])),
                      DataCell(Text(records[i]['publishYear'].toString())),
                      DataCell(Text(records[i]['price'].toString())),
                      DataCell(Text(records[i]['remain'].toString())),
                      DataCell(Text(records[i]['total'].toString())),
                    ]
                  )
              ],
              clipBehavior: Clip.none,
            ),
          ),
        );
      });
    }
  }

  List<Object> preproc() {
    var yearStart = -1;
    var yearEnd = -1;
    var priceStart = -1.0;
    var priceEnd = -1.0;
    if (yearRange.contains('-')) {
      List<String> year = yearRange.split('-');
      String yearFirst = year[0];
      String yearSecond = year[1];
      try {
        yearStart = int.parse(yearFirst);
        yearEnd = int.parse(yearSecond);
      } catch (e) {};
      if (yearStart < 1000 || yearStart > 9999) {
        yearStart = -1;
        yearEnd = -1;
      }
      if (yearEnd < 1000 || yearEnd > 9999) {
        yearStart = -1;
        yearEnd = -1;
      }
    }
    if (priceRange.contains('-')) {
      List<String> price = priceRange.split('-');
      String priceFirst = price[0];
      String priceSecond = price[1];
      try {
        priceStart = double.parse(priceFirst);
        priceEnd = double.parse(priceSecond);
      } catch (e) {};
      if (priceStart < 0.0 || priceEnd < 0.0) {
        priceStart = -1.0;
        priceEnd = -1.0;
      }
    }
    return [bookName, author, type, publisher, yearStart, yearEnd, priceStart, priceEnd];
  }

  void updateRecords(var appState) {
    var raw = preproc();
    Future<List> resultFuture = appState.sqlConnection.findBook(raw);
    resultFuture.then((result) {
      setState(() {
        records = result;
        recordNum = result.length;
      });
      setPage(result.isEmpty, appState);
    });
  }

  final controllerBookName = TextEditingController();
  final controllerAuthor = TextEditingController();
  final controllerType = TextEditingController();
  final controllerPublisher = TextEditingController();
  final controllerYear = TextEditingController();
  final controllerPrice = TextEditingController();
  void clearText(var appState) {
    controllerBookName.clear();
    controllerAuthor.clear();
    controllerType.clear();
    controllerPublisher.clear();
    controllerYear.clear();
    controllerPrice.clear();
    bookName = '';
    author = '';
    type = '';
    publisher = '';
    yearRange = '';
    priceRange = '';
    updateRecords(appState);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    if (appState.findPageInit) {
      updateRecords(appState);
      appState.findPageInit = false;
    }

    String displayText;
    if (recordNum == 0) {
      displayText = 'There is no relevant record.';
    } else if (recordNum == 1) {
      displayText = 'There is 1 record:';
    } else if (recordNum > 1) {
      displayText = 'There are $recordNum records:';
    } else {
      throw UnimplementedError();
    }
    // final style = Theme.of(context).textTheme.bodyLarge!.copyWith(
    //   color: Color.fromARGB(255, 255, 255, 255),
    // );
    final textBoxColor = Color.fromARGB(255, 206, 191, 163);
    // final textBoxColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
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
              backgroundColor: Color.fromARGB(218, 134, 118, 46),
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
                    controller: controllerBookName,
                    decoration: InputDecoration(
                      labelText: 'Book Name (Jane Eyre)',
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
                        bookName = value;
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
                    controller: controllerAuthor,
                    decoration: InputDecoration(
                      labelText: 'Author (J. K. Rowling)',
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
                        author = value;
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
                    controller: controllerType,
                    decoration: InputDecoration(
                      labelText: 'Category (Comics)',
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
                        type = value;
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
                    controller: controllerPublisher,
                    decoration: InputDecoration(
                      labelText: 'Publisher (Longman)',
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
                        publisher = value;
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
                    controller: controllerYear,
                    decoration: InputDecoration(
                      labelText: 'Year (2010-2020)',
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
                        yearRange = value;
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
                    controller: controllerPrice,
                    decoration: InputDecoration(
                      labelText: 'Price (12.1-49.25)',
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
                        priceRange = value;
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
      ),
      backgroundColor: Color.fromARGB(0, 196, 178, 153),
    );
  }
}