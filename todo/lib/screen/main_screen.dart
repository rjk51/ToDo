import 'package:flutter/material.dart';
import 'package:todo/screen/add_task.dart';
import 'package:todo/widgets/task_list.dart';
import 'package:google_fonts/google_fonts.dart';

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

  Widget _buildSelectedPage(int index) {
    switch (index) {
      case 0:
        return const TodoTaskList(status: 'To-Do');
      case 1:
        return const TodoTaskList(status: 'Currently Doing');
      case 2:
        return const TodoTaskList(status: 'Done');
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TODO',
          style: GoogleFonts.jacquesFrancoisShadow(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TaskEntryScreen()));
            },
          ),
        ],
      ),
      body: _buildSelectedPage(_selectedIndex), // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffd88e43),
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
