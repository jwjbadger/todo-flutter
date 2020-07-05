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
                return Scaffold(body: Text(projects.toString()));
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
