class Project {
  String name;
  List<Stage> stages;
  String supervisor;

  Project({
    required this.name,
    required this.supervisor,
    List<Stage>? stages,
  }) : stages = stages ?? [];

  Project copyWith(
      {String? name,
      String? description,
      String? supervisor,
      List<Stage>? stages}) {
    return Project(
      name: name ?? this.name,
      supervisor: supervisor ?? this.supervisor,
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
  String estimatedTime;
  String realTime;
  DateTime? realStartDate;
  DateTime? realDueDate;

  Task({
    required this.name,
    this.responsable,
    this.status = 'Pendiente',
    this.startDate,
    this.dueDate,
    required this.estimatedTime,
    required this.realTime,
    this.realStartDate,
    this.realDueDate,
  });
}

class Brief {
  int totalTasks;
  int completedTasks;
  int inProgressTasks;
  int pendingTasks;

  Brief({
    required this.totalTasks,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.pendingTasks,
  });
}
