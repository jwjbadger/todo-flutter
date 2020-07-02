import 'package:flutter/foundation.dart';

class Task {
  final String title;
  final String description;
  final bool completed;

  Task(
      {@required this.title,
      @required this.description,
      @required this.completed});
}
