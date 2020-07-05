import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/models/project.dart';

import 'package:http/http.dart' as http;
import 'package:todo_flutter/models/task.dart';

class ProjectService {
  final String rootUrl = "http://10.3.7.24:3000/";

  Future<List<Project>> getProjects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final Map<String, String> dataHeaders = {
      "auth-token": prefs.getString('jwt') ??
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZWZiMzNhY2M4ZDdkZTM2MWM5NzMzMTAiLCJpYXQiOjE1OTM1MzkxOTd9.NKBNTz08TQzw6irKVOcliEcWV42F5pfTBWvlm7MEwvI",
      "content-type": "application/json"
    };

    http.Response res = await http.get(
        rootUrl + 'projects/' + prefs.getString('uid') ?? 'default',
        headers: dataHeaders);
    List data = jsonDecode(res.body);

    List<Project> decodedProjects = [];
    for (var project in data) {
      List<Task> tasks = [];
      for (var task in project['todos']) {
        tasks.add(Task(
            title: task['title'],
            description: task['description'],
            completed: task['completed']));
      }

      decodedProjects.add(Project(
          title: project['title'],
          description: project['description'],
          users: project['users'],
          tasks: tasks));
    }

    return decodedProjects;
  }
}
