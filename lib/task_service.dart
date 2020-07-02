import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_flutter/models/task.dart';
import 'package:todo_flutter/models/user.dart';

class TaskService {
  final String rootUrl = "http://10.3.7.24:3000/";
  final Map<String, String> headers = {
    "auth-token":
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZWZiMzNhY2M4ZDdkZTM2MWM5NzMzMTAiLCJpYXQiOjE1OTM1MzkxOTd9.NKBNTz08TQzw6irKVOcliEcWV42F5pfTBWvlm7MEwvI"
  };

  Future<User> getTasks() async {
    http.Response res = await http
        .get(rootUrl + 'users/' + '5efb33acc8d7de361c973310', headers: headers);
    Map data = jsonDecode(res.body);

    List<Task> tasks = [];
    for (var task in data['todos']) {
      tasks.add(Task(
          title: task['title'],
          description: task['description'],
          completed: task['completed']));
    }

    User user = User(
        id: data['_id'],
        name: data['name'],
        password: data['password'],
        tasks: tasks);

    return user;
  }
}
