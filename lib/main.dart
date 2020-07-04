import 'package:flutter/material.dart';
import 'package:todo_flutter/widgets/login_screen.dart';

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
        home: Login());
  }
}
