part of 'game_bloc.dart';

abstract class GameEvent {}

class GameStarted extends GameEvent {}

class UpdateSettings extends GameEvent {
  final List<Level> levels;

  UpdateSettings(this.levels);
}

class GameTaskCancelled extends GameEvent {}

class GameStateSaved extends GameEvent {}

class LoginRequested extends GameEvent {
  final String username;

  LoginRequested(this.username);
}

class GamePauseRequested extends GameEvent {}

class GameResumeRequested extends GameEvent {}

// Test/Debug Events
class ResetProgressRequested extends GameEvent {}

class SetProgressRequested extends GameEvent {
  final int levelIndex;
  final int stageIndex;
  final int taskIndex;

  SetProgressRequested({
    required this.levelIndex,
    required this.stageIndex,
    required this.taskIndex,
  });
}

class CompleteTasksUpToRequested extends GameEvent {
  final int levelIndex;
  final int stageIndex;
  final int taskIndex;

  CompleteTasksUpToRequested({
    required this.levelIndex,
    required this.stageIndex,
    required this.taskIndex,
  });
}
