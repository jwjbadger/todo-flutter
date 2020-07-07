import 'package:flutter/material.dart';
import 'package:todo_flutter/widgets/projects.dart';
import 'package:todo_flutter/widgets/settings_screen.dart';
import 'package:todo_flutter/widgets/tasks.dart';

class PageHolder extends StatefulWidget {
  @override
  _PageHolderState createState() => _PageHolderState();
}

class _PageHolderState extends State<PageHolder> {
  int _currentNav = 0;

  static List<Widget> _widgets = <Widget>[
    Tasks(),
    Projects(),
    Settings(),
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
