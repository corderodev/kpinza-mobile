import 'package:flutter/material.dart';
import 'package:kpinza_mobile/components/CreateProjectForm.dart';
import 'package:kpinza_mobile/components/ProjectList.dart';
import 'package:kpinza_mobile/class/Project.dart';
import 'package:kpinza_mobile/utils/firebase_utils.dart';
import 'package:kpinza_mobile/screens/AuthScreen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  late List<Project> projects = [];

  @override
  void initState() {
    super.initState();
    obtenerProyectos();
  }

  Future<void> obtenerProyectos() async {
    List<Project> fetchedProjects =
        await FirebaseUtils.obtenerProyectosDesdeFirebase();
    setState(() {
      projects = fetchedProjects;
    });
  }

  void _changeProjectName(Project project, String newName) async {
    try {
      await FirebaseUtils.updateProjectName(project.name, newName);
      setState(() {
        final projectIndex = projects.indexWhere((p) => p.name == project.name);
        if (projectIndex != -1) {
          projects[projectIndex] = project.copyWith(name: newName);
        }
      });
    } catch (e) {
      print('Error al cambiar el nombre del proyecto: $e');
    }
  }

  Future<void> _createProject(String projectName) async {
    try {
      String? userUid = UserGlobal.uid;

      if (userUid != null) {
        Project newProject =
            Project(id: projectName, name: projectName, supervisor: '');

        await FirebaseUtils.saveProject(userUid, newProject);
        obtenerProyectos();
      } else {
        print('Error: El uid del usuario es nulo');
      }
    } catch (e) {
      print('Error al crear y guardar el proyecto: $e');
    }
  }

  Future<void> _showCreateProjectForm(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateProjectForm(onSubmit: (projectName) {
          _createProject(projectName);
        });
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(Project project) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Proyecto'),
          content: const Text('¿Seguro que quieres eliminar este proyecto?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteProject(project);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProject(Project project) async {
    try {
      await FirebaseUtils.deleteProject(project.name);
      setState(() {
        projects.remove(project);
      });
    } catch (e) {
      print('Error al eliminar el proyecto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProjectList(
        onDelete: _showDeleteConfirmationDialog,
        changeProjectName: _changeProjectName,
        projects: projects,
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
