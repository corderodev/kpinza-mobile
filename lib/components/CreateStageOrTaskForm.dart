import 'package:flutter/material.dart';
import 'package:kpinza_mobile/class/Project.dart';

class CreateStageOrTaskForm extends StatefulWidget {
  final List<Stage> stages;
  final void Function(String) onCreateStage;
  final void Function(
    String,
    String,
    String?,
    DateTime?,
    DateTime?,
    String,
  ) onCreateTask;

  const CreateStageOrTaskForm({
    Key? key,
    required this.stages,
    required this.onCreateStage,
    required this.onCreateTask,
  }) : super(key: key);

  @override
  _CreateStageOrTaskFormState createState() => _CreateStageOrTaskFormState();
}

class _CreateStageOrTaskFormState extends State<CreateStageOrTaskForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _responsableController = TextEditingController();
  final TextEditingController _estimatedTimeController =
      TextEditingController();
  bool _isCreatingTask = false;
  String? selectedStage;
  DateTime? selectedStartDate;
  DateTime? selectedDueDate;
  String selectedStatus = 'Pendiente';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isCreatingTask ? 'Crear Tarea' : 'Crear Etapa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: _isCreatingTask
                    ? 'Nombre de la tarea'
                    : 'Nombre de la etapa',
              ),
            ),
            if (_isCreatingTask)
              DropdownButtonFormField<String>(
                value: selectedStage,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStage = newValue;
                  });
                },
                items: widget.stages.map((Stage stage) {
                  return DropdownMenuItem<String>(
                    value: stage.name,
                    child: Text(stage.name),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Seleccionar Etapa',
                ),
              ),
            if (_isCreatingTask)
              Column(
                children: [
                  TextFormField(
                    controller: _responsableController,
                    decoration: const InputDecoration(
                      labelText: 'Responsable',
                    ),
                  ),
                  const SizedBox(height: 16),
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
                        ? selectedStartDate!.toLocal().toString().split(' ')[0]
                        : 'Seleccionar fecha'),
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _estimatedTimeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Tiempo Estimado (horas)',
                    ),
                  ),
                ],
              ),
            ElevatedButton(
              onPressed: () {
                if (_isCreatingTask) {
                  final name = _nameController.text;
                  final responsable = _responsableController.text;
                  final estimatedTime = _estimatedTimeController.text;

                  if (selectedStage != null) {
                    widget.onCreateTask(
                      name,
                      selectedStage!,
                      responsable.isNotEmpty ? responsable : null,
                      selectedStartDate,
                      selectedDueDate,
                      estimatedTime,
                    );

                    _nameController.clear();
                    _responsableController.clear();
                    _estimatedTimeController.clear();
                    selectedStage = null;
                    selectedStartDate = null;
                    selectedDueDate = null;
                    selectedStatus = 'Pendiente';
                    Navigator.of(context).pop();
                  } else {
                    print('Por favor, selecciona una etapa');
                  }
                } else {
                  final name = _nameController.text;
                  widget.onCreateStage(name);
                  _nameController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text(_isCreatingTask ? 'Crear Tarea' : 'Crear Etapa'),
            ),
          ],
        ),
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
