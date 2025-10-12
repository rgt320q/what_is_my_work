enum LevelType { junior, senior, master }

class Task {
  final String name;
  final String description;
  int durationSeconds;
  String? taskUrl;
  String? explanationUrl;
  bool isCompleted;
  DateTime? startTime;
  DateTime? endTime;
  final List<Question> questions;

  Task({
    required this.name,
    required this.description,
    required this.durationSeconds,
    this.taskUrl,
    this.explanationUrl,
    this.isCompleted = false,
    this.startTime,
    this.endTime,
    this.questions = const [],
  });

  Task copyWith({
    String? name,
    String? description,
    int? durationSeconds,
    String? taskUrl,
    String? explanationUrl,
    bool? isCompleted,
    DateTime? startTime,
    DateTime? endTime,
    List<Question>? questions,
  }) {
    return Task(
      name: name ?? this.name,
      description: description ?? this.description,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      taskUrl: taskUrl ?? this.taskUrl,
      explanationUrl: explanationUrl ?? this.explanationUrl,
      isCompleted: isCompleted ?? this.isCompleted,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      questions: questions ?? this.questions,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      description: json['description'],
      durationSeconds: json['durationSeconds'],
      taskUrl: json['taskUrl'],
      explanationUrl: json['explanationUrl'],
      isCompleted: json['isCompleted'],
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      questions: (json['questions'] as List).map((e) => Question.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'durationSeconds': durationSeconds,
      'taskUrl': taskUrl,
      'explanationUrl': explanationUrl,
      'isCompleted': isCompleted,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'questions': questions.map((e) => e.toJson()).toList(),
    };
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

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      stageNumber: json['stageNumber'],
      tasks: (json['tasks'] as List).map((e) => Task.fromJson(e)).toList(),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stageNumber': stageNumber,
      'tasks': tasks.map((e) => e.toJson()).toList(),
      'isCompleted': isCompleted,
    };
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

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      type: LevelType.values.firstWhere((e) => e.name == json['type']),
      stages: (json['stages'] as List).map((e) => Stage.fromJson(e)).toList(),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'stages': stages.map((e) => e.toJson()).toList(),
      'isCompleted': isCompleted,
    };
  }
}

class UserProfile {
  final String username;
  final List<Level> levels;

  UserProfile({required this.username, required this.levels});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'],
      levels: (json['levels'] as List).map((e) => Level.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'levels': levels.map((e) => e.toJson()).toList(),
    };
  }
}

class Question {
  final String text;
  final List<String> options;
  final int correctOptionIndex;
  final String relatedTaskName;

  Question({
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    required this.relatedTaskName,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['text'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctOptionIndex'],
      relatedTaskName: json['relatedTaskName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'relatedTaskName': relatedTaskName,
    };
  }
}

class Quiz {
  final int stageNumber;
  final LevelType levelType;
  final List<Question> questions;

  Quiz({
    required this.stageNumber,
    required this.levelType,
    required this.questions,
  });
}
