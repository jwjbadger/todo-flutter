import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_flutter/models/task.dart';
import 'package:todo_flutter/models/user.dart';

class TaskService {
  final String rootUrl = "http://10.3.7.24:3000/";
  final Map<String, String> getHeaders = {
    "auth-token":
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZWZiMzNhY2M4ZDdkZTM2MWM5NzMzMTAiLCJpYXQiOjE1OTM1MzkxOTd9.NKBNTz08TQzw6irKVOcliEcWV42F5pfTBWvlm7MEwvI"
  };
  final Map<String, String> dataHeaders = {
    "auth-token":
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZWZiMzNhY2M4ZDdkZTM2MWM5NzMzMTAiLCJpYXQiOjE1OTM1MzkxOTd9.NKBNTz08TQzw6irKVOcliEcWV42F5pfTBWvlm7MEwvI",
    "content-type": "application/json"
  };

  Future<User> getTasks() async {
    http.Response res = await http.get(
        rootUrl + 'users/' + '5efb33acc8d7de361c973310',
        headers: getHeaders);
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

  Future<String> toggleComplete(
      {user: User, index: int, newValue: bool}) async {
    user.tasks[index].completed = newValue;
    user.tasks.sort((a, b) => (a.completed ? 1 : 0) - (b.completed ? 1 : 0));

    List encodedTasks = encodeTask(tasks: user.tasks);

    http.Response res = await http.patch(rootUrl + 'users/' + user.id,
        body: jsonEncode({'todos': encodedTasks}), headers: dataHeaders);
    return res.body;
  }

  Future<String> addTask(
      {user: User, title: String, description: String}) async {
    user.tasks.add(Task(
        title: title.isEmpty ? 'No Title' : title,
        description: description.isEmpty ? 'No description' : description,
        completed: false));
    user.tasks.sort((a, b) => (a.completed ? 1 : 0) - (b.completed ? 1 : 0));

    List encodedTasks = encodeTask(tasks: user.tasks);

    http.Response res = await http.patch(rootUrl + 'users/' + user.id,
        body: jsonEncode({'todos': encodedTasks}), headers: dataHeaders);
    return res.body;
  }

  Future<String> removeTask({user: User, index: int}) async {
    user.tasks.removeAt(index);

    List encodedTasks = encodeTask(tasks: user.tasks);

    http.Response res = await http.patch(rootUrl + 'users/' + user.id,
        body: jsonEncode({'todos': encodedTasks}), headers: dataHeaders);
    return res.body;
  }

  Future<String> editTask(
      {user: User, title: String, description: String, index: int}) async {
    user.tasks[index].title = title;
    user.tasks[index].description = description;

    List encodedTasks = encodeTask(tasks: user.tasks);

    http.Response res = await http.patch(rootUrl + 'users/' + user.id,
        body: jsonEncode({'todos': encodedTasks}), headers: dataHeaders);
    return res.body;
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
}
