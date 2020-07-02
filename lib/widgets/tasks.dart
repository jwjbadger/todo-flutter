import 'package:flutter/material.dart';
import 'package:todo_flutter/models/task.dart';
import 'package:todo_flutter/models/user.dart';

import 'package:todo_flutter/task_service.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  // final List<Task> tasks = <Task>[
  //   Task(id: '1', title: 'Hi', description: 'Say Hi', completed: false),
  //   Task(id: '2', title: 'Hello', description: 'Another one', completed: true)
  // ];
  final TaskService taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Task List'),
        ),
        body: FutureBuilder(
            future: taskService.getTasks(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              print(snapshot);
              if (snapshot.hasData) {
                List<Task> tasks = snapshot.data.tasks;
                return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Container(
                              height: 50,
                              color: tasks[index].completed
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).unselectedWidgetColor,
                              child: Center(
                                  child: Text('${tasks[index].title}'))));
                    });
              } else {
                return CircularProgressIndicator();
              }
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
        ));
  }
}
