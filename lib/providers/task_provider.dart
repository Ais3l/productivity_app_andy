import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart' show DateUtils;

class Task {
  final String id;
  final String title;
  final DateTime createdAt;
  final Duration focusTime;
  final int treesPlanted;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.focusTime,
    required this.treesPlanted,
    this.isCompleted = false,
  });
}

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get allTasks => _tasks;

  List<Task> get todaysTasks {
    final now = DateTime.now();
    return _tasks.where((task) {
      return DateUtils.isSameDay(task.createdAt, now);
    }).toList();
  }

  List<Task> get tasksThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    return _tasks.where((task) {
      return task.createdAt.isAfter(startOfWeek) &&
          task.createdAt.isBefore(endOfWeek);
    }).toList();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTaskCompletion(String taskId) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      notifyListeners();
    }
  }

  void updateTaskFocusTime(String taskId, Duration focusTime) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      final oldTask = _tasks[taskIndex];
      _tasks[taskIndex] = Task(
        id: oldTask.id,
        title: oldTask.title,
        createdAt: oldTask.createdAt,
        focusTime: focusTime,
        treesPlanted: oldTask.treesPlanted,
        isCompleted: oldTask.isCompleted,
      );
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }
}
