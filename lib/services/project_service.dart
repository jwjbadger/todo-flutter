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
          id: project['_id'],
          title: project['title'],
          description: project['description'],
          users: project['users'],
          tasks: tasks));
    }

    return decodedProjects;
  }

  Future<String> toggleComplete({taskIndex: int, project: Project}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final Map<String, String> dataHeaders = {
      "auth-token": prefs.getString('jwt') ??
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZWZiMzNhY2M4ZDdkZTM2MWM5NzMzMTAiLCJpYXQiOjE1OTM1MzkxOTd9.NKBNTz08TQzw6irKVOcliEcWV42F5pfTBWvlm7MEwvI",
      "content-type": "application/json"
    };

    final newTasks = encodeTask(tasks: project.tasks);
    newTasks[taskIndex]['completed'] = !newTasks[taskIndex]['completed'];
    newTasks
        .sort((a, b) => (a['completed'] ? 1 : 0) - (b['completed'] ? 1 : 0));

    http.Response res = await http.put(rootUrl + 'projects/' + project.id,
        body: jsonEncode({
          '_id': project.id,
          'title': project.title,
          'description': project.description,
          'users': project.users,
          'todos': newTasks
        }),
        headers: dataHeaders);
    return res.body;
  }

  Future<String> deleteTask({taskIndex: int, project: Project}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final Map<String, String> dataHeaders = {
      "auth-token": prefs.getString('jwt') ??
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZWZiMzNhY2M4ZDdkZTM2MWM5NzMzMTAiLCJpYXQiOjE1OTM1MzkxOTd9.NKBNTz08TQzw6irKVOcliEcWV42F5pfTBWvlm7MEwvI",
      "content-type": "application/json"
    };

    project.tasks.removeAt(taskIndex);
    final newTasks = encodeTask(tasks: project.tasks);

    http.Response res = await http.put(rootUrl + 'projects/' + project.id,
        body: jsonEncode({
          '_id': project.id,
          'title': project.title,
          'description': project.description,
          'users': project.users,
          'todos': newTasks
        }),
        headers: dataHeaders);
    return res.body;
  }

  Future<String> deleteProject({projectId: String}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final Map<String, String> dataHeaders = {
      "auth-token": prefs.getString('jwt') ??
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZWZiMzNhY2M4ZDdkZTM2MWM5NzMzMTAiLCJpYXQiOjE1OTM1MzkxOTd9.NKBNTz08TQzw6irKVOcliEcWV42F5pfTBWvlm7MEwvI",
      "content-type": "application/json"
    };

    http.Response res = await http.delete(rootUrl + 'projects/' + projectId,
        headers: dataHeaders);
    return res.body;
  }
}

List encodeTask({tasks: List}) {
  List encodedTasks = [];
  for (var task in tasks) {
    encodedTasks.add({
      'title': task.title,
      'description': task.description,
      'completed': task.completed
    });
  }

  return encodedTasks;
}
