part of 'game_bloc.dart';

abstract class GameState {}

class GameInitial extends GameState {}

class GameLoaded extends GameState {
  final List<Level> levels;

  GameLoaded(this.levels);
}
