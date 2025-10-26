import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_work/game/bloc/game_bloc.dart';
import 'package:what_is_my_work/game/game.dart';
import 'package:what_is_my_work/game/quiz_overlay.dart';
import 'package:what_is_my_work/login_screen.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => GameBloc(),
      child: const MaterialApp(home: AppNavigator()),
    ),
  );
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameLoaded) {
          return const GameHost();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class GameHost extends StatefulWidget {
  const GameHost({super.key});

  @override
  State<GameHost> createState() => _GameHostState();
}

class _GameHostState extends State<GameHost> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      context.read<GameBloc>().add(GameStateSaved());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      // This builder ensures that we only try to build the game screen
      // when the user profile and game data are fully loaded.
      builder: (context, state) {
        if (state is GameLoaded) {
          return Scaffold(
            body: Stack(
              children: [
                GameWidget.controlled(
                  gameFactory: () =>
                      WhatIsMyWorkGame(levels: state.profile.levels),
                  overlayBuilderMap: {
                    'TaskTimer': (context, game) =>
                        TaskTimerWidget(game: game as WhatIsMyWorkGame),
                    'GameStatus': (context, game) =>
                        GameStatusOverlay(game: game as WhatIsMyWorkGame),
                    'TaskDetails': (context, game) =>
                        TaskDetailsOverlay(game as WhatIsMyWorkGame),
                    'Quiz': (context, game) => QuizOverlay(
                      game: game as WhatIsMyWorkGame,
                      quiz: game.getCurrentQuiz()!,
                    ),
                    'QuizResult': (context, game) => QuizResultOverlay(
                      game: game as WhatIsMyWorkGame,
                      quiz: game.getCurrentQuiz()!,
                      userAnswers: game.userAnswers,
                    ),
                  },
                  initialActiveOverlays: const ['GameStatus'],
                ),
              ],
            ),
          );
        } else {
          // This should not be reached if the navigator is working correctly
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
