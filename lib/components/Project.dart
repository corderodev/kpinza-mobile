class Project {
  String name;
  List<Stage> stages;

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
  String name;
  List<Task> tasks;

  Stage({required this.name, List<Task>? tasks}) : tasks = tasks ?? [];

  Stage copyWith({String? name, List<Task>? tasks}) {
    return Stage(
      name: name ?? this.name,
      tasks: tasks ?? this.tasks,
    );
  }
}

class Task {
  String name;
  String? responsable;
  String status;
  DateTime? startDate;
  DateTime? dueDate;

  Task({
    required this.name,
    this.responsable,
    this.status = 'Pendiente',
    this.startDate,
    this.dueDate,
  });
}
