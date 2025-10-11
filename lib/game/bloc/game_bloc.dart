import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_work/game/levels.dart';
import 'package:what_is_my_work/game/models.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial()) {
    on<GameStarted>((event, emit) {
      final levels = buildLevels();
      emit(GameLoaded(levels));
    });

    on<UpdateSettings>((event, emit) {
      emit(GameLoaded(event.levels));
    });

    on<GameTaskCancelled>((event, emit) {
      if (state is GameLoaded) {
        final levels = (state as GameLoaded).levels;
        // This is a simplified logic. In a real app, you'd need to know the current task index.
        // For this example, we assume we can find the active task.
        for (var level in levels) {
          for (var stage in level.stages) {
            for (var task in stage.tasks) {
              if (task.startTime != null && !task.isCompleted) {
                task.startTime = null;
              }
            }
          }
        }
        emit(GameLoaded(List<Level>.from(levels)));
      }
    });
  }
}
