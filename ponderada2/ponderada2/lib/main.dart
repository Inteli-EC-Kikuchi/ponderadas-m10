import 'package:flutter/material.dart';
import 'todo.dart';
import 'login.dart';
import 'task_dialog.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple
      ),
      home: const Login(),
      routes: {"/todo": (BuildContext context) => const RootPage()},
    );
  }
}





class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  List<TodoItem> todos = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
  print('fetchTasks');
  final response = await http.get(Uri.parse('http://192.168.1.101:3333/tasks'));
  if (response.statusCode == 200) {
    final dynamic data = jsonDecode(response.body);
    if (data.containsKey('todos')) {
      List<TodoItem> fetchedTodos = [];
      for (var item in data['todos']) {
        print(item);
        fetchedTodos.add(TodoItem(
          title: item['name'],
          description: item['description'],
          id: item['id'],
        ));
      }
      setState(() {
        todos = fetchedTodos;
      });
    } else {
      throw Exception('Invalid response format: "todos" property not found');
    }
  } else {
    throw Exception('Failed to load tasks');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to your Todo List"),
      ),
      body: Row(
        children: [
          Expanded(child: Todo(todos: todos)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          
          final Map<String, String?>? result = await showDialog(
            context: context,
            builder: (BuildContext context) => AddTaskDialog(),
          );

          if (result != null) {

            final String name = result['name'] ?? '';
            final String description = result['description'] ?? '';
            const int userId = 1;

            _createTask(name, description, userId).then((_) => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RootPage()),
              ),
            });
          }

        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _createTask(String name, String description, int userId) async {
    final Uri uri = Uri.parse('http://192.168.1.101:3333/tasks');

    try {
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'description': description,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 201) {
      debugPrint('Task created successfully!');
      // Optionally, you can perform any additional actions after creating the task
    } else {
      debugPrint('Failed to create task. Status code: ${response.statusCode}');
    }
  } catch (error) {
    debugPrint('Error creating task: $error');
  }
  }
}

class Test extends StatelessWidget {

  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}