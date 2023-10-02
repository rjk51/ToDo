import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showEditDialog(BuildContext context, String taskId, Map<String, dynamic> taskData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String editedName = taskData['name'];
      String editedDescription = taskData['description'];

      return AlertDialog(
        backgroundColor: const Color.fromARGB(95, 209, 202, 202),
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                editedName = value;
              },
              controller: TextEditingController(text: taskData['name']),
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              onChanged: (value) {
                editedDescription = value;
              },
              controller:
                  TextEditingController(text: taskData['description']),
              decoration:
                  const InputDecoration(labelText: 'Task Description'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 150, 150, 150),
            ),
            onPressed: () {
              updateTaskNameDescription(
                  taskId, editedName, editedDescription);
              Navigator.of(context).pop();
            },
            child: const Text('Save', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 150, 150, 150),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child:
                const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
        ],
      );
    },
  );
}

void updateTaskNameDescription(
  String taskId, String newName, String newDescription) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'name': newName,
        'description': newDescription,
      });
    } catch (e) {
      print('Error updating task name and description: $e');
    }
  }

void deleteTask(BuildContext context, String taskId, Map<String, dynamic> taskData) async {
  try {
    final snackBar = SnackBar(
      content: const Text(
        'Task deleted',
        style: TextStyle(fontSize: 16),
      ),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          FirebaseFirestore.instance.collection('tasks').add(taskData);
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
  } catch (e) {
    print('Error deleting task: $e');
  }
}

void updateTaskStatus(
    BuildContext context, String taskId, String newStatus, String oldStatus) async {
  try {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .update({'status': newStatus});

    final snackBar = SnackBar(
      content: Text(
        'Task marked as $newStatus',
        style: const TextStyle(fontSize: 16),
      ),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          updateTaskStatus(context, taskId, oldStatus, newStatus);
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } catch (e) {
    print('Error updating task status: $e');
  }
}
