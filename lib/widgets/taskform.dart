import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskForm extends StatefulWidget {
  final Function(String title, String description) onSubmit;

  TaskForm({required this.onSubmit});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();  //key to manage the form state
  String _title = '';   // this is the variable to store task title
  String _description = ''; //this is the variable to store task description

  // this is the Method to validate and submit the form

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

            // this is the textfield to entering the task description
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

            // this elevated button is used to trigger froms submission
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
