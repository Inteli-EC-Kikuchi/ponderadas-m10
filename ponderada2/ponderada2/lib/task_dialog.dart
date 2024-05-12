import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  
  final String? initialName;
  final String? initialDescription;

  const AddTaskDialog({super.key, this.initialName, this.initialDescription});
  
  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Task Name'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Pass the entered data back to the calling widget
            Navigator.of(context).pop({
              'name': _nameController.text,
              'description': _descriptionController.text,
            });
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
