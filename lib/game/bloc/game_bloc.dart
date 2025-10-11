import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_work/game/models.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial()) {
    on<UpdateSettings>((event, emit) {
      emit(GameLoaded(event.levels));
    });
  }
}
