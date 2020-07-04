import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/models/task.dart';
import 'package:todo_flutter/models/user.dart';

class TaskService {
  final String rootUrl = "http://10.3.7.24:3000/";

  Future<User> getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final Map<String, String> dataHeaders = {
      "auth-token": prefs.getString('jwt') ??
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZWZiMzNhY2M4ZDdkZTM2MWM5NzMzMTAiLCJpYXQiOjE1OTM1MzkxOTd9.NKBNTz08TQzw6irKVOcliEcWV42F5pfTBWvlm7MEwvI",
      "content-type": "application/json"
    };

    http.Response res = await http.get(
        rootUrl + 'users/' + prefs.getString('id') ??
            '5efb33acc8d7de361c973310',
        headers: dataHeaders);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, String> dataHeaders = {
      "auth-token": prefs.getString('jwt') ??
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZWZiMzNhY2M4ZDdkZTM2MWM5NzMzMTAiLCJpYXQiOjE1OTM1MzkxOTd9.NKBNTz08TQzw6irKVOcliEcWV42F5pfTBWvlm7MEwvI",
      "content-type": "application/json"
    };

    user.tasks[index].completed = newValue;
    user.tasks.sort((a, b) => (a.completed ? 1 : 0) - (b.completed ? 1 : 0));

    List encodedTasks = encodeTask(tasks: user.tasks);

    http.Response res = await http.patch(rootUrl + 'users/' + user.id,
        body: jsonEncode({'todos': encodedTasks}), headers: dataHeaders);
    return res.body;
  }

  Future<String> addTask(
      {user: User, title: String, description: String}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, String> dataHeaders = {
      "auth-token": prefs.getString('jwt') ??
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZWZiMzNhY2M4ZDdkZTM2MWM5NzMzMTAiLCJpYXQiOjE1OTM1MzkxOTd9.NKBNTz08TQzw6irKVOcliEcWV42F5pfTBWvlm7MEwvI",
      "content-type": "application/json"
    };

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, String> dataHeaders = {
      "auth-token": prefs.getString('jwt') ??
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZWZiMzNhY2M4ZDdkZTM2MWM5NzMzMTAiLCJpYXQiOjE1OTM1MzkxOTd9.NKBNTz08TQzw6irKVOcliEcWV42F5pfTBWvlm7MEwvI",
      "content-type": "application/json"
    };

    user.tasks.removeAt(index);

    List encodedTasks = encodeTask(tasks: user.tasks);

    http.Response res = await http.patch(rootUrl + 'users/' + user.id,
        body: jsonEncode({'todos': encodedTasks}), headers: dataHeaders);
    return res.body;
  }

  Future<String> editTask(
      {user: User, title: String, description: String, index: int}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, String> dataHeaders = {
      "auth-token": prefs.getString('jwt') ??
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZWZiMzNhY2M4ZDdkZTM2MWM5NzMzMTAiLCJpYXQiOjE1OTM1MzkxOTd9.NKBNTz08TQzw6irKVOcliEcWV42F5pfTBWvlm7MEwvI",
      "content-type": "application/json"
    };

    user.tasks[index].title = title;
    user.tasks[index].description = description;

    List encodedTasks = encodeTask(tasks: user.tasks);

    http.Response res = await http.patch(rootUrl + 'users/' + user.id,
        body: jsonEncode({'todos': encodedTasks}), headers: dataHeaders);
    return res.body;
  }

  Future<Map> register({username: String, password: String}) async {
    final Map<String, String> dataHeaders = {
      "content-type": "application/json"
    };

    http.Response res = await http.post(rootUrl + 'users/register',
        body: jsonEncode({'name': username, 'password': password}),
        headers: dataHeaders);
    final decodedRes = jsonDecode(res.body);

    if (decodedRes['err'] == null) {
      return login(username: username, password: password);
    } else {
      return decodedRes;
    }
  }

  Future<Map> login({username: String, password: String}) async {
    final Map<String, String> dataHeaders = {
      "content-type": "application/json"
    };

    http.Response res = await http.post(rootUrl + 'users/login',
        body: jsonEncode({'name': username, 'password': password}),
        headers: dataHeaders);
    final decodedRes = jsonDecode(res.body);

    if (decodedRes['err'] == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt', decodedRes['token']);
      prefs.setString('id', _decodeJwt(decodedRes['token'])['_id']);
    }

    return decodedRes;
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

_decodeJwt(String token) {
  Map<String, dynamic> tokenDecoded = parseJwt(token);
  String siteId = tokenDecoded['site_id'];

  return tokenDecoded;
}

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}
