import 'package:flutter/foundation.dart';
import 'package:todo_flutter/models/task.dart';

class User {
  String id;
  String name;
  String password;
  List<Task> tasks;

  User(
      {@required this.id,
      @required this.name,
      @required this.password,
      @required this.tasks});
}
