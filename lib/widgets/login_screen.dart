import 'package:flutter/material.dart';
import 'package:todo_flutter/widgets/page_holder.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login | Signup')),
        body: RaisedButton(
            child: Text('Login',
                style: TextStyle(color: Theme.of(context).primaryColor)),
            color: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new PageHolder()),
              );
            }));
  }
}
