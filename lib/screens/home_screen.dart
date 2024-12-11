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
  int _currentIndex = 0;

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
