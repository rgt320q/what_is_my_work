part of 'game_bloc.dart';

abstract class GameState {}

class GameInitial extends GameState {}

class GameLoaded extends GameState {
  final UserProfile profile;
  final User user;
  final bool isPaused;

  GameLoaded(this.profile, this.user, {this.isPaused = false});
}
