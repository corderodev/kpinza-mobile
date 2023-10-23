import 'package:flutter/material.dart';
import 'package:kpinza_mobile/components/CreateProjectForm.dart';
import 'package:kpinza_mobile/components/ProjectList.dart';
import 'package:kpinza_mobile/components/Project.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProjectsScreen(),
    );
  }
}

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<Project> projects = [];

  void _changeProjectName(Project project, String newName) {
    setState(() {
      final projectIndex = projects.indexOf(project);
      if (projectIndex != -1) {
        projects[projectIndex] = project.copyWith(name: newName);
      }
    });
  }

  void _createProject(String projectName) {
    setState(() {
      projects.add(Project(name: projectName));
    });
  }

  Future<void> _showCreateProjectForm(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateProjectForm(onSubmit: _createProject);
      },
    );
  }

  void _deleteProject(Project project) {
    setState(() {
      projects.remove(project);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProjectList(
        projects: projects,
        onDelete: _deleteProject,
        changeProjectName: _changeProjectName,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateProjectForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
