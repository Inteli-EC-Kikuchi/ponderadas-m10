import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticationController {
  static Future<bool> loginUser(String username, String password) async {
    final url = Uri.parse('http://192.168.1.102:8000/api/users/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Login successful
      return true;
    } else {
      return false;
    }
  }
}
