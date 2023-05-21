import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/background.jpg'
            ),
            fit: BoxFit.cover,
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                HugeCard(),
              ],
            ),
          ]
        ),
      )
    );
  }
}

class HugeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium!.copyWith(
      color: Color.fromARGB(223, 249, 249, 249),
    );
    DateTime now = DateTime.now();
    int hour = now.hour.toInt();
    String greeting;
    if (0 <= hour && hour < 12) {
      greeting = 'Good morning! 🥂';
    } else if (hour >= 12 && hour <= 16) {
      greeting = 'Good afternoon! 🥂';
    } else {
      greeting = 'Good evening! 🥂';
    }
    return Card(
      color: Color.fromARGB(255, 99, 70, 31),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          greeting,
          style: style,
        )
      )
    );
  }
}