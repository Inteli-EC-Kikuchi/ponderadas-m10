import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../controller/authentication_controller.dart';
import 'register_dialog.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class Login extends StatelessWidget {
  Login({super.key});

  // Define TextEditingController for username and password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), 
                hintText: "Username",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (value) {
                logger.i("Username field changed: $value");
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: TextField(
              controller: _passwordController,
              obscureText: true, // To hide password
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                hintText: "Password",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.lock),
              ),
              onChanged: (value) {
                logger.i("Password field changed");
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              logger.i("Login button pressed");
              await _login(context);
            },
            child: const Text("Login"),
          ),
          ElevatedButton(
            onPressed: () async {
              logger.i("Register button pressed");
              final result = await showDialog<Map<String, String>>(
                context: context,
                builder: (BuildContext context) => const RegisterDialog(),
              );

              if (result != null) {
                 logger.i("User registration: ${result['username']}");
                final response = await http.post(
                  Uri.parse('http://192.168.1.102:8000/api/users/'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                    'name': result['username']!,
                    'password': result['password']!,
                  }),
                );

                if (response.statusCode == 200 || response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User registered successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to register user.')),
                  );
                }
              }
            },
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }

  // Function to handle login
  Future<void> _login(BuildContext context) async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      // Show error message if username or password is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    // Call loginUser method from AuthenticationController
    final bool isLoggedIn = await AuthenticationController.loginUser(username, password);

    if (isLoggedIn) {
      // After successful login, navigate to camera view
      Navigator.pushNamed(context, "/camera");
    } else {
      // Show error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please check your credentials.')),
      );
    }
  }
}
