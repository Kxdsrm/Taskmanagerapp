import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utility/firebase_helper.dart';
import '../utils/database_helper.dart';
import '../widgets/task_list_item.dart';
import '../widgets/taskform.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final FirebaseHelper _firebaseHelper = FirebaseHelper();

  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    _searchController.addListener(_filterTasks);
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        _handleConnectivityChange(results.first);
      }
    });
  }


  Future<void> _checkConnectivity() async {
    final connectivityResults = await Connectivity().checkConnectivity();

    if (connectivityResults.isNotEmpty) {
      _handleConnectivityChange(connectivityResults.first);
    } else {
      _handleConnectivityChange(ConnectivityResult.none);
    }
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    ScaffoldMessenger.of(context).clearSnackBars();

    if (result == ConnectivityResult.none) {
      _showConnectivitySnackBar(
        'No internet connection.',
        Colors.red,
        Icons.signal_cellular_connected_no_internet_4_bar,
      );
    } else {
      _showConnectivitySnackBar(
        'Internet connected,syncing tasks',
        Colors.green,
        Icons.wifi,
      );
      _syncTasksWithFirebase();
    }
  }

  void _showConnectivitySnackBar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 10),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _fetchTasks() async {
    final tasks = await _dbHelper.fetchTasks();
    setState(() {
      _tasks = tasks;
      _filteredTasks = tasks;
    });
  }

  void _filterTasks() {
    final query = _searchController.text.toLowerCase();
    final filteredTasks = _tasks.where((task) {
      return task.title!.toLowerCase().contains(query) ||
          task.description!.toLowerCase().contains(query);
    }).toList();

    setState(() {
      _filteredTasks = filteredTasks;
    });
  }

  void _addTask(Task task) async {
    try {
      await _dbHelper.addTask(task);
      print('Task added: ${task.title}, ${task.description}');
      _fetchTasks();
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  void _updateTask(Task task) async {
    await _dbHelper.updateTask(task);
    _fetchTasks();
  }

  void _deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    _fetchTasks();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green),
            SizedBox(width: 10),
            Text(
              'Task is deleted successfully',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  void _showAddTaskForm() {
    showModalBottomSheet(
      backgroundColor: Colors.black87,
      context: context,
      builder: (_) => TaskForm(
        onSubmit: (title, description) {
          final task = Task(title: title, description: description);
          _addTask(task);
        },
      ),
    );
  }

  void _showUpdateTaskForm(Task task) {
    showModalBottomSheet(
      backgroundColor: Colors.black87,
      context: context,
      builder: (_) => TaskForm(
        onSubmit: (title, description) {
          task.title = title;
          task.description = description;
          _updateTask(task);
        },
      ),
    );
  }

  Future<void> _syncTasksWithFirebase() async {
    final localTasks = await _dbHelper.fetchTasks();
    await _firebaseHelper.syncTasksToFirebase(localTasks);
    print('Tasks synced with Firebase!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search tasks",
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _showAddTaskForm,
        child: Icon(Icons.add),
      ),
      body: _filteredTasks.isEmpty
          ? Center(child: Text("No tasks found!"))
          : ListView.builder(
        itemCount: _filteredTasks.length,
        itemBuilder: (context, index) {
          final task = _filteredTasks[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TaskListItem(
              task: task,
              onDelete: () => _deleteTask(task.id!),
              onUpdate: () => _showUpdateTaskForm(task),
            ),
          );
        },
      ),
    );
  }
}
