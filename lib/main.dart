import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_work/game/bloc/game_bloc.dart';
import 'package:what_is_my_work/game/game.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => GameBloc()..add(GameStarted()),
      child: MaterialApp(
        home: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is GameLoaded) {
              return GameWidget.controlled(
                gameFactory: () => WhatIsMyWorkGame(levels: state.levels),
                overlayBuilderMap: {
                  'TaskTimer': (context, game) =>
                      TaskTimerWidget(game: game as WhatIsMyWorkGame),
                  'GameStatus': (context, game) =>
                      GameStatusOverlay(game: game as WhatIsMyWorkGame),
                  'TaskDetails': (context, game) =>
                      TaskDetailsOverlay(game as WhatIsMyWorkGame),
                },
                initialActiveOverlays: const ['GameStatus'],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    ),
  );
}