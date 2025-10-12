part of 'game_bloc.dart';

abstract class GameState {}

class GameInitial extends GameState {}

class GameLoaded extends GameState {
  final UserProfile profile;

  GameLoaded(this.profile);
}
