import 'package:flutter/material.dart';
import 'package:kpinza_mobile/components/Project.dart';
import 'package:kpinza_mobile/screens/ProjectDetailScreen.dart';
import 'package:kpinza_mobile/utils/firebase_utils.dart';

class ProjectList extends StatefulWidget {
  final void Function(Project) onDelete;
  final void Function(Project, String) changeProjectName;

  const ProjectList({
    Key? key,
    required this.onDelete,
    required this.changeProjectName,
    required List<Project> projects,
  }) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  late Stream<List<Project>> _projectsStream;

  @override
  void initState() {
    super.initState();
    _projectsStream = FirebaseUtils.projectsStreamFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Project>>(
      stream: _projectsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error al cargar los proyectos.'),
          );
        }

        final projects = snapshot.data ?? [];

        if (projects.isEmpty) {
          return const Center(
            child: Text('No tienes proyectos todavía.'),
          );
        }

        return ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(project.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    widget.onDelete(project);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailScreen(
                        project: project,
                        onDelete: widget.onDelete,
                        changeProjectName: widget.changeProjectName,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
