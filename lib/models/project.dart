import 'package:flutter/foundation.dart';
import 'package:todo_flutter/models/task.dart';

class Project {
  String title;
  String description;
  List users;
  List<Task> tasks;

  Project(
      {@required this.title,
      @required this.description,
      @required this.users,
      @required this.tasks});
}
