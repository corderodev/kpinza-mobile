import 'package:flutter/material.dart';
import 'package:kpinza_mobile/components/Project.dart';

class CreateStageOrTaskForm extends StatefulWidget {
  final List<Stage> stages;
  final void Function(String) onCreateStage;
  final void Function(String, String, String?, String, DateTime?, DateTime?)
      onCreateTask;

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
  bool _isCreatingTask = false;
  String? selectedStage;
  String? selectedStatus;
  DateTime? selectedStartDate;
  DateTime? selectedDueDate;

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
          Visibility(
            visible: _isCreatingTask,
            child: TextFormField(
              controller: _responsableController,
              decoration: const InputDecoration(
                labelText: 'Responsable de la tarea',
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(4)),
          if (_isCreatingTask)
            Column(
              children: [
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
              ],
            ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text;
              final responsable = _responsableController.text;
              final status = selectedStatus ?? 'Pendiente';
              if (_isCreatingTask) {
                final stageName = selectedStage ?? "sin nombre";
                widget.onCreateTask(name, stageName, responsable, status,
                    selectedStartDate, selectedDueDate);
              } else {
                widget.onCreateStage(name);
              }
              _nameController.clear();
              _responsableController.clear();
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
