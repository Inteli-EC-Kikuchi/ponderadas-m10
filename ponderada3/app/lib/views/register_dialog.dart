import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class RegisterDialog extends StatefulWidget {
  const RegisterDialog({super.key});

  @override
  _RegisterDialogState createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Register New User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
            onChanged: (value) {
                logger.i("Username field changed: $value");
              },
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onChanged: (_) {
                logger.i("Password field changed");
              },
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            logger.i("Cancel button from registry pressed");
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            logger.i("Register button pressed");
            Navigator.of(context).pop({
              'username': _usernameController.text,
              'password': _passwordController.text,
            });
          },
          child: const Text('Register'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
