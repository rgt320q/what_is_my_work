import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:what_is_my_work/game/game_state_repository.dart';
import 'package:what_is_my_work/game/levels.dart';
import 'package:what_is_my_work/game/models.dart';
import 'package:what_is_my_work/models/user.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameStateRepository _repository;

  final SharedPreferences? _prefs;

  GameBloc({GameStateRepository? repository, SharedPreferences? prefs}) 
      : _repository = repository ?? GameStateRepository(),
        _prefs = prefs,
        super(GameInitial()) {

    on<LoginRequested>((event, emit) async {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      final savedProfile = await _repository.loadProfile(username: event.username);
      final user = User(username: event.username);
      
      await prefs.setString('user', User.encode(user));
      
      if (savedProfile != null) {
        emit(GameLoaded(savedProfile, user));
      } else {
        final newProfile = UserProfile(
          username: event.username,
          levels: buildLevels(),
        );
        emit(GameLoaded(newProfile, user));
      }
    });

    on<UpdateSettings>((event, emit) {
      if (state is GameLoaded) {
        final currentState = state as GameLoaded;
        final newProfile = UserProfile(username: currentState.profile.username, levels: event.levels);
        emit(GameLoaded(newProfile, currentState.user));
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
        final currentState = state as GameLoaded;
        emit(GameLoaded(UserProfile(username: profile.username, levels: newLevels), currentState.user));
      }
    });

    on<GamePauseRequested>((event, emit) {
      if (state is GameLoaded) {
        final currentState = state as GameLoaded;
        emit(GameLoaded(currentState.profile, currentState.user, isPaused: true));
      }
    });

    on<GameResumeRequested>((event, emit) {
      if (state is GameLoaded) {
        final currentState = state as GameLoaded;
        emit(GameLoaded(currentState.profile, currentState.user, isPaused: false));
      }
    });

    // Test/Debug Handlers
    on<ResetProgressRequested>((event, emit) async {
      if (state is GameLoaded) {
        final currentState = state as GameLoaded;
        // Create fresh levels with no progress
        final newProfile = UserProfile(
          username: currentState.profile.username,
          levels: buildLevels(),
        );
        await _repository.saveProfile(newProfile);
        emit(GameLoaded(newProfile, currentState.user));
      }
    });

    on<SetProgressRequested>((event, emit) async {
      if (state is GameLoaded) {
        final currentState = state as GameLoaded;
        final newLevels = buildLevels();
        
        // Create new profile with specified position
        final newProfile = UserProfile(
          username: currentState.profile.username,
          levels: newLevels,
        );
        
        await _repository.saveProfile(newProfile);
        emit(GameLoaded(newProfile, currentState.user));
      }
    });

    on<CompleteTasksUpToRequested>((event, emit) async {
      if (state is GameLoaded) {
        final currentState = state as GameLoaded;
        final newLevels = buildLevels();
        
        // Mark all tasks as completed up to the specified position
        for (int l = 0; l < newLevels.length; l++) {
          if (l > event.levelIndex) break;
          
          for (int s = 0; s < newLevels[l].stages.length; s++) {
            if (l == event.levelIndex && s > event.stageIndex) break;
            
            for (int t = 0; t < newLevels[l].stages[s].tasks.length; t++) {
              if (l == event.levelIndex && s == event.stageIndex && t >= event.taskIndex) break;
              
              newLevels[l].stages[s].tasks[t].isCompleted = true;
              newLevels[l].stages[s].tasks[t].startTime = DateTime.now().subtract(Duration(minutes: t + 1));
              newLevels[l].stages[s].tasks[t].endTime = DateTime.now().subtract(Duration(minutes: t));
            }
          }
        }
        
        final newProfile = UserProfile(
          username: currentState.profile.username,
          levels: newLevels,
        );
        
        await _repository.saveProfile(newProfile);
        emit(GameLoaded(newProfile, currentState.user));
      }
    });
  }
}
