import 'package:flutter/material.dart';
import 'package:taskmanagerapp/screens/tasklistscreen.dart';
import '../widgets/taskform.dart';
import 'search_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Index of the currently selected tab in the BottomNavigationBar
  int _currentIndex = 0;

  // List of widgets corresponding to each tab
  final List<Widget> _tabs = [
    TaskListScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
// Method to show the add task form as a modal bottom sheet
  void _showAddTaskForm() {
    showModalBottomSheet(backgroundColor: Colors.black87,
      context: context,
      builder: (_) => TaskForm(
        onSubmit: (title, description) {
          setState(() {
            print('Task Added: $title, $description');

          });
        },
      ),
    );
  }
}
