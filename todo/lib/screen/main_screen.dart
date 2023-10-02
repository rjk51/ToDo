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
  int _selectedIndex = 0;

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

    Color textColor =
    Theme.of(context).brightness == Brightness.dark
      ? const Color.fromARGB(255, 255, 255, 255)
      : const Color.fromARGB(255, 0, 0, 0);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/todol1.png',
              width: 45,
              height: 45,
            ),
            const SizedBox(width: 13),
            Text(
              'TODO',
              style: GoogleFonts.jacquesFrancoisShadow(
                fontSize: 30,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
      body: _buildSelectedPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
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
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TaskEntryScreen()),
            );
          },
          backgroundColor: Colors.grey,
          child: const Icon(
            Icons.add,
            size: 35,
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
