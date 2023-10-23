import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
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
      body: ProjectList(
          projects: projects,
          onDelete: _deleteProject,
          changeProjectName: _changeProjectName),
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
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Descripción'),
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
          child: const Text('Crear proyecto'),
        ),
      ],
    );
  }
}

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

class ProjectDetailScreen extends StatefulWidget {
  final Project project;
  final void Function(Project) onDelete;
  final void Function(Project, String) changeProjectName;

  const ProjectDetailScreen(
      {Key? key,
      required this.project,
      required this.onDelete,
      required this.changeProjectName})
      : super(key: key);

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.project.name;
  }

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

  void _deleteStage(Stage stage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Etapa'),
          content: const Text('¿Seguro que quieres eliminar esta etapa?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.project.stages.remove(stage);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _saveName() {
    final newName = _nameController.text;
    widget.changeProjectName(widget.project, newName);
    Navigator.pop(context);
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
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Editar Nombre del Proyecto'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          controller: _nameController,
                          decoration:
                              const InputDecoration(labelText: 'Nuevo nombre'),
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
                        onPressed: _saveName,
                        child: const Text('Guardar'),
                      ),
                    ],
                  );
                },
              );
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
                  final stage = widget.project.stages[index];
                  return ListTile(
                    title: Text(stage.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteStage(stage);
                      },
                    ),
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

  Project({
    required this.name,
    required this.description,
    List<Stage>? stages,
  }) : stages = stages ?? [];

  Project copyWith({String? name, String? description, List<Stage>? stages}) {
    return Project(
      name: name ?? this.name,
      description: description ?? this.description,
      stages: stages ?? this.stages,
    );
  }
}

class Stage {
  final String name;

  Stage({required this.name});
}
