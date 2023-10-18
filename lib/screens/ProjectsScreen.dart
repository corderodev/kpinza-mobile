import 'package:flutter/material.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<String> projects = [];
  bool isCreatingProject = false;

  void _createProject(String projectName, String projectDescription) {
    setState(() {
      projects.add('$projectName: $projectDescription');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          CreateProjectForm(
            onSubmit: _createProject,
            isVisible: isCreatingProject,
          ),
          Expanded(
            child: ProjectList(projects: projects),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    isCreatingProject = !isCreatingProject;
                  });
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateProjectForm extends StatefulWidget {
  final void Function(String projectName, String projectDescription) onSubmit;
  final bool isVisible;

  const CreateProjectForm(
      {super.key, required this.onSubmit, required this.isVisible});

  @override
  _CreateProjectFormState createState() => _CreateProjectFormState();
}

class _CreateProjectFormState extends State<CreateProjectForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: Column(
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
          ElevatedButton(
            onPressed: () {
              final projectName = _nameController.text;
              final projectDescription = _descriptionController.text;
              widget.onSubmit(projectName, projectDescription);

              _nameController.clear();
              _descriptionController.clear();
            },
            child: const Text('Crear Proyecto'),
          ),
        ],
      ),
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
