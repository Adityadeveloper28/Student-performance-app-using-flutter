import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    Map<String, String> body = {
      'email': email,
      'password': password,
    };

    final apiUrl = Uri.parse('https://server-rj2m.onrender.com/admin/login');
    try {
      final response = await http.post(
        apiUrl,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the response body to extract role information
        final responseData = json.decode(response.body);
        String? role =
            responseData['role'].toString(); // Convert role to string
        if (role == '1') {
          // Check if role is '1' as string
          // Role is admin, navigate to dashboard
          Navigator.pushNamed(context, 'Pie');
        } else {
          // Role is not admin, show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You do not have admin privileges.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Login failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Admin login failed: ${response.statusCode}'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      // Handle network errors or other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during admin login: $error'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'login');
              },
              child: Text('Student Login'),
            ),
          ],
        ),
      ),
    );
  }
}
