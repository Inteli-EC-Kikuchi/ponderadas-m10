import 'package:flutter/material.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.black,
              width: 1,
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Title(
                title: 'Task Title',
                color: Colors.black,
                child: const Text("Task Title")
              ),
              const Text("Task Description"),
              const SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () {
                  debugPrint("Edited Task successfully!");
                },
                mini: true,
                child: const Icon(Icons.edit),
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () {},
                mini: true,
                child: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
