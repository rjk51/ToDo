import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

    if (taskName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task name cannot be empty.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      User? user = FirebaseAuth.instance.currentUser;
      final userId = user!.uid;

      final taskData = {
        'name': taskName,
        'description': taskDescription,
        'status': 'To-Do',
      };

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(userId)
          .collection('userTasks')
          .add(taskData);
    }
  }
}
