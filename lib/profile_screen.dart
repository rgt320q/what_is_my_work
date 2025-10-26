import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_work/game/bloc/game_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<GameBloc>().state;
    if (state is GameLoaded) {
      _usernameController.text = state.user.username;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kullanıcı adı boş olamaz!')),
      );
      return;
    }

    final state = context.read<GameBloc>().state;
    if (state is GameLoaded) {
      context.read<GameBloc>().add(LoginRequested(username));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil güncellendi!')),
      );
      Navigator.of(context).pop();
    }
  }

  int _getTotalCompletedTasks() {
    final state = context.read<GameBloc>().state;
    if (state is GameLoaded) {
      int count = 0;
      for (var level in state.profile.levels) {
        for (var stage in level.stages) {
          for (var task in stage.tasks) {
            if (task.isCompleted) count++;
          }
        }
      }
      return count;
    }
    return 0;
  }

  int _getTotalTasks() {
    final state = context.read<GameBloc>().state;
    if (state is GameLoaded) {
      int count = 0;
      for (var level in state.profile.levels) {
        for (var stage in level.stages) {
          count += stage.tasks.length;
        }
      }
      return count;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is! GameLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final completedTasks = _getTotalCompletedTasks();
        final totalTasks = _getTotalTasks();
        final completionPercentage = totalTasks > 0 
            ? (completedTasks / totalTasks * 100).toStringAsFixed(1)
            : '0.0';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil Düzenle'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveChanges,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.blue,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Kullanıcı Adı',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'İstatistikler',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        _buildStatRow(
                          'Giriş Zamanı',
                          state.user.loginTime.toLocal().toString().substring(0, 19),
                        ),
                        const SizedBox(height: 12),
                        _buildStatRow(
                          'Tamamlanan Görevler',
                          '$completedTasks / $totalTasks',
                        ),
                        const SizedBox(height: 12),
                        _buildStatRow(
                          'Tamamlama Oranı',
                          '$completionPercentage%',
                        ),
                        const SizedBox(height: 12),
                        _buildStatRow(
                          'Mevcut Seviye',
                          state.profile.levels.isNotEmpty
                              ? state.profile.levels[0].type.name.toUpperCase()
                              : 'Yok',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Değişiklikleri Kaydet'),
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
