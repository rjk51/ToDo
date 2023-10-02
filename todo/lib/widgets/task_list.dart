import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/widgets/task_list_functions.dart';

class TodoTaskList extends StatefulWidget {
  final String status;
  const TodoTaskList({super.key, required this.status});

  @override
  State<TodoTaskList> createState() => _TodoTaskListState();
}

class _TodoTaskListState extends State<TodoTaskList> {
  void _showEditDialog(String taskId, Map<String, dynamic> taskData) {
    showEditDialog(context, taskId, taskData);
  }

  void _deleteTask(String taskId, Map<String, dynamic> taskData) async {
    deleteTask(context, taskId, taskData);
  }

  void _updateTaskStatus(
      String taskId, String newStatus, String oldStatus) async {
    updateTaskStatus(context, taskId, newStatus, oldStatus);
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
              : Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ListView.separated(
                    itemCount: tasks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final taskSnapshot = tasks[index];
                      final task = tasks[index].data() as Map<String, dynamic>;
                      final taskId = taskSnapshot.id;
                      bool isDone = task['status'] == 'Done';
                      bool isDoing = task['status'] == 'Currently Doing';

                      Color tileColor =
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color.fromARGB(186, 255, 255, 255)
                              : const Color.fromARGB(162, 0, 0, 0);
                      Color textColor =
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : const Color.fromARGB(255, 255, 255, 255);
                      Color iconColor =
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : const Color.fromARGB(255, 255, 255, 255);

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
                          tileColor: tileColor,
                          textColor: textColor,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _updateTaskStatus(
                                      taskId,
                                      isDoing ? 'To-Do' : 'Currently Doing',
                                      isDoing ? 'Currently Doing' : 'To-Do');
                                },
                                child: Icon(
                                  isDoing ? Icons.star : Icons.star_border,
                                  color: isDoing ? Colors.white : null,
                                ),
                              ),
                              const SizedBox(width: 23),
                              GestureDetector(
                                onTap: () {
                                  _showEditDialog(taskId, task);
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: iconColor,
                                ),
                              ),
                            ],
                          ),

                          leading: Checkbox(
                            checkColor: Colors.black,
                            value: isDone,
                            onChanged: (bool? value) {
                              _updateTaskStatus(
                                  taskId,
                                  value! ? 'Done' : 'To-Do',
                                  isDone ? 'Done' : 'To-Do');
                            },
                          ),

                          title: Text(
                            task['name'],
                            style: GoogleFonts.itim(
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            task['description'],
                            style: GoogleFonts.itim(),
                          ),
                          // Add more UI elements here as needed.
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
