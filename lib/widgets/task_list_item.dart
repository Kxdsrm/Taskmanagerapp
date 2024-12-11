import 'package:flutter/material.dart';
import '../models/task_model.dart';
// A stateless widget representing a single task item in the task list.
class TaskListItem extends StatelessWidget {
  final Task task;// Task object to display its details.
  final VoidCallback onUpdate;  // Callback function for updating the task.
  final VoidCallback onDelete;  // Callback function for deleting the task.
  // Constructor to initialize the required parameters.
  TaskListItem({required this.task, required this.onUpdate, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),color: Colors.black
              ),
              child: IconButton(icon: Icon(Icons.edit,color: Colors.white,), onPressed: onUpdate)),
          SizedBox(width: 10,),
          // Delete button wrapped inside a style container.
          Container(
              width: 40,height: 42,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),color: Colors.black
              ),
              child: IconButton(icon: Icon(Icons.delete,color: Colors.white,), onPressed: onDelete)),
        ],
      ),
    );
  }
}
