import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

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
