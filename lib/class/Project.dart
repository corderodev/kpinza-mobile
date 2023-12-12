class Project {
  String id;
  String name;
  List<Stage> stages;
  String supervisor;
  List<Task>? tasks;

  Project({
    required this.id,
    required this.name,
    required this.supervisor,
    List<Stage>? stages,
    this.tasks,
  }) : stages = stages ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': name,
      'name': name,
      'supervisor': supervisor,
      'stages': stages.map((stage) => stage.toMap()).toList(),
      'tasks':
          tasks != null ? tasks!.map((task) => task.toMap()).toList() : null,
    };
  }

  Project copyWith({
    String? id,
    String? name,
    String? supervisor,
    List<Stage>? stages,
    List<Task>? tasks,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      supervisor: supervisor ?? this.supervisor,
      stages: stages ?? this.stages,
      tasks: tasks ?? this.tasks,
    );
  }

  static Project fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      name: map['name'],
      supervisor: map['supervisor'],
      stages: (map['stages'] as List<dynamic>?)
              ?.map((stage) => Stage.fromMap(stage))
              .toList() ??
          [],
      tasks: (map['tasks'] as List<dynamic>?)
              ?.map((task) => Task.fromMap(task))
              .toList() ??
          [],
    );
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      supervisor: json['supervisor'],
      stages: (json['stages'] as List<dynamic>?)
              ?.map((stage) => Stage.fromMap(stage))
              .toList() ??
          [],
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((task) => Task.fromMap(task))
              .toList() ??
          [],
    );
  }
}

class Stage {
  String id;
  String name;
  List<Task> tasks;

  Stage({required this.id, required this.name, List<Task>? tasks})
      : tasks = tasks ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': name,
      'name': name,
      'tasks': tasks.map((task) => task.toMap()).toList(),
    };
  }

  Stage copyWith({
    String? id,
    String? name,
    List<Task>? tasks,
  }) {
    return Stage(
      id: id ?? this.id,
      name: name ?? this.name,
      tasks: tasks ?? this.tasks,
    );
  }

  static Stage fromMap(Map<String, dynamic> map) {
    return Stage(
      id: map['id'],
      name: map['name'],
      tasks: (map['tasks'] as List<dynamic>?)
              ?.map((task) => Task.fromMap(task))
              .toList() ??
          [],
    );
  }
}

class Task {
  String id;
  String name;
  String? responsable;
  String status;
  DateTime? startDate;
  DateTime? dueDate;
  String estimatedTime;
  String realTime;
  DateTime? realStartDate;
  DateTime? realDueDate;
  String stageName;

  Task({
    required this.id,
    required this.name,
    this.responsable,
    this.status = 'Pendiente',
    this.startDate,
    this.dueDate,
    required this.estimatedTime,
    required this.realTime,
    this.realStartDate,
    this.realDueDate,
    required this.stageName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': name,
      'name': name,
      'responsable': responsable,
      'status': status,
      'startDate': startDate?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'estimatedTime': estimatedTime,
      'realTime': realTime,
      'realStartDate': realStartDate?.toIso8601String(),
      'realDueDate': realDueDate?.toIso8601String(),
      'stageName': stageName,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      responsable: map['responsable'],
      status: map['status'],
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      estimatedTime: map['estimatedTime'],
      realTime: map['realTime'],
      realStartDate: map['realStartDate'] != null
          ? DateTime.parse(map['realStartDate'])
          : null,
      realDueDate: map['realDueDate'] != null
          ? DateTime.parse(map['realDueDate'])
          : null,
      stageName: map['stageName'],
    );
  }
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
