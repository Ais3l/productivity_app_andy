import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:productivity_app_andy/providers/task_provider.dart';
import 'package:productivity_app_andy/providers/coins_provider.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final coinsProvider = Provider.of<CoinsProvider>(context);

    // Calculate today's stats
    final todayStats = _calculateDailyStats(taskProvider.todaysTasks);

    // Calculate weekly stats
    final weeklyStats = _calculateWeeklyStats(taskProvider.tasksThisWeek);

    // Calculate intensity for each day
    Map<DateTime, int> taskCounts = {};
    for (var task in taskProvider.allTasks) {
      final date = DateTime(
        task.createdAt.year,
        task.createdAt.month,
        task.createdAt.day,
      );
      taskCounts[date] = (taskCounts[date] ?? 0) + 1;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Today's Stats Card
          _buildStatsCard(
            'Today\'s Stats',
            [
              _buildStatItem(Icons.timer, 'Focus Time',
                  _formatDuration(todayStats.totalFocusTime)),
              _buildStatItem(Icons.nature, 'Trees Planted',
                  coinsProvider.treesPlanted.toString()),
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
                  coinsProvider.treesPlanted.toString()),
              _buildStatItem(Icons.trending_up, 'Completion Rate',
                  '${weeklyStats.completionRate.toStringAsFixed(1)}%'),
            ],
          ),

          const SizedBox(height: 20),

          // Calendar Section
          Card(
            margin: const EdgeInsets.all(8.0),
            color: const Color(0xFF87C4B4),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2025, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      weekendTextStyle: const TextStyle(color: Colors.red),
                      selectedDecoration: BoxDecoration(
                        color: Colors.green[800],
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.green[400],
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: const TextStyle(color: Colors.white),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonTextStyle: TextStyle(color: Colors.white),
                      titleTextStyle: TextStyle(color: Colors.white),
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: Colors.white),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: Colors.white),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, date, _) {
                        final count = taskCounts[date] ?? 0;
                        final opacity = count == 0
                            ? 0.0
                            : (0.3 + (count * 0.1)).clamp(0.0, 1.0);

                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green[800]?.withOpacity(opacity),
                          ),
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              color:
                                  opacity > 0.5 ? Colors.white : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_selectedDay != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Activity on ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}:',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${taskCounts[_selectedDay] ?? 0} tasks completed',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
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

  Widget _buildStatsCard(String title, List<Widget> stats) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: const Color(0xFF87C4B4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ...stats,
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.black),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
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
