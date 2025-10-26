import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:what_is_my_work/game/models.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  List<UserProfileSummary> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllUsers();
  }

  Future<void> _loadAllUsers() async {
    setState(() => _isLoading = true);
    
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    List<UserProfileSummary> users = [];
    
    for (var key in keys) {
      if (key.startsWith('profile_')) {
        final jsonString = prefs.getString(key);
        
        if (jsonString != null) {
          try {
            final Map<String, dynamic> json = jsonDecode(jsonString);
            final profile = UserProfile.fromJson(json);
            users.add(_createSummary(profile));
          } catch (e) {
            // Skip invalid profiles
          }
        }
      }
    }
    
    // Sort by completion percentage
    users.sort((a, b) => b.completionPercentage.compareTo(a.completionPercentage));
    
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  UserProfileSummary _createSummary(UserProfile profile) {
    int totalTasks = 0;
    int completedTasks = 0;
    int totalTime = 0;
    
    for (var level in profile.levels) {
      for (var stage in level.stages) {
        for (var task in stage.tasks) {
          totalTasks++;
          if (task.isCompleted) {
            completedTasks++;
            totalTime += task.durationSeconds;
          }
        }
      }
    }
    
    // Find current level
    String currentLevel = 'Junior';
    for (var level in profile.levels) {
      bool hasIncompleteTask = false;
      for (var stage in level.stages) {
        for (var task in stage.tasks) {
          if (!task.isCompleted) {
            hasIncompleteTask = true;
            break;
          }
        }
        if (hasIncompleteTask) break;
      }
      if (hasIncompleteTask) {
        currentLevel = level.type.name.toUpperCase();
        break;
      }
      // If all tasks completed in this level, check next level
      if (level != profile.levels.last) {
        currentLevel = profile.levels[profile.levels.indexOf(level) + 1].type.name.toUpperCase();
      } else {
        currentLevel = 'MASTER (Tamamlandı)';
      }
    }
    
    final percentage = totalTasks > 0 ? (completedTasks / totalTasks * 100) : 0.0;
    
    return UserProfileSummary(
      username: profile.username,
      completedTasks: completedTasks,
      totalTasks: totalTasks,
      completionPercentage: percentage,
      totalTimeSpent: totalTime,
      currentLevel: currentLevel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tüm Kullanıcılar ve İlerlemeler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllUsers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Henüz kayıtlı kullanıcı yok',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _buildSummaryCard(),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          return _buildUserCard(user, index + 1);
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSummaryCard() {
    if (_users.isEmpty) return const SizedBox.shrink();
    
    final avgCompletion = _users.fold<double>(
      0, (sum, user) => sum + user.completionPercentage
    ) / _users.length;
    
    final totalTimeSpent = _users.fold<int>(
      0, (sum, user) => sum + user.totalTimeSpent
    );
    
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Genel İstatistikler',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat(
                  Icons.people,
                  'Toplam Kullanıcı',
                  '${_users.length}',
                  Colors.blue,
                ),
                _buildSummaryStat(
                  Icons.bar_chart,
                  'Ortalama İlerleme',
                  '${avgCompletion.toStringAsFixed(1)}%',
                  Colors.green,
                ),
                _buildSummaryStat(
                  Icons.timer,
                  'Toplam Süre',
                  '${totalTimeSpent}s',
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUserCard(UserProfileSummary user, int rank) {
    final color = rank == 1
        ? Colors.amber
        : rank == 2
            ? Colors.grey.shade400
            : rank == 3
                ? Colors.brown.shade300
                : Colors.blue;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '#$rank',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Seviye: ${user.currentLevel}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${user.completionPercentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getCompletionColor(user.completionPercentage),
                      ),
                    ),
                    Text(
                      '${user.completedTasks}/${user.totalTasks} görev',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: user.completionPercentage / 100,
              backgroundColor: Colors.grey.shade200,
              color: _getCompletionColor(user.completionPercentage),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timer, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Toplam: ${user.totalTimeSpent}s',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                if (user.completionPercentage == 100)
                  const Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text(
                        'Tamamlandı!',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCompletionColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    if (percentage >= 25) return Colors.amber;
    return Colors.red;
  }
}

class UserProfileSummary {
  final String username;
  final int completedTasks;
  final int totalTasks;
  final double completionPercentage;
  final int totalTimeSpent;
  final String currentLevel;

  UserProfileSummary({
    required this.username,
    required this.completedTasks,
    required this.totalTasks,
    required this.completionPercentage,
    required this.totalTimeSpent,
    required this.currentLevel,
  });
}
