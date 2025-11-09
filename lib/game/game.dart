import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what_is_my_work/game/bloc/game_bloc.dart';
import 'models.dart';
import 'package:what_is_my_work/profile_screen.dart';
import 'package:what_is_my_work/settings_screen.dart';
import 'package:what_is_my_work/users_list_screen.dart';

Future<void> _launchUrl(String? urlString, BuildContext context) async {
  if (urlString != null && urlString.isNotEmpty) {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // ignore: use_build_context_synchronously
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
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
  Map<int, int> userAnswers = {};
  List<Question> failedQuestionsQuiz = [];
  Quiz? _cachedQuiz; // Cache the current quiz to avoid regenerating

  bool isUiOverlayActive = false;

  WhatIsMyWorkGame({required this.levels}) {
    // Find the current position from levels (first incomplete task)
    outerLoop:
    for (int l = 0; l < levels.length; l++) {
      for (int s = 0; s < levels[l].stages.length; s++) {
        for (int t = 0; t < levels[l].stages[s].tasks.length; t++) {
          if (!levels[l].stages[s].tasks[t].isCompleted) {
            currentLevel = l;
            currentStage = s;
            currentTask = t;
            break outerLoop;
          }
        }
      }
    }
  }

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

  void refreshTaskComponent() {
    children.whereType<TaskComponent>().forEach(remove);
    add(_buildTaskComponent());
  }

  Quiz? getCurrentQuiz() {
    // Eğer cache'de quiz varsa onu dön
    if (_cachedQuiz != null) {
      return _cachedQuiz;
    }

    final stage = levels[currentLevel].stages[currentStage];
    final random = Random();
    List<Question> quizQuestions = [];

    if (failedQuestionsQuiz.isNotEmpty) {
      // Başarısız soruların görevlerinden farklı sorular seç
      for (var failedQuestion in failedQuestionsQuiz) {
        // Bu sorunun hangi göreve ait olduğunu bul
        for (var task in stage.tasks) {
          if (task.name == failedQuestion.relatedTaskName &&
              task.questions.isNotEmpty) {
            // Aynı göreve ait ama farklı bir soru seç
            var availableQuestions = task.questions
                .where((q) => q.text != failedQuestion.text)
                .toList();

            if (availableQuestions.isEmpty) {
              // Başka soru yoksa aynı soruyu tekrar sor
              availableQuestions = task.questions;
            }

            final randomIndex = random.nextInt(availableQuestions.length);
            quizQuestions.add(availableQuestions[randomIndex]);
            break;
          }
        }
      }
    } else {
      // Normal quiz - her tasktan rastgele bir soru
      for (var task in stage.tasks) {
        if (task.questions.isNotEmpty) {
          final randomIndex = random.nextInt(task.questions.length);
          quizQuestions.add(task.questions[randomIndex]);
        }
      }
    }

    if (quizQuestions.isNotEmpty) {
      _cachedQuiz = Quiz(
        levelType: levels[currentLevel].type,
        stageNumber: stage.stageNumber,
        questions: quizQuestions,
      );
      return _cachedQuiz;
    }

    return null;
  }

  void clearQuizCache() {
    _cachedQuiz = null;
  }

  void jumpToTask(String taskName) {
    for (int l = 0; l < levels.length; l++) {
      for (int s = 0; s < levels[l].stages.length; s++) {
        for (int t = 0; t < levels[l].stages[s].tasks.length; t++) {
          if (levels[l].stages[s].tasks[t].name == taskName) {
            currentLevel = l;
            currentStage = s;
            currentTask = t;
            children.whereType<TaskComponent>().forEach(remove);
            add(_buildTaskComponent());
            overlays.clear();
            overlays.add('GameStatus');
            return;
          }
        }
      }
    }
  }

  void findAndSetNextIncompleteTask() {
    for (int l = 0; l < levels.length; l++) {
      for (int s = 0; s < levels[l].stages.length; s++) {
        for (int t = 0; t < levels[l].stages[s].tasks.length; t++) {
          if (!levels[l].stages[s].tasks[t].isCompleted) {
            currentLevel = l;
            currentStage = s;
            currentTask = t;
            children.whereType<TaskComponent>().forEach(remove);
            add(_buildTaskComponent());
            overlays.clear();
            overlays.add('GameStatus');
            return;
          }
        }
      }
    }
  }

  // Yanlış cevaplanan soruların görevlerini incomplete yap
  void markFailedQuestionTasksAsIncomplete(List<Question> failedQuestions) {
    final currentStageObj = levels[currentLevel].stages[currentStage];

    for (var question in failedQuestions) {
      // Her sorunun hangi göreve ait olduğunu relatedTaskName ile bul
      for (int t = 0; t < currentStageObj.tasks.length; t++) {
        final task = currentStageObj.tasks[t];
        if (task.name == question.relatedTaskName) {
          // Bu görevi incomplete yap
          task.isCompleted = false;
          task.startTime = null;
          task.endTime = null;
          break;
        }
      }
    }

    // İlk incomplete task'a git
    findAndSetNextIncompleteTask();
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
        // Timer completed - automatically complete the task
        completeTask();
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

    // Save progress immediately after completing a task
    final context = buildContext;
    if (context != null && context.mounted) {
      context.read<GameBloc>().add(GameStateSaved());
    }

    advanceTask();
  }

  void advanceToNextStage() {
    clearQuizCache(); // Yeni stage'e geçerken cache'i temizle

    if (currentStage < levels[currentLevel].stages.length - 1) {
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

  void advanceTask() {
    final stage = levels[currentLevel].stages[currentStage];

    if (failedQuestionsQuiz.isNotEmpty) {
      bool allFailedTasksDone = failedQuestionsQuiz.every((q) {
        for (var level in levels) {
          for (var stage in level.stages) {
            for (var task in stage.tasks) {
              if (task.name == q.relatedTaskName) {
                return task.isCompleted;
              }
            }
          }
        }
        return false;
      });

      if (allFailedTasksDone) {
        userAnswers.clear();
        overlays.add('Quiz');
      } else {
        findAndSetNextIncompleteTask();
      }
    } else {
      if (currentTask < stage.tasks.length - 1) {
        currentTask++;
        children.whereType<TaskComponent>().forEach(remove);
        add(_buildTaskComponent());
        overlays.add('GameStatus');
      } else {
        final quiz = getCurrentQuiz();
        if (quiz != null) {
          failedQuestionsQuiz = quiz.questions;
          userAnswers.clear();
          overlays.add('Quiz');
        } else {
          advanceToNextStage();
        }
      }
    }
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
    final paint = Paint()
      ..color = isActive ? const Color(0xFFB3E5FC) : const Color(0xFFE0E0E0);
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
          game.isUiOverlayActive = true;
          final currentLevel = game.levels[game.currentLevel];
          final currentStage = game.currentStage;
          final currentTask = game.currentTask;
          final currentStageObj = currentLevel.stages[currentStage];

          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.95),
                    Colors.grey.shade900.withValues(alpha: 0.95),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlayerInfoHeader(context, state),
                  const SizedBox(height: 16),

                  // Current level indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.purple.shade700],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          '${currentLevel.type.name.toUpperCase()} - Kademe ${currentStageObj.stageNumber}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView(
                      children: [
                        for (int l = 0; l < game.levels.length; l++) ...[
                          _buildLevelCard(
                            game,
                            l,
                            currentLevel,
                            currentStage,
                            currentTask,
                            context,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),

                  // Bottom padding and current task start button
                  const SizedBox(height: 16),
                  _buildCurrentTaskButton(
                    context,
                    currentLevel,
                    currentStage,
                    currentTask,
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

  Widget _buildLevelCard(
    WhatIsMyWorkGame game,
    int levelIndex,
    Level currentLevel,
    int currentStage,
    int currentTask,
    BuildContext context,
  ) {
    final level = game.levels[levelIndex];
    final isCurrentLevel = levelIndex == game.currentLevel;

    return Card(
      elevation: isCurrentLevel ? 8 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isCurrentLevel ? const Color(0xFF2D2D44) : const Color(0xFF1E1E2E),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrentLevel
                ? Colors.blue.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.1),
            width: isCurrentLevel ? 2 : 1,
          ),
        ),
        child: ExpansionTile(
          initiallyExpanded: isCurrentLevel,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isCurrentLevel
                    ? [Colors.blue.shade400, Colors.purple.shade400]
                    : [Colors.grey.shade700, Colors.grey.shade600],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getLevelIcon(level.type),
              color: Colors.white,
              size: 24,
            ),
          ),
          title: Text(
            level.type.name.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCurrentLevel ? Colors.greenAccent : Colors.white,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            '${_getCompletedTasksInLevel(level)}/${_getTotalTasksInLevel(level)} görev tamamlandı',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          children: [
            for (int s = 0; s < level.stages.length; s++)
              _buildStageCard(
                game,
                levelIndex,
                s,
                currentStage,
                currentTask,
                context,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageCard(
    WhatIsMyWorkGame game,
    int levelIndex,
    int stageIndex,
    int currentStage,
    int currentTask,
    BuildContext context,
  ) {
    final stage = game.levels[levelIndex].stages[stageIndex];
    final isCurrentStage =
        levelIndex == game.currentLevel && stageIndex == currentStage;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrentStage
            ? Colors.blue.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentStage
              ? Colors.blue.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: isCurrentStage,
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Icon(
          Icons.layers,
          color: isCurrentStage ? Colors.lightBlueAccent : Colors.white70,
          size: 20,
        ),
        title: Text(
          'Kademe ${stage.stageNumber}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isCurrentStage ? Colors.lightBlueAccent : Colors.white70,
          ),
        ),
        children: [
          for (int t = 0; t < stage.tasks.length; t++)
            _buildTaskCard(
              game,
              levelIndex,
              stageIndex,
              t,
              currentTask,
              context,
            ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(
    WhatIsMyWorkGame game,
    int levelIndex,
    int stageIndex,
    int taskIndex,
    int currentTask,
    BuildContext context,
  ) {
    final task = game.levels[levelIndex].stages[stageIndex].tasks[taskIndex];
    final isCompleted = task.isCompleted;

    // Check if this task is available (previous tasks completed)
    bool isAvailable = isCompleted;
    if (!isCompleted) {
      if (levelIndex < game.currentLevel) {
        isAvailable = false;
      } else if (levelIndex == game.currentLevel) {
        if (stageIndex < game.currentStage) {
          isAvailable = false;
        } else if (stageIndex == game.currentStage) {
          bool allPreviousCompleted = true;
          for (int i = 0; i < taskIndex; i++) {
            if (!game
                .levels[levelIndex]
                .stages[stageIndex]
                .tasks[i]
                .isCompleted) {
              allPreviousCompleted = false;
              break;
            }
          }
          isAvailable = allPreviousCompleted && !isCompleted;
        } else {
          isAvailable = false;
        }
      } else {
        isAvailable = false;
      }
    }

    final isNextTask = isAvailable && !isCompleted;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: isNextTask
            ? LinearGradient(
                colors: [
                  Colors.orange.shade800.withValues(alpha: 0.3),
                  Colors.deepOrange.shade800.withValues(alpha: 0.3),
                ],
              )
            : null,
        color: isCompleted
            ? Colors.green.withValues(alpha: 0.1)
            : isAvailable
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNextTask
              ? Colors.orange.withValues(alpha: 0.5)
              : isCompleted
              ? Colors.green.withValues(alpha: 0.3)
              : isAvailable
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.2),
          width: isNextTask ? 2 : 1,
        ),
      ),
      child: Opacity(
        opacity: isAvailable || isCompleted ? 1.0 : 0.4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isCompleted
                        ? [Colors.green.shade600, Colors.teal.shade600]
                        : isNextTask
                        ? [Colors.orange.shade600, Colors.deepOrange.shade600]
                        : [Colors.grey.shade700, Colors.grey.shade600],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (isCompleted
                                  ? Colors.green
                                  : isNextTask
                                  ? Colors.orange
                                  : Colors.grey)
                              .withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  isCompleted
                      ? Icons.check_circle
                      : isNextTask
                      ? Icons.play_circle_filled
                      : isAvailable
                      ? Icons.radio_button_unchecked
                      : Icons.lock,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isNextTask
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCompleted
                            ? Colors.greenAccent
                            : isNextTask
                            ? Colors.orangeAccent
                            : isAvailable
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                    if (!isCompleted) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 14,
                            color: isAvailable
                                ? Colors.yellow.shade700
                                : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${task.durationSeconds}s',
                            style: TextStyle(
                              color: isAvailable
                                  ? Colors.yellow.shade700
                                  : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (!isAvailable && !isCompleted) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Önceki görevleri tamamla',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isAvailable || isCompleted)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (task.taskUrl != null)
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.link,
                            color: Colors.blue,
                            size: 18,
                          ),
                        ),
                        onPressed: () => _launchUrl(task.taskUrl, context),
                      ),
                    if (task.explanationUrl != null)
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.help_outline,
                            color: Colors.amber,
                            size: 18,
                          ),
                        ),
                        onPressed: () =>
                            _launchUrl(task.explanationUrl, context),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getLevelIcon(LevelType type) {
    switch (type) {
      case LevelType.junior:
        return Icons.school;
      case LevelType.senior:
        return Icons.work;
      case LevelType.master:
        return Icons.emoji_events;
    }
  }

  int _getCompletedTasksInLevel(Level level) {
    int count = 0;
    for (var stage in level.stages) {
      for (var task in stage.tasks) {
        if (task.isCompleted) count++;
      }
    }
    return count;
  }

  int _getTotalTasksInLevel(Level level) {
    int count = 0;
    for (var stage in level.stages) {
      count += stage.tasks.length;
    }
    return count;
  }

  Widget _buildCurrentTaskButton(
    BuildContext context,
    Level currentLevel,
    int currentStageIndex,
    int currentTaskIndex,
  ) {
    final task = currentLevel.stages[currentStageIndex].tasks[currentTaskIndex];

    // Debug: Always show button for now
    // if (task.isCompleted || game.isTaskActive) {
    //   return const SizedBox.shrink();
    // }

    // Show button only if task is not completed and not active
    final shouldShow = !task.isCompleted && !game.isTaskActive;
    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.teal.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.6),
            blurRadius: 20,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            game.overlays.remove('GameStatus');
            game.overlays.add('TaskDetails');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Sıradaki Görev',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerInfoHeader(BuildContext context, GameLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      state.user.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.orange, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Toplam Süre: ${game.totalSpentTime}s',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.people, color: Colors.white),
                tooltip: 'Kullanıcı Listesi',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UsersListScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                tooltip: 'Profil Düzenle',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                tooltip: 'Görev Ayarları',
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
        ],
      ),
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
    widget.game.isUiOverlayActive = true;
    final currentTask = widget.game.getCurrentTask();
    final remainingSeconds = _remaining ?? 0;
    final isTimeUp = remainingSeconds <= 0;
    final isLowTime = remainingSeconds <= 10 && remainingSeconds > 0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.85),
            Colors.grey.shade900.withValues(alpha: 0.95),
          ],
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isTimeUp
                  ? [Colors.green.shade800, Colors.green.shade600]
                  : isLowTime
                  ? [Colors.red.shade800, Colors.orange.shade800]
                  : [const Color(0xFF1E1E2E), const Color(0xFF2D2D44)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: isTimeUp
                    ? Colors.green.withValues(alpha: 0.6)
                    : isLowTime
                    ? Colors.red.withValues(alpha: 0.6)
                    : Colors.blue.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Task name header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isTimeUp ? Icons.check_circle : Icons.work,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        currentTask.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Timer display
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: !isTimeUp
                    ? Container(
                        key: ValueKey('timer_$remainingSeconds'),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: isLowTime
                                ? [Colors.red.shade600, Colors.orange.shade600]
                                : [
                                    Colors.blue.shade600,
                                    Colors.purple.shade600,
                                  ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isLowTime
                                  ? Colors.red.withValues(alpha: 0.6)
                                  : Colors.blue.withValues(alpha: 0.5),
                              blurRadius: 25,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              remainingSeconds.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isLowTime ? 72 : 64,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'saniye',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        key: const ValueKey('complete_button'),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade500,
                              Colors.teal.shade500,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.6),
                              blurRadius: 30,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 80,
                              color: Colors.white,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'TAMAMLA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              if (isTimeUp) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _finishTask,
                  icon: const Icon(Icons.done_all, size: 28),
                  label: const Text(
                    'Görevi Bitir',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 20,
                    ),
                    elevation: 8,
                    shadowColor: Colors.green.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Action buttons
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  if (currentTask.taskUrl != null)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.link, size: 20),
                      label: const Text('Görev Linki'),
                      onPressed: () => _launchUrl(currentTask.taskUrl, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  if (currentTask.explanationUrl != null)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.help_outline, size: 20),
                      label: const Text('Yardım'),
                      onPressed: () =>
                          _launchUrl(currentTask.explanationUrl, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),

              if (!isTimeUp) ...[
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => widget.game.cancelTask(context),
                  icon: const Icon(Icons.close),
                  label: const Text('İptal Et'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade300,
                    side: BorderSide(color: Colors.red.shade300, width: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ],
          ),
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
    game.isUiOverlayActive = true;
    final currentTask = game.getCurrentTask();
    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade900.withValues(alpha: 0.95),
            Colors.purple.shade900.withValues(alpha: 0.95),
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: screenSize.width * 0.9,
            maxHeight: screenSize.height * 0.8,
          ),
          child: Card(
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF1E1E2E), const Color(0xFF2D2D44)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade400,
                            Colors.purple.shade400,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.assignment,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Task title
                    Text(
                      currentTask.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Task description
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Text(
                        currentTask.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Duration info
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade700,
                            Colors.deepOrange.shade800,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withValues(alpha: 0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.timer,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'SÜRE',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                '${currentTask.durationSeconds} saniye',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Back button
                        OutlinedButton.icon(
                          onPressed: () {
                            game.overlays.remove('TaskDetails');
                            game.overlays.add('GameStatus');
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Geri'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.white54,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Start button
                        ElevatedButton.icon(
                          onPressed: () {
                            game.overlays.remove('TaskDetails');
                            game.startTask();
                          },
                          icon: const Icon(Icons.play_arrow, size: 28),
                          label: const Text(
                            'Başlat',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            elevation: 8,
                            shadowColor: Colors.green.withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
