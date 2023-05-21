import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_app_state.dart';
import 'welcome.dart';
import 'find.dart';
import 'add.dart';
import 'register.dart';
import 'borrow.dart';
import 'connection_loss.dart';
import 'return.dart';
import 'help.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	var selectedIndex = 0;
  var railColor = Color.fromARGB(218, 117, 76, 15);
  var indicatorColor = Color.fromARGB(218, 170, 139, 93);

  void getHelpString(appState) {
    File file = File('assets/help.md');
    Future<String> futureContent = file.readAsString();
    futureContent.then((fileString) {
      appState.helpString = fileString;
    });
    return;
  }

  void changeColor() {
    switch(selectedIndex) {
      case 0:
        setState(() {
          railColor = Color.fromARGB(218, 117, 76, 15);
          indicatorColor = Color.fromARGB(218, 170, 139, 93);
        });
        break;
      case 1:
        setState(() {
          railColor = Color.fromARGB(218, 112, 94, 14);
          indicatorColor = Color.fromARGB(218, 175, 160, 140);
        });
        break;
      case 2:
        setState(() {
          railColor = Color.fromARGB(218, 112, 113, 58);
          indicatorColor = Color.fromARGB(218, 177, 177, 144);   
        });
        break;
      case 3:
        setState(() {
          railColor = Color.fromARGB(218, 99, 133, 70);
          indicatorColor = Color.fromARGB(218, 150, 172, 132);
        });
        break;
      case 4:
        setState(() {
          railColor = Color.fromARGB(218, 70, 133, 97);
          indicatorColor = Color.fromARGB(218, 152, 179, 164);
        });
        break;
      case 5:
        setState(() {
          railColor = Color.fromARGB(218, 70, 133, 133);
          indicatorColor = Color.fromARGB(218, 161, 191, 191);        
        });
        break;
      case 6:
        setState(() {
          railColor = Color.fromARGB(218, 70, 95, 133);
          indicatorColor = Color.fromARGB(218, 134, 152, 180);       
        });
        break;
      default:
        throw UnimplementedError('out of range for colors');
    } 
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final style = Theme.of(context).textTheme.labelLarge!.copyWith(
      color: Color.fromARGB(218, 244, 234, 217),
    );
		Widget page;
    var iconColor = Color.fromARGB(218, 244, 234, 217);
		switch (selectedIndex) {
			case 0:
				page = WelcomePage();
				break;
			case 1:
				page = FindPage();
				break;
      case 2:
        page = BorrowPage();
        break;
      case 3:
        page = ReturnPage();
        break;
      case 4:
        page = AddPage();
        break;
      case 5:
        page = RegisterPage();
        break;
      case 6:
        page = HelpPage();
        break;
			default:
				throw UnimplementedError('no widget for $selectedIndex');
		}
    if (appState.firstCheck) {
      Future<bool> isConnected = appState.sqlConnection.testConnection();
      isConnected.then((isConnectedResult) {
        setState(() {
          appState.setSqlStatus(isConnectedResult);
        });
      });
      appState.firstCheck = false;
    }
    if (appState.sqlStatus) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: Stack(
                    children: [
                      NavigationRail(
                        backgroundColor: railColor,
                        indicatorColor: indicatorColor,
                        extended: constraints.maxWidth >= 600,
                        destinations: [
                          NavigationRailDestination(
                            icon: Icon(
                              Icons.home_outlined, 
                              color: iconColor
                            ), 
                            label: Text(
                              'Home', 
                              style: style
                            ),
                          ),
                          NavigationRailDestination(
                            icon: Icon(
                              Icons.manage_search_outlined, 
                              color: iconColor
                            ),
                            label: Text(
                              'Find', 
                              style: style,
                            ),
                          ),
                          NavigationRailDestination(
                            icon: Icon(
                              Icons.arrow_upward_outlined, 
                              color: iconColor
                            ), 
                            label: Text(
                              'Borrow', 
                              style: style,
                            ),
                          ),
                          NavigationRailDestination(
                            icon: Icon(
                              Icons.arrow_downward_outlined, 
                              color: iconColor
                            ), 
                            label: Text(
                              'Return', 
                              style: style,
                            ),
                          ),
                          NavigationRailDestination(
                            icon: Icon(
                              Icons.note_add_outlined, 
                              color: iconColor,
                            ), 
                            label: Text(
                              'Add', 
                              style: style,
                            ),
                          ),
                          NavigationRailDestination(
                            icon: Icon(
                              Icons.person_add_outlined, 
                              color: iconColor,
                            ), 
                            label: Text(
                              'Register', 
                              style: style,
                            ),
                          ),
                          NavigationRailDestination(
                            icon: Icon(
                              Icons.question_mark, 
                              color: iconColor,
                            ), 
                            label: Text(
                              'Help', 
                              style: style,
                            ),
                          ),
                        ],
                        selectedIndex: selectedIndex,
                        onDestinationSelected: (value) {
                          if (value == 1) {
                            appState.findPageInit = true;
                          }
                          if (value == 3) {
                            appState.returnPageInit = true;
                          }
                          getHelpString(appState);
                          setState(() {
                            selectedIndex = value;
                            changeColor();
                          });
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 19),
                              Text(
                                appState.version,
                                style: TextStyle(color: Color.fromARGB(103, 255, 255, 255)),
                              ),
                            ],
                          ),
                          SizedBox(height: 7),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
              ],
            ),          
          );
        }
      );
    } else {
      return ConnectionLossPage();
    }
  }
}
