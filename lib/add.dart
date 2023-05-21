import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_app_state.dart';
import 'error.dart';

class AddSuccessPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Card(
      color: Color.fromARGB(255, 173, 228, 166),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          appState.addId,
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}

class AddPage extends StatefulWidget {
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  var bookName = '';
  var author = '';
  var category = '';
  var publisher = '';
  String year = '';
  String price = '';
  String total = '';
  String remain = '';
  Widget promptPage = SizedBox(height: 45);

  bool isInt(String a) {
    try {
      int.parse(a);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isDouble(String a) {
    try {
      double.parse(a);
      return true;
    } catch (e) {
      return false;
    }
  }

  void createUser(var appState) {
    if (bookName.isNotEmpty && author.isNotEmpty && category.isNotEmpty && publisher.isNotEmpty
    && isInt(year) && int.parse(year) > 0 
    && isDouble(price) && double.parse(price) >= 0.0
    && isInt(total) && int.parse(total) >= 0 
    && isInt(remain) && int.parse(remain) >= 0
    && int.parse(total) >= int.parse(remain)) {
      var result = appState.sqlConnection.add(bookName, author, category, publisher, 
        int.parse(year), double.parse(price), int.parse(total), int.parse(remain));
      result.then((res) {
        appState.setAddId(res[0]['bookno'], bookName);
      });
      setState(() {
        promptPage = AddSuccessPrompt();
      });
      return;
    } else {
      setState(() {
        promptPage = ErrorPrompt();
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final textBoxColor = Color.fromARGB(255, 211, 201, 183);
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 1, 1, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            promptPage,
            SizedBox(height: 50),
            Text(
              'Add',
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
                      labelText: 'Book Name',
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
                        bookName = value;
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
                    labelText: 'Author',
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
                      author = value;
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
                    labelText: 'Category',
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
                      category = value;
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
                    labelText: 'Publisher',
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
                      publisher = value;
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
                    labelText: 'Publisher Year',
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
                      year = value;
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
                    labelText: 'Price',
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
                      price = value;
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
                    labelText: 'Total Count',
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
                      total = value;
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
                    labelText: 'Stock',
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
                      remain = value;
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
                createUser(appState);
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
