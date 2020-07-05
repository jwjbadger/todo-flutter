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
                                      Text(projects[index].title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      Text(projects[index].description,
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 10,
                                              color: Theme.of(context)
                                                  .primaryColor))
                                    ],
                                  ),
                                )),
                          );
                        }));
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
