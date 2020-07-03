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
  final _title = TextEditingController();
  final _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: FutureBuilder(
          future: taskService.getTasks(),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              List<Task> tasks = snapshot.data.tasks;
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    _addNewTask(user: snapshot.data)
                        .then((data) => setState(() {}));
                  },
                ),
                body: ListView.builder(
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
                                      Row(children: [
                                        Switch(
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                            value: tasks[index].completed,
                                            onChanged: (bool newValue) {
                                              setState(() {
                                                tasks[index].completed =
                                                    newValue;
                                              });
                                              taskService.toggleComplete(
                                                  user: snapshot.data,
                                                  index: index,
                                                  newValue: newValue);
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.delete_forever,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            onPressed: () {
                                              taskService
                                                  .removeTask(
                                                      user: snapshot.data,
                                                      index: index)
                                                  .then((data) =>
                                                      setState(() {}));
                                            })
                                      ])
                                    ]),
                              )));
                    }),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<void> _addNewTask({user: User}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Task'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Task Title',
                  ),
                  controller: _title,
                ),
                TextField(
                    decoration: InputDecoration(hintText: 'Task Description'),
                    controller: _description)
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
                child: Text('Add',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                onPressed: () {
                  taskService.addTask(
                      user: user,
                      title: _title.text,
                      description: _description.text);

                  _title.clear();
                  _description.clear();
                  Navigator.of(context).pop();
                },
                color: Theme.of(context).accentColor),
          ],
        );
      },
    );
  }

  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}
