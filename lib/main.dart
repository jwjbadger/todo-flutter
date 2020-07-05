import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/widgets/login_screen.dart';
import 'package:todo_flutter/widgets/page_holder.dart';

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
            focusColor: Color(0xFF3F7856)),
        home: FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (BuildContext context,
                AsyncSnapshot<SharedPreferences> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.getString('jwt') == null
                    ? Login()
                    : PageHolder();
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
