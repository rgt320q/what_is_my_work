import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_work/game/bloc/game_bloc.dart';
import 'package:what_is_my_work/game/game.dart'
    hide TaskTimerWidget, GameStatusOverlay, TaskDetailsOverlay;
import 'package:what_is_my_work/game/overlays/quiz_overlay.dart';
import 'package:what_is_my_work/game/overlays/quiz_result_overlay.dart';
import 'package:what_is_my_work/game/overlays/task_details_overlay.dart';
import 'package:what_is_my_work/game/overlays/task_timer_widget.dart';
import 'package:what_is_my_work/game/overlays/game_status_overlay.dart';
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
  bool _userInfoShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Show user info after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_userInfoShown && mounted) {
        final state = context.read<GameBloc>().state;
        if (state is GameLoaded) {
          _showUserInfo(state);
          _userInfoShown = true;
        }
      }
    });
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

  void _showUserInfo(GameLoaded state) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          'Hoşgeldin ${state.user.username}! Giriş: ${state.user.loginTime.toLocal().toString().split('.')[0]}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green.shade700,
        leading: const Icon(Icons.check_circle, color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('Tamam', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    // Auto-hide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameLoaded) {
          return Scaffold(
            body: GameWidget.controlled(
              gameFactory: () => WhatIsMyWorkGame(levels: state.profile.levels),
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
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
