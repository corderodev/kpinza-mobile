import 'package:flutter/material.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<String> projects = [];

  void _createProject(String projectName, String projectDescription) {
    setState(() {
      projects.add('$projectName: $projectDescription');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProjectList(projects: projects),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateProjectForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateProjectForm extends StatefulWidget {
  final void Function(String projectName, String projectDescription) onSubmit;

  const CreateProjectForm({super.key, required this.onSubmit});

  @override
  _CreateProjectFormState createState() => _CreateProjectFormState();
}

class _CreateProjectFormState extends State<CreateProjectForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear Proyecto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nombre del proyecto'),
          ),
          TextFormField(
            controller: _descriptionController,
            decoration:
                const InputDecoration(labelText: 'Descripción del proyecto'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final projectName = _nameController.text;
            final projectDescription = _descriptionController.text;
            widget.onSubmit(projectName, projectDescription);

            _nameController.clear();
            _descriptionController.clear();

            Navigator.of(context).pop();
          },
          child: const Text('Crear Proyecto'),
        ),
      ],
    );
  }
}

class ProjectList extends StatelessWidget {
  final List<String> projects;

  const ProjectList({super.key, required this.projects});

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
        return ListTile(
          title: Text(projects[index]),
        );
      },
    );
  }
}
