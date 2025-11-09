import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_work/game/bloc/game_bloc.dart';
import 'package:what_is_my_work/game/game.dart';
import 'package:what_is_my_work/game/models.dart';
import 'package:what_is_my_work/profile_screen.dart';
import 'package:what_is_my_work/settings_screen.dart';
import 'package:what_is_my_work/users_list_screen.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(String? urlString, BuildContext context) async {
  if (urlString != null && urlString.isNotEmpty) {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $urlString')),
      );
    }
  }
}

class GameStatusOverlay extends StatefulWidget {
  final WhatIsMyWorkGame game;
  const GameStatusOverlay({super.key, required this.game});

  @override
  State<GameStatusOverlay> createState() => _GameStatusOverlayState();
}

class _GameStatusOverlayState extends State<GameStatusOverlay> {
  final ScrollController _scrollController = ScrollController();
  late Set<int> _expandedLevels;
  late Set<String> _expandedStages; // Format: "levelIndex-stageIndex"

  @override
  void initState() {
    super.initState();
    _updateExpandedState();
    
    // Scroll to current level after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentLevel();
    });
  }

  @override
  void didUpdateWidget(GameStatusOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update expanded state when game state changes
    if (oldWidget.game.currentLevel != widget.game.currentLevel ||
        oldWidget.game.currentStage != widget.game.currentStage) {
      _updateExpandedState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentLevel();
      });
    }
  }

  void _updateExpandedState() {
    // Only expand current level and current stage
    _expandedLevels = {widget.game.currentLevel};
    _expandedStages = {'${widget.game.currentLevel}-${widget.game.currentStage}'};
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentLevel() {
    if (_scrollController.hasClients) {
      // Calculate offset based on collapsed/expanded heights
      const collapsedCardHeight = 80.0; // Kapalı card yüksekliği
      final targetOffset = widget.game.currentLevel * collapsedCardHeight;
      
      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game; // Local reference for easier access
    
    return BlocListener<GameBloc, GameState>(
      listener: (context, state) {
        if (state is GameLoaded) {
          // Find the current position from the profile
          int newLevel = 0;
          int newStage = 0;
          
          outerLoop:
          for (int l = 0; l < state.profile.levels.length; l++) {
            for (int s = 0; s < state.profile.levels[l].stages.length; s++) {
              bool hasIncompleteTask = state.profile.levels[l].stages[s].tasks
                  .any((task) => !task.isCompleted);
              if (hasIncompleteTask) {
                newLevel = l;
                newStage = s;
                break outerLoop;
              }
            }
          }
          
          // Update game position if changed
          if (game.currentLevel != newLevel || game.currentStage != newStage) {
            game.currentLevel = newLevel;
            game.currentStage = newStage;
            setState(() {
              _updateExpandedState();
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToCurrentLevel();
            });
          }
        }
      },
      child: BlocBuilder<GameBloc, GameState>(
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
                    Colors.black.withOpacity(0.95),
                    Colors.grey.shade900.withOpacity(0.95),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlayerInfoHeader(context, state),
                  const SizedBox(height: 8),
                  _buildDebugPanel(context, state),
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.purple.shade700],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
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
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: game.levels.length,
                      itemBuilder: (context, l) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _buildLevelCard(
                            game, 
                            l, 
                            currentLevel, 
                            currentStage, 
                            currentTask, 
                            context,
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  _buildCurrentTaskButton(context, currentLevel, currentStage, currentTask),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
      ),
    );
  }

  Widget _buildPlayerInfoHeader(BuildContext context, GameLoaded state) {
    final loginTime = state.user.loginTime;
    final formattedLoginTime = '${loginTime.day.toString().padLeft(2, '0')}/${loginTime.month.toString().padLeft(2, '0')}/${loginTime.year} ${loginTime.hour.toString().padLeft(2, '0')}:${loginTime.minute.toString().padLeft(2, '0')}';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                    const Icon(Icons.login, color: Colors.lightBlue, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Giriş: $formattedLoginTime',
                      style: const TextStyle(color: Colors.lightBlue, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.orange, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Toplam Süre: ${widget.game.totalSpentTime}s',
                      style: const TextStyle(color: Colors.orange, fontSize: 14),
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
                    MaterialPageRoute(builder: (context) => const UsersListScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                tooltip: 'Profil Düzenle',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                tooltip: 'Görev Ayarları',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDebugPanel(BuildContext context, GameLoaded state) {
    return ExpansionTile(
      title: const Row(
        children: [
          Icon(Icons.bug_report, color: Colors.orange, size: 20),
          SizedBox(width: 8),
          Text(
            'Test Paneli',
            style: TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      iconColor: Colors.orange,
      collapsedIconColor: Colors.orange,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Reset Progress
              ElevatedButton.icon(
                onPressed: () {
                  context.read<GameBloc>().add(ResetProgressRequested());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('İlerleme sıfırlandı!')),
                  );
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('İlerlemeyi Sıfırla'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 8),
              
              // Complete to Stage 1
              ElevatedButton.icon(
                onPressed: () {
                  context.read<GameBloc>().add(CompleteTasksUpToRequested(
                    levelIndex: 0,
                    stageIndex: 0,
                    taskIndex: 2,
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('1. Kademe 2 görev tamamlandı')),
                  );
                },
                icon: const Icon(Icons.fast_forward, size: 18),
                label: const Text('1. Kademe → 2 Görev'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 8),
              
              // Complete to Stage 2
              ElevatedButton.icon(
                onPressed: () {
                  context.read<GameBloc>().add(CompleteTasksUpToRequested(
                    levelIndex: 0,
                    stageIndex: 1,
                    taskIndex: 0,
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('2. Kademeye geçildi')),
                  );
                },
                icon: const Icon(Icons.fast_forward, size: 18),
                label: const Text('2. Kademeye Geç'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 8),
              
              // Complete to Level 2
              ElevatedButton.icon(
                onPressed: () {
                  context.read<GameBloc>().add(CompleteTasksUpToRequested(
                    levelIndex: 1,
                    stageIndex: 0,
                    taskIndex: 0,
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('2. Seviyeye geçildi')),
                  );
                },
                icon: const Icon(Icons.fast_forward, size: 18),
                label: const Text('2. Seviyeye Geç'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentTaskButton(
    BuildContext context,
    Level currentLevel,
    int currentStageIndex,
    int currentTaskIndex,
  ) {
    final game = widget.game;
    
    // Find the next incomplete task across all levels and stages
    Task? nextIncompleteTask;
    int? nextIncompleteTaskIndex;
    int? nextStageIndex;
    int? nextLevelIndex;
    
    // Start searching from current position
    bool found = false;
    for (int l = game.currentLevel; l < game.levels.length && !found; l++) {
      for (int s = (l == game.currentLevel ? game.currentStage : 0); s < game.levels[l].stages.length && !found; s++) {
        for (int t = 0; t < game.levels[l].stages[s].tasks.length && !found; t++) {
          if (!game.levels[l].stages[s].tasks[t].isCompleted) {
            nextIncompleteTask = game.levels[l].stages[s].tasks[t];
            nextIncompleteTaskIndex = t;
            nextStageIndex = s;
            nextLevelIndex = l;
            found = true;
          }
        }
      }
    }
    
    // If no incomplete task found, don't show button
    if (nextIncompleteTask == null || nextIncompleteTaskIndex == null || 
        nextStageIndex == null || nextLevelIndex == null) {
      return const SizedBox.shrink();
    }
    
    // Don't show if a task is currently active
    if (game.isTaskActive) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.green.shade600, Colors.teal.shade600]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.green.withOpacity(0.6), blurRadius: 20, spreadRadius: 3),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Update the game's position to the next incomplete task
            game.currentLevel = nextLevelIndex!;
            game.currentStage = nextStageIndex!;
            game.currentTask = nextIncompleteTaskIndex!;
            // Refresh the task component to show the correct task
            game.refreshTaskComponent();
            // Navigate to task details
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
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
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
                        nextIncompleteTask.name,
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
            color: isCurrentLevel ? Colors.blue.withOpacity(0.5) : Colors.white.withOpacity(0.1),
            width: isCurrentLevel ? 2 : 1,
          ),
        ),
        child: ExpansionTile(
          key: ValueKey('level-$levelIndex-${_expandedLevels.contains(levelIndex)}'), // Force rebuild when state changes
          initiallyExpanded: _expandedLevels.contains(levelIndex),
          onExpansionChanged: (expanded) {
            setState(() {
              if (expanded) {
                _expandedLevels.add(levelIndex);
              } else {
                _expandedLevels.remove(levelIndex);
              }
            });
          },
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
            child: Icon(_getLevelIcon(level.type), color: Colors.white, size: 24),
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
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
          ),
          children: [
            for (int s = 0; s < level.stages.length; s++)
              _buildStageCard(game, levelIndex, s, currentStage, currentTask, context),
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
    final isCurrentStage = levelIndex == game.currentLevel && stageIndex == currentStage;
    final stageKey = '$levelIndex-$stageIndex';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrentStage ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentStage ? Colors.blue.withOpacity(0.3) : Colors.transparent,
        ),
      ),
      child: ExpansionTile(
        key: ValueKey('stage-$stageKey-${_expandedStages.contains(stageKey)}'), // Force rebuild when state changes
        initiallyExpanded: _expandedStages.contains(stageKey),
        onExpansionChanged: (expanded) {
          setState(() {
            if (expanded) {
              _expandedStages.add(stageKey);
            } else {
              _expandedStages.remove(stageKey);
            }
          });
        },
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
            _buildTaskCard(game, levelIndex, stageIndex, t, currentTask, context),
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
            if (!game.levels[levelIndex].stages[stageIndex].tasks[i].isCompleted) {
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
                  Colors.orange.shade800.withOpacity(0.3),
                  Colors.deepOrange.shade800.withOpacity(0.3),
                ],
              )
            : null,
        color: isCompleted
            ? Colors.green.withOpacity(0.1)
            : isAvailable
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNextTask
              ? Colors.orange.withOpacity(0.5)
              : isCompleted
                  ? Colors.green.withOpacity(0.3)
                  : isAvailable
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
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
                      color: (isCompleted ? Colors.green : isNextTask ? Colors.orange : Colors.grey)
                          .withOpacity(0.4),
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
                        fontWeight: isNextTask ? FontWeight.bold : FontWeight.normal,
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
                            color: isAvailable ? Colors.yellow.shade700 : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${task.durationSeconds}s',
                            style: TextStyle(
                              color: isAvailable ? Colors.yellow.shade700 : Colors.grey,
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
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.link, color: Colors.blue, size: 18),
                        ),
                        onPressed: () => _launchUrl(task.taskUrl, context),
                      ),
                    if (task.explanationUrl != null)
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.help_outline, color: Colors.amber, size: 18),
                        ),
                        onPressed: () => _launchUrl(task.explanationUrl, context),
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
}
