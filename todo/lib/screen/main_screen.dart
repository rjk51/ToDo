import 'package:flutter/material.dart';
import 'package:todo/screen/add_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Index for the selected tab

  // Function to change the selected tab
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TaskEntryScreen()));
            },
          ),
        ],
      ),
      body: const Center(child: TodoTaskList()), // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Currently selected tab
        onTap: _onTabSelected, // Function to handle tab selection
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'To-Do',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Currently Doing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Done',
          ),
        ],
      ),
    );
  }
}

class TodoTaskList extends StatelessWidget {
  const TodoTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('status',
                isEqualTo: 'To-Do') // Adjust the field and value accordingly
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(
                  task['name'],
                ),
                subtitle: Text(task['description']),
                // Add more UI elements here as needed.
              );
            },
          );
        },
      ),
    );
  }
}
