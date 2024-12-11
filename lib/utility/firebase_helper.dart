import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';


class FirebaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> syncTasksToFirebase(List<Task> tasks) async {
    for (var task in tasks) {
      await _firestore.collection('tasks').doc(task.id.toString()).set(task.toMap());
    }
  }

  Future<List<Task>> fetchTasksFromFirebase() async {
    final querySnapshot = await _firestore.collection('tasks').get();
    return querySnapshot.docs
        .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
  Future<void> addTaskToFirebase(Task task) async {
    final collection = FirebaseFirestore.instance.collection('tasks');
    await collection.add(task.toMap());
  }

}
