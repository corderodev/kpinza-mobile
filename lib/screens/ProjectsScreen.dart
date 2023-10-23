import 'package:flutter/material.dart';

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
  final void Function(String projectName) onSubmit;

  const CreateProjectForm({super.key, required this.onSubmit});

  @override
  _CreateProjectFormState createState() => _CreateProjectFormState();
}

class _CreateProjectFormState extends State<CreateProjectForm> {
  final TextEditingController _nameController = TextEditingController();

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
            widget.onSubmit(projectName);

            _nameController.clear();

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

  String? selectedStage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.project.name;
    if (widget.project.stages.isNotEmpty) {
      selectedStage = widget.project.stages.first.name;
    }
  }

  void _showCreateStageOrTaskForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateStageOrTaskForm(
          stages: widget.project.stages,
          onCreateStage: _createStage,
          onCreateTask: (taskName, stageName) {
            _createTask(taskName, stageName);
          },
        );
      },
    );
  }

  void _createStage(String stageName) {
    setState(() {
      widget.project.stages.add(Stage(name: stageName, tasks: []));
    });
    Navigator.of(context).pop();
  }

  void _createTask(String taskName, String stageName) {
    setState(() {
      if (selectedStage != null) {
        final stage =
            widget.project.stages.firstWhere((s) => s.name == selectedStage);
        stage.tasks.add(Task(name: taskName));
      }
    });
    Navigator.of(context).pop();
  }

  void _deleteTask(Stage stage, Task task) {
    setState(() {
      final stageIndex = widget.project.stages.indexOf(stage);
      if (stageIndex != -1) {
        final updatedTasks = stage.tasks.where((t) => t != task).toList();
        final updatedStage = stage.copyWith(tasks: updatedTasks);
        widget.project.stages[stageIndex] = updatedStage;
      }
    });
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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateStageOrTaskForm(context);
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
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.blue[100],
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(stage.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteStage(stage);
                              },
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: stage.tasks.length,
                            itemBuilder: (context, taskIndex) {
                              final task = stage.tasks[taskIndex];
                              return Card(
                                color: Colors.white,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ListTile(
                                  title: Text(task.name),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteTask(stage, task);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          const Padding(padding: EdgeInsets.all(15))
                        ],
                      ),
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

class CreateStageOrTaskForm extends StatefulWidget {
  final List<Stage> stages;
  final void Function(String) onCreateStage;
  final void Function(String, String) onCreateTask;

  const CreateStageOrTaskForm(
      {super.key,
      required this.stages,
      required this.onCreateStage,
      required this.onCreateTask});

  @override
  _CreateStageOrTaskFormState createState() => _CreateStageOrTaskFormState();
}

class _CreateStageOrTaskFormState extends State<CreateStageOrTaskForm> {
  final TextEditingController _nameController = TextEditingController();
  bool _isCreatingTask = false;
  String? selectedStage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isCreatingTask ? 'Crear Tarea' : 'Crear Etapa'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (_isCreatingTask)
            DropdownButton<String>(
              value: selectedStage,
              items: widget.stages.map((stage) {
                return DropdownMenuItem<String>(
                  value: stage.name,
                  child: Text(stage.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStage = value;
                });
              },
            ),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText:
                  _isCreatingTask ? 'Nombre de la tarea' : 'Nombre de la etapa',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text;
              if (_isCreatingTask) {
                final stageName = selectedStage ?? "sin nombre";
                widget.onCreateTask(name, stageName);
              } else {
                widget.onCreateStage(name);
              }

              _nameController.clear();
              Navigator.of(context).pop();
            },
            child: Text(_isCreatingTask ? 'Crear Tarea' : 'Crear Etapa'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              _isCreatingTask = !_isCreatingTask;
            });
          },
          child: Text(_isCreatingTask ? 'Crear Etapa' : 'Crear Tarea'),
        ),
      ],
    );
  }
}

class Project {
  final String name;
  final List<Stage> stages;

  Project({
    required this.name,
    List<Stage>? stages,
  }) : stages = stages ?? [];

  Project copyWith({String? name, String? description, List<Stage>? stages}) {
    return Project(
      name: name ?? this.name,
      stages: stages ?? this.stages,
    );
  }
}

class Stage {
  final String name;
  final List<Task> tasks;

  Stage({required this.name, List<Task>? tasks}) : tasks = tasks ?? [];

  Stage copyWith({List<Task>? tasks}) {
    return Stage(
      name: this.name,
      tasks: tasks ?? this.tasks,
    );
  }
}

class Task {
  final String name;

  Task({required this.name});
}
