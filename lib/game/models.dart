enum LevelType { junior, senior, master }

class Task {
  final String name;
  final String description;
  int durationSeconds;
  String? documentationUrl;
  bool isCompleted;
  DateTime? startTime;
  DateTime? endTime;

  Task({
    required this.name,
    required this.description,
    required this.durationSeconds,
    this.documentationUrl,
    this.isCompleted = false,
    this.startTime,
    this.endTime,
  });

  Task copyWith({
    String? name,
    String? description,
    int? durationSeconds,
    String? documentationUrl,
    bool? isCompleted,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return Task(
      name: name ?? this.name,
      description: description ?? this.description,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      documentationUrl: documentationUrl ?? this.documentationUrl,
      isCompleted: isCompleted ?? this.isCompleted,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

class Stage {
  final int stageNumber;
  final List<Task> tasks;
  bool isCompleted;

  Stage({
    required this.stageNumber,
    required this.tasks,
    this.isCompleted = false,
  });

  Stage copyWith({
    int? stageNumber,
    List<Task>? tasks,
    bool? isCompleted,
  }) {
    return Stage(
      stageNumber: stageNumber ?? this.stageNumber,
      tasks: tasks ?? this.tasks,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class Level {
  final LevelType type;
  final List<Stage> stages;
  bool isCompleted;

  Level({
    required this.type,
    required this.stages,
    this.isCompleted = false,
  });

  Level copyWith({
    LevelType? type,
    List<Stage>? stages,
    bool? isCompleted,
  }) {
    return Level(
      type: type ?? this.type,
      stages: stages ?? this.stages,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class UserProfile {
  final List<Level> levels;

  UserProfile({required this.levels});
}
