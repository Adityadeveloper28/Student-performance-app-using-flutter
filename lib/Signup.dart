import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MySignup extends StatefulWidget {
  const MySignup({Key? key});

  @override
  State<MySignup> createState() => _MySignupState();
}

class _MySignupState extends State<MySignup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signup() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    Map<String, String> body = {
      'name': name,
      'email': email,
      'password': password,
    };

    final apiUrl = Uri.parse('https://server-rj2m.onrender.com/signup');
    try {
      final response = await http.post(
        apiUrl,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Registration successful, navigate to login page
        Navigator.pushNamed(context, 'login');
      } else {
        // Registration failed, show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Signup failed. Please try again.'),
        ));
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error during signup: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error during signup. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/f103cb09-60e9-4334-9bd6-f5e85c544a3c.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 85, top: 130),
              child: Text(
                'Welcome back',
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3,
                    left: 35,
                    right: 35),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          fillColor: Colors.blueGrey.shade50,
                          filled: true,
                          hintText: 'Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          fillColor: Colors.blueGrey.shade50,
                          filled: true,
                          hintText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.blueGrey.shade50,
                          filled: true,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SignUp',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            color: Colors.white,
                            onPressed: _signup,
                            icon: Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'login');
                            },
                            child: Text(
                              'Signin',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 24,
                                  color: Colors.blueGrey),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
