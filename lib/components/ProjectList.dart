import 'package:flutter/material.dart';
import 'package:kpinza_mobile/screens/ProjectDetailScreen.dart';
import 'package:kpinza_mobile/components/Project.dart';

class ProjectList extends StatelessWidget {
  final List<Project> projects;
  final void Function(Project) onDelete;
  final void Function(Project, String) changeProjectName;

  const ProjectList(
      {super.key,
      required this.projects,
      required this.onDelete,
      required this.changeProjectName});

  @override
  Widget build(BuildContext context) {
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
                onDelete(project);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailScreen(
                    project: project,
                    onDelete: onDelete,
                    changeProjectName: changeProjectName,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
