// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kpinza_mobile/components/CreateStageOrTaskForm.dart';
import 'package:kpinza_mobile/class/Project.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kpinza_mobile/utils/firebase_utils.dart';
import 'package:kpinza_mobile/screens/AuthScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class LocalStorage {
  static Future<void> saveStagesLocally(List<String> stages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('stages', stages);
  }

  static Future<List<String>> getStagesLocally() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('stages') ?? [];
  }
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _editedSupervisor = '';
  String? selectedStage;

  List<Stage> stagesFromDatabase = [];
  List<Task> tasksFromDatabase = [];

  @override
  void initState() {
    super.initState();
    obtenerDetallesProyecto();
  }

  void obtenerDetallesProyecto() async {
    try {
      String userUid = UserGlobal.uid ?? '';
      dynamic fetchedProjectData =
          await FirebaseUtils.obtenerProyectoPorIdDesdeFirebase(
              userUid, widget.project.id);

      if (fetchedProjectData != null &&
          fetchedProjectData is Map<String, dynamic>) {
        Project fetchedProject = Project.fromJson(fetchedProjectData);

        List<Stage> stagesFromDatabase =
            await FirebaseUtils.getStagesFromDatabase(
                userUid, widget.project.id);

        Map<String, List<Task>> tasksByStage = {};
        for (var stage in stagesFromDatabase) {
          List<Task> tasks = await FirebaseUtils.getTasksFromDatabase(
              userUid, widget.project.id, stage.name);
          tasksByStage[stage.name] = tasks;
        }

        setState(() {
          widget.project = fetchedProject.copyWith(stages: stagesFromDatabase);

          for (var stage in widget.project.stages) {
            if (tasksByStage.containsKey(stage.name)) {
              stage.tasks = tasksByStage[stage.name] ?? [];
            }
          }
        });

        _saveStagesLocally(
            stagesFromDatabase.map((stage) => stage.name).toList());
      }
    } catch (e) {
      print('Error al obtener detalles del proyecto: $e');
      _getStagesLocally();
    }
  }

  void _saveStagesLocally(List<String> stages) async {
    await LocalStorage.saveStagesLocally(stages);
  }

  void _getStagesLocally() async {
    List<String> stages = await LocalStorage.getStagesLocally();
    List<Stage> localStages = stages
        .map((stageName) => Stage(id: stageName, name: stageName, tasks: []))
        .toList();

    setState(() {
      widget.project = widget.project.copyWith(stages: localStages);
    });
  }

  void _editSupervisor() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Supervisor'),
          content: TextFormField(
            initialValue: _editedSupervisor,
            onChanged: (value) {
              setState(() {
                _editedSupervisor = value;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nombre del Supervisor',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  String userUid = UserGlobal.uid ?? '';
                  await FirebaseUtils.updateProjectSupervisor(
                      userUid, widget.project.id, _editedSupervisor);
                  setState(() {
                    widget.project =
                        widget.project.copyWith(supervisor: _editedSupervisor);
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error al actualizar el supervisor: $e');
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _editedSupervisor = widget.project.supervisor;
      });
    });
  }

  void _saveName() async {
    final newName = _nameController.text;
    try {
      String userUid = UserGlobal.uid ?? '';
      await FirebaseUtils.updateProjectName(
          userUid, widget.project.id, newName);
      setState(() {
        widget.project = widget.project.copyWith(name: newName);
        Navigator.pop(context);
      });
    } catch (e) {
      print('Error al guardar el nombre del proyecto: $e');
    }
  }

  void _createStage(String stageName) async {
    try {
      final newStage = Stage(id: stageName, name: stageName, tasks: []);
      String userUid = UserGlobal.uid ?? '';
      String projectId = widget.project.id;

      await FirebaseUtils.saveStage(userUid, projectId, newStage);

      setState(() {
        widget.project.stages.add(newStage);
      });
    } catch (e) {
      print('Error al guardar la nueva etapa: $e');
    }
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

  String getStageIdByName(String stageName) {
    return stageName;
  }

  void _createTask(
    String taskName,
    String stageName,
    String? responsable,
    String status,
    DateTime? selectedStartDate,
    DateTime? selectedDueDate,
    String estimatedTime,
    String realTime,
    DateTime? selectedRealStartDate,
    DateTime? selectedRealDueDate,
  ) async {
    final newTask = Task(
      id: taskName,
      name: taskName,
      responsable: responsable,
      status: status,
      startDate: selectedStartDate,
      dueDate: selectedDueDate,
      estimatedTime: estimatedTime,
      realTime: realTime,
      realStartDate: selectedRealStartDate,
      realDueDate: selectedRealDueDate,
      stageName: getStageIdByName(stageName),
    );

    try {
      String? userUid = UserGlobal.uid;

      if (userUid != null) {
        await FirebaseUtils.saveTask(
          userUid,
          widget.project.id,
          stageName,
          newTask,
        );

        final targetStage =
            widget.project.stages.firstWhere((s) => s.name == stageName);
        setState(() {
          targetStage.tasks.add(newTask);
        });
      } else {
        print('UserUid es nulo. No se puede guardar la tarea.');
      }
    } catch (e) {
      print('Error al guardar la nueva tarea: $e');
    }
  }

  void _deleteTask(Stage stage, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Tarea'),
          content: const Text('¿Seguro que quieres eliminar esta tarea?'),
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
                  _removeTask(stage, task);
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

  void _removeTask(Stage stage, Task task) {
    final updatedTasks = stage.tasks.where((t) => t != task).toList();
    setState(() {
      stage.tasks = updatedTasks;
    });
  }

  void _showCreateStageOrTaskForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateStageOrTaskForm(
          stages: widget.project.stages,
          onCreateStage: _createStage,
          onCreateTask: (
            taskName,
            stageName,
            responsable,
            selectedStartDate,
            selectedDueDate,
            estimatedTime,
          ) {
            _createTask(
              taskName,
              stageName,
              responsable,
              'Pendiente', // Status por defecto
              selectedStartDate,
              selectedDueDate,
              estimatedTime,
              '', // realTime por defecto
              null, // selectedRealStartDate por defecto
              null, // selectedRealDueDate por defecto
            );
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
    DateTime? selectedStartDate = task.startDate;
    DateTime? selectedDueDate = task.dueDate;
    String estimatedTime = task.estimatedTime;
    String realTime = task.realTime;
    DateTime? realStartDate = task.realStartDate;
    DateTime? realDueDate = task.realDueDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Detalles de la Tarea'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: taskNameController,
                      decoration: const InputDecoration(
                          labelText: 'Nombre de la Tarea'),
                    ),
                    TextFormField(
                      controller: responsableController,
                      decoration:
                          const InputDecoration(labelText: 'Responsable'),
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
                    const Padding(padding: EdgeInsets.all(2)),
                    const Text('Fecha de Inicio:'),
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedStartDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            selectedStartDate = selectedDate;
                          });
                        }
                      },
                      child: Text(selectedStartDate != null
                          ? selectedStartDate!
                              .toLocal()
                              .toString()
                              .split(' ')[0]
                          : 'Seleccionar fecha'),
                    ),
                    const Text('Fecha de Entrega:'),
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDueDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            selectedDueDate = selectedDate;
                          });
                        }
                      },
                      child: Text(selectedDueDate != null
                          ? selectedDueDate!.toLocal().toString().split(' ')[0]
                          : 'Seleccionar fecha'),
                    ),
                    const Padding(padding: EdgeInsets.all(2)),
                    const Text('Tiempo Estimado (horas):'),
                    TextFormField(
                      initialValue: estimatedTime,
                      onChanged: (value) {
                        estimatedTime = value;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const Padding(padding: EdgeInsets.all(2)),
                    const Text('Tiempo Real (horas):'),
                    TextFormField(
                      initialValue: realTime,
                      onChanged: (value) {
                        realTime = value;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const Padding(padding: EdgeInsets.all(4)),
                    const Text('Fecha de Inicio Real:'),
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: realStartDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            realStartDate = selectedDate;
                            if (realDueDate != null &&
                                realStartDate!.isAfter(realDueDate!)) {
                              realDueDate = realStartDate;
                            }
                          });
                        }
                      },
                      child: Text(
                        realStartDate != null
                            ? realStartDate!.toLocal().toString().split(' ')[0]
                            : 'Seleccionar fecha',
                      ),
                    ),
                    const Text('Fecha de Entrega Real:'),
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: realDueDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            if (realStartDate != null &&
                                selectedDate.isAfter(realStartDate!) &&
                                selectedDate.isAfter(DateTime.now())) {
                              realDueDate = selectedDate;
                            } else {
                              // Mostrar mensaje de error si la fecha es inválida.
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'Por favor, selecciona una fecha válida.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          });
                        }
                      },
                      child: Text(
                        realDueDate != null
                            ? realDueDate!.toLocal().toString().split(' ')[0]
                            : 'Seleccionar fecha',
                      ),
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
                    task.startDate = selectedStartDate;
                    task.dueDate = selectedDueDate;
                    task.estimatedTime = estimatedTime;
                    task.realTime = realTime;
                    task.realStartDate = realStartDate;
                    task.realDueDate = realDueDate;

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

  void _generateBriefHistory() {
    int totalTasks = 0;
    int completedTasks = 0;
    int inProgressTasks = 0;
    int pendingTasks = 0;

    String? userUid = UserGlobal.uid;

    for (var stage in widget.project.stages) {
      totalTasks += stage.tasks.length;
      for (var task in stage.tasks) {
        if (task.status == 'Completada') {
          completedTasks++;
        } else if (task.status == 'En Progreso') {
          inProgressTasks++;
        } else {
          pendingTasks++;
        }
      }
    }

    DatabaseReference statusReference = FirebaseDatabase.instance
        .ref()
        .child('users/$userUid/projects/${widget.project.id}/brief');

    statusReference.set({
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'inProgressTasks': inProgressTasks,
      'pendingTasks': pendingTasks,
    });

    try {
      if (userUid != null) {
        FirebaseUtils.saveBrief(userUid, widget.project.id, totalTasks,
            completedTasks, inProgressTasks, pendingTasks);
      }
      // Mostrar el diálogo con el estado del proyecto
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Estado del proyecto'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Tareas Totales: $totalTasks'),
                const Padding(
                  padding: EdgeInsets.all(6.0),
                ),
                Text('Tareas Completadas: $completedTasks'),
                const Padding(
                  padding: EdgeInsets.all(6.0),
                ),
                Text('Tareas en Progreso: $inProgressTasks'),
                const Padding(
                  padding: EdgeInsets.all(6.0),
                ),
                Text('Tareas Pendientes: $pendingTasks'),
              ],
            ),
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
    } catch (e) {
      print('Error al guardar el brief en la base de datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _generateBriefHistory,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
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
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Supervisor: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.project.supervisor,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editSupervisor();
                  },
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
            ),
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
                          const Padding(padding: EdgeInsets.all(15)),
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
