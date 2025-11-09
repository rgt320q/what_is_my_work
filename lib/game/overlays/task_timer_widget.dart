import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_work/game/game.dart';
import 'package:what_is_my_work/game/bloc/game_bloc.dart';

class TaskTimerWidget extends StatelessWidget {
  final WhatIsMyWorkGame game;

  const TaskTimerWidget({super.key, required this.game});

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final task = game.getCurrentTask();
    
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        final user = state is GameLoaded ? state.user : null;
        
        return Positioned(
          top: 16,
          left: 16,
          child: Card(
            color: Colors.black.withOpacity(0.7),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // User info section
                  if (user != null) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          user.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.login,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDateTime(user.loginTime),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white38, height: 24),
                  ],
                  // Task info section
                  Text(
                    task.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StreamBuilder<int>(
                    stream: Stream.periodic(
                      const Duration(seconds: 1),
                      (count) => task.durationSeconds - count - 1,
                    ).take(task.durationSeconds),
                    builder: (context, snapshot) {
                      final remainingTime = snapshot.data ?? task.durationSeconds;
                      return Text(
                        'Time: ${_formatTime(remainingTime)}',
                        style: TextStyle(
                          color: remainingTime < 10 ? Colors.red : Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
