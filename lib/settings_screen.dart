import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_work/game/bloc/game_bloc.dart';
import 'package:what_is_my_work/game/models.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late List<Level> _levels;
  final Map<Task, TextEditingController> _durationControllers = {};
  final Map<Task, TextEditingController> _taskUrlControllers = {};
  final Map<Task, TextEditingController> _explanationUrlControllers = {};

  @override
  void initState() {
    super.initState();
    final gameBloc = context.read<GameBloc>();
    if (gameBloc.state is GameLoaded) {
      _levels = List<Level>.from((gameBloc.state as GameLoaded).profile.levels.map(
            (level) => level.copyWith(
              stages: List<Stage>.from(level.stages.map(
                    (stage) => stage.copyWith(
                      tasks: List<Task>.from(stage.tasks.map((task) => task.copyWith())),
                    ),
                  )),
            ),
          ));
    } else {
      _levels = [];
    }

    // Initialize controllers for each task
    for (var level in _levels) {
      for (var stage in level.stages) {
        for (var task in stage.tasks) {
          _durationControllers[task] =
              TextEditingController(text: task.durationSeconds.toString());
          _taskUrlControllers[task] = TextEditingController(text: task.taskUrl ?? '');
          _explanationUrlControllers[task] =
              TextEditingController(text: task.explanationUrl ?? '');
        }
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _durationControllers.values) {
      controller.dispose();
    }
    for (var controller in _taskUrlControllers.values) {
      controller.dispose();
    }
    for (var controller in _explanationUrlControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveChanges() {
    setState(() {
      for (var level in _levels) {
        for (var stage in level.stages) {
          for (var task in stage.tasks) {
            final newDuration =
                int.tryParse(_durationControllers[task]!.text) ??
                    task.durationSeconds;
            final newtaskUrl = _taskUrlControllers[task]!.text;
            final newexplanationUrl = _explanationUrlControllers[task]!.text;

            task.durationSeconds = newDuration;
            task.taskUrl = newtaskUrl.isNotEmpty ? newtaskUrl : null;
            task.explanationUrl = newexplanationUrl.isNotEmpty ? newexplanationUrl : null;
          }
        }
      }
    });

    context.read<GameBloc>().add(UpdateSettings(_levels));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Değişiklikler kaydedildi!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Görev Ayarları'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _levels.length,
        itemBuilder: (context, levelIndex) {
          final level = _levels[levelIndex];
          return ExpansionTile(
            title: Text(
              'Seviye: ${level.type.name.toUpperCase()}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            children: level.stages.map((stage) {
              return ExpansionTile(
                title: Text(
                  '  Kademe: ${stage.stageNumber}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                children: stage.tasks.map((task) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _durationControllers[task],
                            decoration: const InputDecoration(
                              labelText: 'Süre (saniye)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _taskUrlControllers[task],
                            decoration: const InputDecoration(
                              labelText: 'Görev URL',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _explanationUrlControllers[task],
                            decoration: const InputDecoration(
                              labelText: 'Açıklama URL',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
