import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_app_state.dart';
import 'error.dart';

class RegisterSuccessPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Card(
      color: Color.fromARGB(255, 173, 228, 166),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          appState.registerId,
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var name = '';
  var department = '';
  var cardType = '';
  Widget promptPage = SizedBox(height: 45);

  void createUser(var appState) {
    if (name.isNotEmpty && department.isNotEmpty && cardType.isNotEmpty) {
      if (cardType != 'Teacher' && cardType != 'Student') {
        setState(() {
          promptPage = ErrorPrompt();
        });
        return;
      }
      var result = appState.sqlConnection.register(name, department, cardType);
      result.then((res) {
        appState.setRegisterId(res[0]['cardid'], name, department, cardType);
      });
      setState(() {
        promptPage = RegisterSuccessPrompt();
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
              'Register',
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
                      labelText: 'Name',
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
                        name = value;
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
                    labelText: 'Department',
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
                      department = value;
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
                    labelText: 'Type (Teacher/Student)',
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
                      cardType = value;
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

