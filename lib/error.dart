import 'package:flutter/material.dart';

class ErrorPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 228, 166, 166),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'ERROR: please check and try again!',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
