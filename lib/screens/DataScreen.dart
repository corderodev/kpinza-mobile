import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kpinza_mobile/class/Project.dart';
import 'package:kpinza_mobile/screens/ProjectsMetricsScreen.dart';
import 'package:kpinza_mobile/utils/firebase_utils.dart';
import 'package:kpinza_mobile/screens/AuthScreen.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<Project> projects = [];

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  void _fetchProjects() {
    Stream<List<Project>> projectsStream =
        FirebaseUtils.projectsStreamFromFirebase();

    projectsStream.listen((List<Project> fetchedProjects) {
      setState(() {
        projects = fetchedProjects;
      });
    }, onError: (Object? error) {
      print("Failed to fetch projects: $error");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Error al obtener la lista de proyectos.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> _showProjectMetrics(Project project) async {
    String? userUid = UserGlobal.uid;

    DatabaseReference statusRef = FirebaseDatabase.instance
        .ref('users/$userUid/projects/${project.id}/brief');
    DatabaseReference tasksRef = FirebaseDatabase.instance
        .ref('users/$userUid/projects/${project.id}/tasks');

    statusRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? statusMap =
            event.snapshot.value as Map<dynamic, dynamic>?;

        if (statusMap != null) {
          int completedTasks = statusMap['completedTasks'] ?? 0;
          int inProgressTasks = statusMap['inProgressTasks'] ?? 0;
          int pendingTasks = statusMap['pendingTasks'] ?? 0;

          double completed = completedTasks.toDouble();
          double pending = pendingTasks.toDouble();
          double inProgress = inProgressTasks.toDouble();

          double totalTasks = completed + pending + inProgress;

          double eficacia = (completed / totalTasks) * 100;
          double eficiencia = (completed / totalTasks) * 100;
          double efectividad = (eficacia + eficiencia) / 2;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectMetricsScreen(
                projectName: project.name,
                completedTasks: completedTasks,
                inProgressTasks: inProgressTasks,
                pendingTasks: pendingTasks,
                eficacia: eficacia,
                eficiencia: eficiencia,
                efectividad: efectividad,
              ),
            ),
          );
        } else {
          // Mostrar mensaje de error si no hay métricas disponibles
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'No hay métricas disponibles para este proyecto.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cerrar'),
                  ),
                ],
              );
            },
          );
        }
      }
    }, onError: (error) {
      print("Failed to fetch project metrics: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Métricas de proyectos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(project.name),
                      onTap: () {
                        _showProjectMetrics(project);
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
