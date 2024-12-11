import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';

// Handle firestore operations related to task
class FirebaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Sync a list of tasks to Firestore.
  Future<void> syncTasksToFirebase(List<Task> tasks) async {
    for (var task in tasks) {
      await _firestore.collection('tasks').doc(task.id.toString()).set(task.toMap());
    }
  }
  //Fetches all tasks from the 'tasks' collection in Firestore.
  // Returns a list of Task objects mapped from the fetched data.
  Future<List<Task>> fetchTasksFromFirebase() async {
    final querySnapshot = await _firestore.collection('tasks').get();
    return querySnapshot.docs
        .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
  //Adds a single task to Firestore.
  // The task is added as a new document in the 'tasks' collection.
  Future<void> addTaskToFirebase(Task task) async {
    final collection = FirebaseFirestore.instance.collection('tasks');
    await collection.add(task.toMap());
  }

}
