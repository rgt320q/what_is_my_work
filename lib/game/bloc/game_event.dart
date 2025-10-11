part of 'game_bloc.dart';

abstract class GameEvent {}

class UpdateSettings extends GameEvent {
  final List<Level> levels;

  UpdateSettings(this.levels);
}
