import 'package:flutter/foundation.dart';

class Task {
  String title;
  String description;
  bool completed;

  Task(
      {@required this.title,
      @required this.description,
      @required this.completed});
}
