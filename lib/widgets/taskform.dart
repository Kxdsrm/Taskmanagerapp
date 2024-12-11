import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskForm extends StatefulWidget {
  final Function(String title, String description) onSubmit;

  TaskForm({required this.onSubmit});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(_title, _description);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: ' Title',
                hintText: 'Enter task title here',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              style: TextStyle(
                color: Colors.white, // Text color
              ),
              validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              onSaved: (value) => _title = value!,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Task Description',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                hintText: 'Enter task description here',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              style: TextStyle(
                color: Colors.white, // Text color
              ),
              validator: (value) => value!.isEmpty ? 'Enter a description' : null,
              onSaved: (value) => _description = value!,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
