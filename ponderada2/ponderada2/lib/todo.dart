import 'dart:convert';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'task_dialog.dart';

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
            return _buildTodoItem(context, todo);
          },
        ),
      ),
    );
  }

  Widget _buildTodoItem(BuildContext context, TodoItem todo) {
  return Card(
    margin: const EdgeInsets.all(10),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            todo.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(todo.description),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () async {
                  final Map<String, String?>? result = await showDialog(
                    context: context,
                    builder: (BuildContext context) => AddTaskDialog(
                      initialName: todo.title,
                      initialDescription: todo.description,
                    ),
                  );

                  if (result != null) {
                    final String name = result['name'] ?? '';
                    final String description = result['description'] ?? '';

                    // Call _updateTask instead of _createTask
                    await _updateTask(todo.id, name, description).then((_) => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RootPage()),
                      ),
                    });
                  }
                },
                mini: true,
                child: const Icon(Icons.edit),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: () async {
                  await _deleteTask(todo.id).then((_) => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RootPage()),
                      ),
                    });
                },
                mini: true,
                child: const Icon(Icons.delete),
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

  Future<void> _updateTask(int id, String name, String description) async {
    final Uri uri = Uri.parse('http://192.168.1.101:3333/tasks/$id');

    try {
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'description': description,
        }),
      );

      if (response.statusCode == 204) {
        debugPrint('Task updated successfully!');
      } else {
        throw Exception('Failed to update task');
      }
    } catch (e) {
      throw Exception('Failed to update task');
    }
  }

}

class TodoItem {
  final String title;
  final String description;
  final int id;

  TodoItem({required this.id, required this.title, required this.description});
}