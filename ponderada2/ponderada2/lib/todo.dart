import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Todo extends StatelessWidget {
  final List<TodoItem> todos;

  const Todo({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return _buildTodoItem(todo);
          },
        ),
      ),
    );
  }

  Widget _buildTodoItem(TodoItem todo) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(todo.description),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    debugPrint("Edited Task successfully!");
                    
                  },
                  mini: true,
                  child: Icon(Icons.edit),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () async {
                    debugPrint("Deleting Task...");
                    await _deleteTask(todo.id);
                    debugPrint("Task deleted successfully!");
                  },
                  mini: true,
                  child: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask(int id) async {
    final Uri uri = Uri.parse('http://192.168.1.101:3333/tasks/$id');

    try {
      final response = await http.delete(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 202) {
        debugPrint('Task deleted successfully!');
      } else {
        debugPrint('Failed to delete task');
      }
    } catch (e) {
      debugPrint('Failed to delete task');
    }
  }
}

class TodoItem {
  final String title;
  final String description;
  final int id;

  TodoItem({required this.id, required this.title, required this.description});
}