import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app_andy/providers/task_provider.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    // Calculate today's stats
    final todayStats = _calculateDailyStats(taskProvider.todaysTasks);

    // Calculate weekly stats
    final weeklyStats = _calculateWeeklyStats(taskProvider.tasksThisWeek);

    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),

              // Today's Stats Card
              _buildStatsCard(
                'Today\'s Stats',
                [
                  _buildStatItem(Icons.timer, 'Focus Time',
                      _formatDuration(todayStats.totalFocusTime)),
                  _buildStatItem(Icons.nature, 'Trees Planted',
                      todayStats.treesPlanted.toString()),
                  _buildStatItem(Icons.task_alt, 'Tasks Completed',
                      todayStats.tasksCompleted.toString()),
                ],
              ),

              const SizedBox(height: 20),

              // Weekly Overview Card
              _buildStatsCard(
                'Weekly Overview',
                [
                  _buildStatItem(Icons.timer, 'Total Focus Time',
                      _formatDuration(weeklyStats.totalFocusTime)),
                  _buildStatItem(Icons.nature, 'Total Trees',
                      weeklyStats.treesPlanted.toString()),
                  _buildStatItem(Icons.trending_up, 'Completion Rate',
                      '${weeklyStats.completionRate.toStringAsFixed(1)}%'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  Stats _calculateDailyStats(List<Task> tasks) {
    final completedTasks = tasks.where((task) => task.isCompleted).toList();

    return Stats(
      totalFocusTime: tasks.fold(
        Duration.zero,
        (prev, task) => prev + task.focusTime,
      ),
      treesPlanted: tasks.fold(
        0,
        (prev, task) => prev + task.treesPlanted,
      ),
      tasksCompleted: completedTasks.length,
      completionRate:
          tasks.isEmpty ? 0 : (completedTasks.length / tasks.length) * 100,
    );
  }

  Stats _calculateWeeklyStats(List<Task> tasks) {
    return _calculateDailyStats(
        tasks); // Same calculation logic, different time period
  }
}

class Stats {
  final Duration totalFocusTime;
  final int treesPlanted;
  final int tasksCompleted;
  final double completionRate;

  Stats({
    required this.totalFocusTime,
    required this.treesPlanted,
    required this.tasksCompleted,
    required this.completionRate,
  });
}

Widget _buildStatsCard(String title, List<Widget> children) {
  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    ),
  );
}

Widget _buildStatItem(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Row(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
