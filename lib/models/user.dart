import 'package:flutter/foundation.dart';
import 'package:todo_flutter/models/task.dart';

class User {
  final String id;
  final String name;
  final String password;
  final List<Task> tasks;

  User(
      {@required this.id,
      @required this.name,
      @required this.password,
      @required this.tasks});
}
