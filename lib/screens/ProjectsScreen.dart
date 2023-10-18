import 'package:flutter/material.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<Project> projects = [];

  void _createProject(String projectName, String projectDescription) {
    setState(() {
      projects.add(Project(name: projectName, description: projectDescription));
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
      body: ProjectList(projects: projects, onDelete: _deleteProject),
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
  final List<Project> projects;
  final void Function(Project) onDelete;

  const ProjectList(
      {super.key, required this.projects, required this.onDelete});

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

class ProjectDetailScreen extends StatefulWidget {
  final Project project;
  final void Function(Project) onDelete;

  const ProjectDetailScreen({
    Key? key,
    required this.project,
    required this.onDelete,
  }) : super(key: key);

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  void _showCreateStageForm(BuildContext context) {
    final TextEditingController stageNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Crear Etapa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: stageNameController,
                decoration:
                    const InputDecoration(labelText: 'Nombre de la etapa'),
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
                final stageName = stageNameController.text;
                if (stageName.isNotEmpty) {
                  setState(() {
                    widget.project.stages.add(Stage(name: stageName));
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Crear Etapa'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.onDelete(widget.project);
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateStageForm(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Descripción del proyecto:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Padding(padding: EdgeInsets.all(4)),
            Text(
              widget.project.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Etapas:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Padding(padding: EdgeInsets.all(4)),
            Expanded(
              child: ListView.builder(
                itemCount: widget.project.stages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.project.stages[index].name),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Project {
  final String name;
  final String description;
  final List<Stage> stages;

  Project({required this.name, required this.description, List<Stage>? stages})
      : stages = stages ?? [];
}

class Stage {
  final String name;

  Stage({required this.name});
}
