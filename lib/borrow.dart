import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_app_state.dart';
import 'error.dart';

class BorrowSuccessPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Card(
      color: Color.fromARGB(255, 173, 228, 166),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          appState.borrowId,
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}

class BorrowPage extends StatefulWidget {
  @override
  State<BorrowPage> createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  String bookId = '';
  String cardId = '';
  Widget promptPage = SizedBox(height: 45);

  bool isInt(String a) {
    try {
      int.parse(a);
      return true;
    } catch (e) {
      return false;
    }
  }

  void addBorrowRecord(appState) {
    var ret = appState.sqlConnection.addBorrow(bookId, cardId);
    ret.then((value) {
      appState.setBorrowId(value['borrowno'], cardId, bookId);
    });
    setState(() {
      promptPage = BorrowSuccessPrompt();
    });
  }

  void borrow(var appState) {
    if (bookId.isNotEmpty && cardId.isNotEmpty
    && isInt(bookId) && isInt(bookId)) {
      var checkRes = appState.sqlConnection.checkBorrow(bookId, cardId);
      checkRes.then((res) {
        if (res) {
          addBorrowRecord(appState);
        } else {
          setState(() {
            promptPage = ErrorPrompt();
          });
        }
      });
    } else {
      setState(() {
        promptPage = ErrorPrompt();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textBoxColor = Color.fromARGB(255, 211, 201, 183);
    var appState = context.watch<MyAppState>();
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 1, 1, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            promptPage,
            SizedBox(height: 50),
            Text(
              'Borrow',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 20),
            Flexible(
                child: SizedBox(
                  width: 400,
                  height: 40,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Book Index',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 122, 122, 122),
                      ),
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
                      });
                    },
                  ),
                ),
              ),
            SizedBox(height: 10),
            Flexible(
              child: SizedBox(
                width: 400,
                height: 40,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Card ID',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 122, 122, 122),
                    ),
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
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Color.fromARGB(218, 255, 255, 255),
              ),
              onPressed:() {
                borrow(appState);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Submit',
                ),
              ),
            ),
            SizedBox(height: 100),
          ]
        ),
      )
    );
  }
}