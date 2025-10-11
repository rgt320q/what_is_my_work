import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what_is_my_work/game/bloc/game_bloc.dart';
import 'models.dart';
import 'package:what_is_my_work/settings_screen.dart';

Future<void> _launchUrl(String? urlString, BuildContext context) async {
  if (urlString != null && urlString.isNotEmpty) {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // ignore: use_build_context_synchronously
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $urlString')),
      );
    }
  }
}

class WhatIsMyWorkGame extends FlameGame with HasGameReference {
  final List<Level> levels;
  int currentLevel = 0;
  int currentStage = 0;
  int currentTask = 0;
  TimerComponent? timerComponent;
  bool isTaskActive = false;

  bool isUiOverlayActive = false;

  WhatIsMyWorkGame({required this.levels});

  int get totalSpentTime {
    int total = 0;
    for (var level in levels) {
      for (var stage in level.stages) {
        for (var task in stage.tasks) {
          if (task.isCompleted) {
            total += task.durationSeconds;
          }
        }
      }
    }
    return total;
  }

  void cancelTask(BuildContext context) {
    isTaskActive = false;
    isUiOverlayActive = false;
    context.read<GameBloc>().add(GameTaskCancelled());
    overlays.remove('TaskTimer');
    overlays.add('GameStatus');
  }

  @override
  Future<void> onLoad() async {
    add(_buildTaskComponent());
    isUiOverlayActive = true;
  }

  PositionComponent _buildTaskComponent() {
    final task = getCurrentTask();
    return TaskComponent(
      task: task,
      onStart: startTask,
      onComplete: completeTask,
      isActive: isTaskActive,
      game: this,
    );
  }

  Task getCurrentTask() {
    return levels[currentLevel].stages[currentStage].tasks[currentTask];
  }

  void startTask() {
    if (isTaskActive) return;
    isTaskActive = true;
    isUiOverlayActive = true; // Keep UI overlay flag active for timer
    final task = getCurrentTask();
    task.startTime = DateTime.now();
    timerComponent = TimerComponent(
      period: task.durationSeconds.toDouble(),
      removeOnFinish: true,
      onTick: () {
        // The timer component will automatically handle completion,
        // but we can add a manual complete call if needed.
      },
    );
    add(timerComponent!);
    overlays.add('TaskTimer');
  }

  void completeTask() {
    if (!isTaskActive) return;
    isTaskActive = false;
    isUiOverlayActive = false; // UI is done, back to game world
    final task = getCurrentTask();
    task.isCompleted = true;
    task.endTime = DateTime.now();
    overlays.remove('TaskTimer');
    advanceTask();
  }

  void advanceTask() {
    final stage = levels[currentLevel].stages[currentStage];
    if (currentTask < stage.tasks.length - 1) {
      currentTask++;
    } else if (currentStage < levels[currentLevel].stages.length - 1) {
      currentStage++;
      currentTask = 0;
    } else if (currentLevel < levels.length - 1) {
      currentLevel++;
      currentStage = 0;
      currentTask = 0;
    } else {
      // Oyun bitti
      isUiOverlayActive = true;
      overlays.add('GameCompleted');
      return;
    }
    // Yeni görevi yükle
    children.whereType<TaskComponent>().forEach(remove);
    add(_buildTaskComponent());
    // After advancing, show the main status screen again
    overlays.add('GameStatus');
    isUiOverlayActive = true;
  }
}

extension WhatIsMyWorkGameExtension on WhatIsMyWorkGame {
  int? get remainingTaskSeconds {
    if (!isTaskActive) return null;
    final task = getCurrentTask();
    if (task.startTime == null) return null;
    final elapsed = DateTime.now().difference(task.startTime!).inSeconds;
    final remaining = task.durationSeconds - elapsed;
    return remaining;
  }
}

class TaskComponent extends PositionComponent with TapCallbacks {
  final Task task;
  final void Function() onStart;
  final void Function() onComplete;
  final bool isActive;
  final WhatIsMyWorkGame game;

  TaskComponent({
    required this.task,
    required this.onStart,
    required this.onComplete,
    required this.isActive,
    required this.game,
  });

  @override
  Future<void> onLoad() async {
    size = Vector2(300, 200);
    position = Vector2(50, 100);
  }

