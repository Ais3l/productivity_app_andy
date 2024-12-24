import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart' show DateUtils;

class Task {
  final String id;
  final String title;
  final DateTime createdAt;
  final Duration focusTime;
  final int treesPlanted;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.focusTime,
    required this.treesPlanted,
    required this.isCompleted,
  });
}

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  int get completedTasksCount {
    return _tasks.where((task) => task.isCompleted).length;
  }

  List<Task> get todaysTasks {
    final today = DateTime.now();
    return _tasks
        .where((task) =>
            task.createdAt.year == today.year &&
            task.createdAt.month == today.month &&
            task.createdAt.day == today.day)
        .toList();
  }

  List<Task> get tasksThisWeek {
    final today = DateTime.now();
    final startOfWeek =
        today.subtract(Duration(days: today.weekday - 1)); // Monday
    return _tasks
        .where((task) =>
            task.createdAt.isAfter(startOfWeek) &&
            task.createdAt.isBefore(today.add(Duration(days: 1))))
        .toList();
  }

  List<Task> get allTasks => _tasks;
}
