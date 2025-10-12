import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_work/game/game_state_repository.dart';
import 'package:what_is_my_work/game/levels.dart';
import 'package:what_is_my_work/game/models.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameStateRepository _repository;

  GameBloc({GameStateRepository? repository}) 
      : _repository = repository ?? GameStateRepository(),
        super(GameInitial()) {

    on<LoginRequested>((event, emit) async {
      final savedProfile = await _repository.loadProfile(username: event.username);
      if (savedProfile != null) {
        emit(GameLoaded(savedProfile));
      } else {
        final newProfile = UserProfile(
          username: event.username,
          levels: buildLevels(),
        );
        emit(GameLoaded(newProfile));
      }
    });

    on<UpdateSettings>((event, emit) {
      if (state is GameLoaded) {
        final currentProfile = (state as GameLoaded).profile;
        final newProfile = UserProfile(username: currentProfile.username, levels: event.levels);
        emit(GameLoaded(newProfile));
      }
    });

    on<GameStateSaved>((event, emit) async {
      if (state is GameLoaded) {
        await _repository.saveProfile((state as GameLoaded).profile);
      }
    });

    on<GameTaskCancelled>((event, emit) {
      if (state is GameLoaded) {
        final profile = (state as GameLoaded).profile;
        // Create a deep copy to ensure we're not mutating the original state directly
        final newLevels = profile.levels.map((l) => l.copyWith(
          stages: l.stages.map((s) => s.copyWith(
            tasks: s.tasks.map((t) => t.copyWith()).toList(),
          )).toList(),
        )).toList();

        for (var level in newLevels) {
          for (var stage in level.stages) {
            for (var task in stage.tasks) {
              if (task.startTime != null && !task.isCompleted) {
                task.startTime = null;
              }
            }
          }
        }
        emit(GameLoaded(UserProfile(username: profile.username, levels: newLevels)));
      }
    });
  }
}
