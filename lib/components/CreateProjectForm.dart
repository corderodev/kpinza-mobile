import 'package:flutter/material.dart';

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
