import 'package:flutter/material.dart';
import 'package:todo_flutter/task_service.dart';
import 'package:todo_flutter/widgets/page_holder.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final TaskService taskService = TaskService();

  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login | Signup')),
      body: Column(children: [
        Padding(
            padding: EdgeInsets.only(top: 5, left: 5, right: 5),
            child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
                controller: _username)),
        Padding(
          padding: EdgeInsets.all(5),
          child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              controller: _password),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 4),
              child: RaisedButton(
                  child: Text('Register',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    _username.clear();
                    _password.clear();
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new PageHolder()),
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(right: 4),
              child: RaisedButton(
                  child: Text('Login',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    taskService
                        .login(
                            username: _username.text, password: _password.text)
                        .then((data) => {
                              if (data['err'] == null)
                                {
                                  _username.clear(),
                                  _password.clear(),
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new PageHolder()),
                                  ),
                                }
                              else
                                {
                                  _alertUser(msg: data['err']),
                                  _password.clear(),
                                }
                            });
                  }),
            ),
          ],
        ),
      ]),
    );
  }

  Future<void> _alertUser({msg: String}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Just letting you know...'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }
}