  @override
  void render(Canvas canvas) {
    if (game.isUiOverlayActive) {
      // Don't render if a UI overlay is active
      return;
    }
    super.render(canvas);
    final paint = Paint()..color = isActive ? const Color(0xFFB3E5FC) : const Color(0xFFE0E0E0);
    canvas.drawRect(size.toRect(), paint);
    final textStyle = const TextStyle(fontSize: 18, color: Color(0xFF212121));
    final tpName = TextPainter(
      text: TextSpan(text: task.name, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.x - 20);
    tpName.paint(canvas, const Offset(10, 10));
    final tpDesc = TextPainter(
      text: TextSpan(text: task.description, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.x - 20);
    tpDesc.paint(canvas, const Offset(10, 40));
    final tpStatus = TextPainter(
      text: TextSpan(
        text: isActive ? 'Görev devam ediyor...' : 'Başlatmak için tıkla',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.x - 20);
    tpStatus.paint(canvas, const Offset(10, 80));
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!isActive && !game.isUiOverlayActive) {
      onStart();
    }
  }
}

class GameStatusOverlay extends StatelessWidget {
  final WhatIsMyWorkGame game;
  const GameStatusOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameLoaded) {
          game.isUiOverlayActive = true; // Mark UI as active
          final currentLevel = game.levels[game.currentLevel];
          final currentStage = game.currentStage;
          final currentTask = game.currentTask;
          final currentTaskObj = currentLevel.stages[currentStage].tasks[currentTask];
          return SafeArea(
            child: Container(
              color: Colors.black.withOpacity(0.7),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Uzmanlık: \t\t${currentLevel.type.name.toUpperCase()}',
                        style: const TextStyle(fontSize: 18, color: Colors.yellow, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Toplam Süre: ${game.totalSpentTime}s',
                        style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: [
                        for (int l = 0; l < game.levels.length; l++) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Seviye: ${game.levels[l].type.name.toUpperCase()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: l == game.currentLevel ? Colors.greenAccent : Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          for (int s = 0; s < game.levels[l].stages.length; s++) ...[
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0, top: 2.0, bottom: 2.0),
                              child: Text(
                                'Kademe ${game.levels[l].stages[s].stageNumber}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: (l == game.currentLevel && s == currentStage) ? Colors.lightBlueAccent : Colors.white70,
                                ),
                              ),
                            ),
                            for (int t = 0; t < game.levels[l].stages[s].tasks.length; t++) ...[
                              Padding(
                                padding: const EdgeInsets.only(left: 28.0, bottom: 2),
                                child: Row(
                                  children: [
                                    Icon(
                                      game.levels[l].stages[s].tasks[t].isCompleted
                                          ? Icons.check_circle
                                          : (l == game.currentLevel && s == currentStage && t == currentTask)
                                              ? Icons.play_circle_fill
                                              : Icons.radio_button_unchecked,
                                      color: game.levels[l].stages[s].tasks[t].isCompleted
                                          ? Colors.green
                                          : (l == game.currentLevel && s == currentStage && t == currentTask)
                                              ? Colors.orange
                                              : Colors.grey,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        game.levels[l].stages[s].tasks[t].name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: game.levels[l].stages[s].tasks[t].isCompleted
                                              ? Colors.greenAccent
                                              : Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (game.levels[l].stages[s].tasks[t].taskUrl != null)
                                      IconButton(
                                        icon: const Icon(Icons.work, color: Colors.blue, size: 18),
                                        onPressed: () => _launchUrl(game.levels[l].stages[s].tasks[t].taskUrl, context),
                                      ),
                                    if (game.levels[l].stages[s].tasks[t].explanationUrl != null)
                                      IconButton(
                                        icon: const Icon(Icons.help_outline, color: Colors.yellow, size: 18),
                                        onPressed: () => _launchUrl(game.levels[l].stages[s].tasks[t].explanationUrl, context),
                                      ),
                                    if (!game.levels[l].stages[s].tasks[t].isCompleted)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          '${game.levels[l].stages[s].tasks[t].durationSeconds}s',
                                          style: const TextStyle(color: Colors.yellow, fontSize: 12),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ],
                      ],
                    ),
                  ),
                  if (!currentTaskObj.isCompleted && !game.isTaskActive)
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          game.overlays.remove('GameStatus');
                          game.overlays.add('TaskDetails');
                        },
                        child: const Text('Görevi Başlat'),
                      ),
                    ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class TaskTimerWidget extends StatefulWidget {
  final WhatIsMyWorkGame game;
  const TaskTimerWidget({super.key, required this.game});

  @override
  State<TaskTimerWidget> createState() => _TaskTimerWidgetState();
}

class _TaskTimerWidgetState extends State<TaskTimerWidget> {
  late int? _remaining;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _remaining = widget.game.remainingTaskSeconds;
    _ticker = Ticker(_onTick)..start();
  }

  void _onTick(Duration _) {
    final newRemaining = widget.game.remainingTaskSeconds;
    if (newRemaining != _remaining) {
      setState(() {
        _remaining = newRemaining;
      });
    }
    if ((newRemaining ?? 1) <= 0) {
      _ticker.stop();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _finishTask() {
    widget.game.completeTask();
    // completeTask now handles removing the timer overlay and advancing state
  }

  @override
  Widget build(BuildContext context) {
    widget.game.isUiOverlayActive = true; // Mark UI as active
    final currentTask = widget.game.getCurrentTask();
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: (_remaining ?? 1) > 0
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Görev Zamanlayıcı',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _remaining.toString(),
                          key: ValueKey('timer_$_remaining'),
                          style: const TextStyle(color: Colors.yellow, fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          ' sn',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      key: const ValueKey('finish_button'),
                      onPressed: _finishTask,
                      child: const Text('Görevi Bitir'),
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentTask.taskUrl != null)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.work),
                    label: const Text('Görev Linki'),
                    onPressed: () => _launchUrl(currentTask.taskUrl, context),
                  ),
                const SizedBox(width: 10),
                if (currentTask.explanationUrl != null)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.help_outline),
                    label: const Text('Yardım'),
                    onPressed: () => _launchUrl(currentTask.explanationUrl, context),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if ((_remaining ?? 1) > 0)
              ElevatedButton(
                onPressed: () => widget.game.cancelTask(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('İptal'),
              )
          ],
        ),
      ),
    );
  }
}

class TaskDetailsOverlay extends StatelessWidget {
  const TaskDetailsOverlay(this.game, {super.key});

  final WhatIsMyWorkGame game;

  @override
  Widget build(BuildContext context) {
    game.isUiOverlayActive = true; // Mark UI as active
    final currentTask = game.getCurrentTask();

    return Center(
      child: Card(
        color: const Color(0xFF242424),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentTask.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Süre: ${currentTask.durationSeconds} saniye',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      game.overlays.remove('TaskDetails');
                      game.overlays.add('GameStatus');
                    },
                    child: const Text('Geri', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      game.overlays.remove('TaskDetails');
                      game.startTask();
                    },
                    child: const Text('Başlamak için tıkla'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
