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
      name: name,
      tasks: tasks ?? this.tasks,
    );
  }
}

class Task {
  final String name;
  String? responsable;

  Task({required this.name, this.responsable});
}
