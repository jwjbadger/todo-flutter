import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/models/project.dart';
import 'package:todo_flutter/services/project_service.dart';

class Projects extends StatefulWidget {
  @override
  _Projects createState() => _Projects();
}

class _Projects extends State<Projects> {
  final ProjectService projectService = ProjectService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Projects')),
        body: FutureBuilder(
            future: projectService.getProjects(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
              if (snapshot.hasData) {
                List<Project> projects = snapshot.data;
                return Scaffold(
                    body: ListView.builder(
                        itemCount: projects.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(left: 6, right: 6, top: 6),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    color: Theme.of(context).accentColor),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(projects[index].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                          IconButton(
                                              icon: Icon(Icons.delete_forever,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              onPressed: () {
                                                projectService
                                                    .deleteProject(
                                                        projectId:
                                                            projects[index].id)
                                                    .then((value) =>
                                                        setState(() {}));
                                              }),
                                          IconButton(
                                            icon: Icon(Icons.edit,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            onPressed: () {
                                              TextEditingController
                                                  _newProjectTitle =
                                                  TextEditingController(
                                                      text: projects[index]
                                                          .title);
                                              TextEditingController
                                                  _newProjectDescription =
                                                  TextEditingController(
                                                      text: projects[index]
                                                          .description);
                                              TextEditingController
                                                  _newProjectUsers =
                                                  TextEditingController(
                                                      text: projects[index]
                                                          .users
                                                          .toString()
                                                          .substring(
                                                              1,
                                                              projects[index]
                                                                      .users
                                                                      .toString()
                                                                      .length -
                                                                  1));

                                              _addOrEditProjects(
                                                      newTitle:
                                                          _newProjectTitle,
                                                      newDescription:
                                                          _newProjectDescription,
                                                      newUsers:
                                                          _newProjectUsers,
                                                      editing: true,
                                                      tasks:
                                                          projects[index].tasks,
                                                      id: projects[index].id)
                                                  .then((value) {
                                                setState(() {});
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 4),
                                        child: Text(projects[index].description,
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 10,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                      ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: projects[index].tasks.length,
                                        itemBuilder: (BuildContext context,
                                            int taskIndex) {
                                          final currentTask =
                                              projects[index].tasks[taskIndex];
                                          return Row(children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 50),
                                              child: Text(currentTask.title,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: currentTask
                                                              .completed
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .focusColor)),
                                            ),
                                            Text(currentTask.description,
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: currentTask.completed
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Theme.of(context)
                                                            .focusColor)),
                                            IconButton(
                                              icon: Icon(
                                                  currentTask.completed
                                                      ? Icons.refresh
                                                      : Icons.check,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              onPressed: () {
                                                projectService
                                                    .toggleComplete(
                                                        taskIndex: taskIndex,
                                                        project:
                                                            projects[index])
                                                    .then((value) =>
                                                        setState(() {}));
                                              },
                                            ),
                                            IconButton(
                                                icon: Icon(Icons.delete_forever,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                onPressed: () {
                                                  projectService
                                                      .deleteTask(
                                                          taskIndex: taskIndex,
                                                          project:
                                                              projects[index])
                                                      .then((value) =>
                                                          setState(() {}));
                                                })
                                          ]);
                                        },
                                      )
                                    ],
                                  ),
                                )),
                          );
                        }));
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  Future<void> _addOrEditProjects(
      {newTitle: TextEditingController,
      newDescription: TextEditingController,
      newUsers: TextEditingController,
      editing: bool,
      tasks: List,
      id: String}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${editing ? 'Edit' : 'Create'} Project'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Project Title',
                  ),
                  controller: newTitle,
                ),
                TextField(
                    decoration:
                        InputDecoration(hintText: 'Project Description'),
                    controller: newDescription),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Project Users',
                  ),
                  controller: newUsers,
                ),
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
                child: Text('Submit',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                onPressed: () {
                  if (editing) {
                    projectService.editProject(
                        title: newTitle.text,
                        description: newDescription.text,
                        users: newUsers.text.split(', '),
                        tasks: tasks,
                        id: id);

                    newTitle.clear();
                    newDescription.clear();
                    newUsers.clear();
                    Navigator.of(context).pop();
                  } else {
                    print('creating project....');
                  }
                },
                color: Theme.of(context).accentColor),
          ],
        );
      },
    );
  }
}
