import 'package:flutter/material.dart';
import 'todo.dart';
import 'login.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to your Todo List, {%user%}"),
      ),
      body: const Row(
        children: [
          Expanded(child: Todo()),
          Expanded(child: Todo()),
          Expanded(child: Todo()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class Test extends StatelessWidget {

  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}