import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoTaskList extends StatefulWidget {
  final String status;
  const TodoTaskList({super.key,required this.status});

  @override
  State<TodoTaskList> createState() => _TodoTaskListState();
}

class _TodoTaskListState extends State<TodoTaskList> {

  void _deleteTask(String taskId,  Map<String, dynamic> taskData) async {
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

  void _updateTaskStatus(String taskId, String newStatus, String oldStatus) async {
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
            _updateTaskStatus(taskId, oldStatus, newStatus); // Undo the change
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      print('Error updating task status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('status', isEqualTo: widget.status)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final tasks = snapshot.data!.docs;

          return tasks.isEmpty 
            ? const Center(
              child: Text(
                'No tasks found',
                style: TextStyle(fontSize: 16),
              ),
            ) 
            :
            ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final taskSnapshot = tasks[index];
                final task = tasks[index].data() as Map<String, dynamic>;
                final taskId = taskSnapshot.id;
                bool isDone = task['status'] == 'Done';
                bool isDoing = task['status'] == 'Currently Doing';

                return Dismissible(
                  key: Key(taskId), // Use the document ID as the key
                  background: Container(
                    color: Colors.red, // Background color when swiped
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    _deleteTask(taskId, task);
                  },
                  child: ListTile(
                    trailing: GestureDetector(
                      onTap: () {
                        _updateTaskStatus(taskId, isDoing ? 'To-Do' : 'Currently Doing', isDoing ? 'Currently Doing' : 'To-Do');
                      },
                      child: Icon(
                        isDoing ? Icons.star : Icons.star_border,
                        color: isDoing ? Colors.white : null, // Fill star with yellow color when task is "Currently Doing"
                      ),
                    ),

                    leading: Checkbox(
                      value: isDone,
                      onChanged: (bool? value) {
                        _updateTaskStatus(taskId, value! ? 'Done' : 'To-Do', isDone ? 'Done' : 'To-Do');
                      },
                    ),
                    
                    title: Text(task['name']),
                    subtitle: Text(task['description']),
                    // Add more UI elements here as needed.
                  ),
                );
              },
            );
        },
      ),
    );
  }
}