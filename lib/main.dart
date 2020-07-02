import 'package:flutter/material.dart';
import 'package:todo_flutter/models/task.dart';
import 'package:todo_flutter/widgets/tasks.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(
          primaryColor: Color(0xFF45625D),
          unselectedWidgetColor: Color(0xFF6AA5A9),
          accentColor: Color(0xFFA3D2D5),
        ),
        home: PageHolder());
  }
}

class PageHolder extends StatefulWidget {
  @override
  _PageHolderState createState() => _PageHolderState();
}

class _PageHolderState extends State<PageHolder> {
  int _currentNav = 0;

  static List<Widget> _widgets = <Widget>[
    Tasks(),
    Text('Projects'),
    Text('Settings')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Scaffold(
          body: _widgets.elementAt(_currentNav),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentNav,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.today), title: Text('Tasks')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.folder), title: Text('Projects')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), title: Text('Settings')),
            ],
            selectedItemColor: Theme.of(context).accentColor,
            unselectedItemColor: Theme.of(context).unselectedWidgetColor,
            backgroundColor: Theme.of(context).primaryColor,
            onTap: (index) {
              setState(() {
                _currentNav = index;
              });
            },
          )),
    ));
  }
}
