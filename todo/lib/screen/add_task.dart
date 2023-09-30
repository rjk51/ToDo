import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskEntryScreen extends StatelessWidget {
  const TaskEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: const TaskEntryForm(),
    );
  }
}

class TaskEntryForm extends StatefulWidget {
  const TaskEntryForm({super.key});
  @override
  State<TaskEntryForm> createState() => _TaskEntryFormState();
}

class _TaskEntryFormState extends State<TaskEntryForm> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _taskNameController,
            decoration: const InputDecoration(labelText: 'Task Name'),
          ),
          TextField(
            controller: _taskDescriptionController,
            decoration: const InputDecoration(labelText: 'Task Description'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Add the task to Firestore and navigate back to the previous screen.
              _addTaskToFirestore();
              Navigator.of(context).pop();
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }

  void _addTaskToFirestore() async {
    final taskName = _taskNameController.text;
    final taskDescription = _taskDescriptionController.text;

    final taskData = {
      'name': taskName,
      'description': taskDescription,
      'status': 'To-Do',
    };

    await FirebaseFirestore.instance.collection('tasks').add(taskData);
  }
}
