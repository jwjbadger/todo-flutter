import 'package:flutter/material.dart';
import 'package:todo_flutter/models/task.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final List<Task> tasks = <Task>[
    Task('1', 'Hi', 'Say Hi', false),
    Task('2', 'Hello', 'Another one', true)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Task List'),
        ),
        body: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Container(
                      height: 50,
                      color: tasks[index].completed
                          ? Theme.of(context).accentColor
                          : Theme.of(context).unselectedWidgetColor,
                      child: Center(child: Text('${tasks[index].title}'))));
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
        ));
  }
}
