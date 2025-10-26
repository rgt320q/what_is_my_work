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

class UserProfileUpdated extends GameEvent {
  final UserProfile updatedProfile;

  UserProfileUpdated(this.updatedProfile);
}
