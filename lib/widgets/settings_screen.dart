import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/services/task_service.dart';

class Settings extends StatefulWidget {
  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  final TaskService _taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              'Danger Zone',
              style: TextStyle(
                  fontSize: 30, color: Theme.of(context).primaryColor),
            ),
          ),
          RaisedButton(
            color: Theme.of(context).accentColor,
            onPressed: () {
              deleteAccount();
            },
            child: Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _taskService.deleteUser(id: prefs.getString('id'));
    prefs.remove('id');
    prefs.remove('jwt');
    _notifyUser();
  }

  Future<void> _notifyUser() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Exit the App'),
            content: SingleChildScrollView(
              child: Text(
                  '${Platform.isAndroid ? 'Hit the square button (or equivalent on other phones), then hit the X on this app' : 'Double tap home (or equivalent on new phones), and swipe up on this app'}'),
            ),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
