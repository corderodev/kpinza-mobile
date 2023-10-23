import 'package:flutter/material.dart';
import 'package:kpinza_mobile/components/CreateStageOrTaskForm.dart';
import 'package:kpinza_mobile/components/Project.dart';

class ProjectDetailScreen extends StatefulWidget {
  Project project;
  final void Function(Project) onDelete;
  final void Function(Project, String) changeProjectName;

  ProjectDetailScreen(
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

  void _saveName() {
    final newName = _nameController.text;
    widget.changeProjectName(widget.project, newName);
    setState(() {
      widget.project = widget.project.copyWith(name: newName);
      Navigator.pop(context);
    });
  }

  void _createStage(String stageName) {
    final newStage = Stage(name: stageName, tasks: []);
    setState(() {
      widget.project.stages.add(newStage);
    });
    Navigator.of(context).pop();
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

  void _createTask(
      String taskName, String stageName, String? responsable, String status) {
    final newTask =
        Task(name: taskName, responsable: responsable, status: status);
    final targetStage =
        widget.project.stages.firstWhere((s) => s.name == stageName);
    setState(() {
      targetStage.tasks.add(newTask);
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

  void _showCreateStageOrTaskForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateStageOrTaskForm(
          stages: widget.project.stages,
          onCreateStage: _createStage,
          onCreateTask: (taskName, stageName, responsable, status) {
            _createTask(taskName, stageName, responsable, status);
          },
        );
      },
    );
  }

  void _renameStage(Stage stage, String newName) {
    setState(() {
      final stageIndex = widget.project.stages.indexOf(stage);
      if (stageIndex != -1) {
        widget.project.stages[stageIndex] = stage.copyWith(name: newName);
      }
    });
  }

  void _showEditStageName(Stage stage) {
    TextEditingController stageNameController =
        TextEditingController(text: stage.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Nombre de Etapa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: stageNameController,
                decoration:
                    const InputDecoration(labelText: 'Nuevo nombre de etapa'),
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
                _renameStage(stage, stageNameController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDetails(Stage sourceStage, Task task) {
    TextEditingController taskNameController =
        TextEditingController(text: task.name);
    TextEditingController responsableController =
        TextEditingController(text: task.responsable ?? "");
    String selectedStatus = task.status;
    String selectedStage = sourceStage.name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Detalles de la Tarea'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: taskNameController,
                    decoration:
                        const InputDecoration(labelText: 'Nombre de la Tarea'),
                  ),
                  TextFormField(
                    controller: responsableController,
                    decoration: const InputDecoration(labelText: 'Responsable'),
                  ),
                  DropdownButton<String>(
                    value: selectedStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue!;
                      });
                    },
                    items: <String>['Pendiente', 'En Progreso', 'Completada']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: selectedStage,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedStage = newValue;
                        });
                      }
                    },
                    items: widget.project.stages.map((Stage stage) {
                      return DropdownMenuItem<String>(
                        value: stage.name,
                        child: Text(stage.name),
                      );
                    }).toList(),
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
                    task.name = taskNameController.text;
                    task.responsable = responsableController.text;
                    task.status = selectedStatus;

                    Stage targetStage = widget.project.stages
                        .firstWhere((s) => s.name == selectedStage);

                    _moveTask(sourceStage, task, targetStage);

                    Navigator.of(context).pop();
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _moveTask(Stage sourceStage, Task task, Stage targetStage) {
    setState(() {
      sourceStage.tasks.remove(task);
      targetStage.tasks.add(task);
    });
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
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(stage.name),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditStageName(stage);
                                  },
                                ),
                              ],
                            ),
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
                                child: GestureDetector(
                                  onTap: () {
                                    _showEditTaskDetails(stage, task);
                                  },
                                  child: ListTile(
                                    title: Text(task.name),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteTask(stage, task);
                                      },
                                    ),
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
