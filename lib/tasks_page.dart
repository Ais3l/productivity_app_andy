import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: ListView.builder(
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          final task = taskProvider.tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('Created at: ${task.createdAt}'),
            trailing: Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) {
                // Update task completion status
                taskProvider.addTask(Task(
                  id: task.id,
                  title: task.title,
                  createdAt: task.createdAt,
                  focusTime: task.focusTime,
                  treesPlanted: task.treesPlanted,
                  isCompleted: value ?? false, // Update completion status
                ));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to add a new task
          // You can show a dialog or navigate to a new screen to add a task
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
