import 'package:flutter/material.dart';
import 'package:todo_flutter/models/task.dart';
import 'package:todo_flutter/models/user.dart';

import 'package:todo_flutter/task_service.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
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
                          padding: EdgeInsets.only(top: 3, left: 5, right: 5),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                color: tasks[index].completed
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).unselectedWidgetColor,
                              ),
                              height: 50,
                              child: Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${tasks[index].title}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      Text('${tasks[index].description}',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 10,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ]),
                              )));
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
